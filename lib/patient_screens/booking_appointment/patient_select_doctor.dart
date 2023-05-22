import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/patient_screens/booking_appointment/patient_select_date.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

class PatientSelectDoctor extends StatefulWidget {
  const PatientSelectDoctor({super.key, required this.clinicDocument});
  final QueryDocumentSnapshot clinicDocument;
  @override
  State<PatientSelectDoctor> createState() => _PatientSelectDoctorState();
}

class _PatientSelectDoctorState extends State<PatientSelectDoctor> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  QueryDocumentSnapshot? doctorDocument;
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
                'Select Doctor',
                style: TextStyle(
                    color: mainColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ),
            Expanded(
                child: FutureBuilder(
                    future: firebaseFirestore
                        .collection('doctors')
                        .where('clinic',
                            isEqualTo: widget.clinicDocument.get('clinic_name'))
                        .get(),
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
                                  doctorDocument = item;
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
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
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const CircleAvatar(
                                          radius: 30,
                                          backgroundImage:
                                              AssetImage('images/girl.png'),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          item['name'],
                                          style: TextStyle(
                                              color: SelectedIndex == index
                                                  ? Colors.white
                                                  : textColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
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
                if (doctorDocument != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PatientSelectDate(
                                clinicDocument: widget.clinicDocument,
                                doctorDocument: doctorDocument!,
                              )));
                } else {
                  var snackBar = const SnackBar(content: Text('Select doctor'));
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
