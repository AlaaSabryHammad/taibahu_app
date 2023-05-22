import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class PatientAppDetails extends StatelessWidget {
  const PatientAppDetails(
      {super.key,
      required this.clinicDocument,
      required this.doctorDocument,
      required this.startDate,
      required this.endDate});
  final QueryDocumentSnapshot clinicDocument;
  final QueryDocumentSnapshot doctorDocument;
  final DateTime startDate;
  final DateTime endDate;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(top: 120, left: 20, right: 20, bottom: 20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'Appointments Details',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: mainColor),
              ),
            ),
            Expanded(
                child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [customBoxShadow],
                  border: Border.all(
                      color: mainColor, width: 2, style: BorderStyle.solid)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Clinic Name :",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: mainColor),
                    ),
                  ),
                  Text(
                    "${clinicDocument.get('clinic_name')}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Doctor Name :",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: mainColor),
                    ),
                  ),
                  Text(
                    "${doctorDocument.get('name')}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Start Time :",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: mainColor),
                    ),
                  ),
                  Text(
                    "$startDate",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "End Time :",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: mainColor),
                    ),
                  ),
                  Text(
                    "$endDate",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor),
                  ),
                ],
              ),
            )),
            MaterialButton(
              minWidth: width - 50,
              padding: const EdgeInsets.symmetric(vertical: 20),
              elevation: 15,
              color: mainColor,
              onPressed: () async {
                await firebaseFirestore
                    .collection('doctors')
                    .doc(doctorDocument.id)
                    .collection('appointments')
                    .add({
                  'startTime': startDate,
                  'endTime': endDate,
                  'status': 'booked'
                });
                await firebaseFirestore
                    .collection('patients')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .get()
                    .then((value) async {
                  await firebaseFirestore.collection('bookings').add({
                    'patientId': FirebaseAuth.instance.currentUser!.uid,
                    'medicalFileNumber': value.get('medicalFileNumber'),
                    'patientName':
                        FirebaseAuth.instance.currentUser!.displayName,
                    'startTime': startDate,
                    'endTime': endDate,
                    'clinic': clinicDocument.get('clinic_name'),
                    'clinicID': clinicDocument.id,
                    'doctor': doctorDocument.get('name'),
                    'doctorID': doctorDocument.id,
                    'status': 'active',
                    'isWaiting': true,
                    'isRefered': false,
                    'testCompleted': false,
                    'preCompleted': false
                  });
                });
                Navigator.pushReplacementNamed(
                    context, '/patient-book-app-success');
              },
              child: const Text(
                'Confirm Appointment',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}
