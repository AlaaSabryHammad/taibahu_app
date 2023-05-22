import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/doctor_screens/refer_screens/refer_select_doctor.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

class ReferSelectClinic extends StatefulWidget {
  const ReferSelectClinic(
      {super.key,
      // required this.patientId,
      // required this.patientName,
      required this.oldApp,
      required this.patient});
  // final String patientId;
  // final String patientName;
  final QueryDocumentSnapshot oldApp;
  final Map<String, dynamic> patient;
  @override
  State<ReferSelectClinic> createState() => _ReferSelectClinicState();
}

class _ReferSelectClinicState extends State<ReferSelectClinic> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  QueryDocumentSnapshot? clinicDocument;
  int? SelectedIndex;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 70, left: 20, right: 20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'Select Clinic',
                style: TextStyle(
                    color: mainColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ),
            Expanded(
                child: FutureBuilder(
                    future: firebaseFirestore.collection('clinics').get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var item = snapshot.data!.docs[index];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    SelectedIndex = index;
                                  });
                                  clinicDocument = item;
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  width: width - 40,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: SelectedIndex == index
                                        ? mainColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [customBoxShadow],
                                    border: Border.all(
                                        color: mainColor,
                                        width: 1,
                                        style: BorderStyle.solid),
                                  ),
                                  child: Center(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        item['clinic_name'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: SelectedIndex == index
                                                ? Colors.white
                                                : textColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const Center(child: CircularProgressIndicator());
                    })),
            MaterialButton(
              padding: const EdgeInsets.all(10),
              elevation: 10,
              minWidth: width - 40,
              color: mainColor,
              onPressed: () {
                if (clinicDocument != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReferSelectDoctor(
                                clinicDocument: clinicDocument!,
                                // patientId: widget.patientId,
                                // patientName: widget.patientName,
                                oldApp: widget.oldApp, patient: widget.patient,
                              )));
                } else {
                  var snackBar = const SnackBar(content: Text('Select clinic'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: const Text(
                'Next',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
