import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/admin_screens/admin_update_patient.dart';
import 'package:taibahu_app/constants.dart';
import 'package:flutter/material.dart';

class AdminViewPatients extends StatelessWidget {
  const AdminViewPatients({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 70, left: 20, right: 20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'View Patients',
                style: mainHeaderStyle,
              ),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('patients')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            'No Patients',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textColor),
                          ),
                        );
                      }
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var item = snapshot.data!.docs[index];
                            return PatientCardInAdmin(
                              delete: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                      'Delete Patient',
                                      style: TextStyle(
                                          color: mainColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    content: Text(
                                      'Do tou want to remove the patient?',
                                      style: TextStyle(
                                          color: textColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    actions: [
                                      MaterialButton(
                                        color: mainColor,
                                        elevation: 5,
                                        onPressed: () {},
                                        child: const Text(
                                          'Ok',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      MaterialButton(
                                        color: Colors.red,
                                        elevation: 5,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                              edit: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AdminUpdatePatient(
                                              patient: item,
                                            )));
                              },
                              email: item['email'],
                              name: '${item['fname']} ${item['lname']}',
                              medical: item['medicalFileNumber'] == ''
                                  ? 'no medical file no.'
                                  : item['medicalFileNumber'],
                              medicalColor: item['medicalFileNumber'] == ''
                                  ? Colors.red
                                  : textColor,
                            );
                          });
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const Center(
                      child: Text('loading'),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class PatientCardInAdmin extends StatelessWidget {
  const PatientCardInAdmin({
    super.key,
    required this.name,
    required this.email,
    required this.edit,
    required this.delete,
    required this.medical,
    required this.medicalColor,
  });
  final String name, email, medical;
  final VoidCallback edit, delete;
  final Color medicalColor;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 15),
      width: width - 40,
      height: 150,
      decoration: BoxDecoration(
          border:
              Border.all(color: mainColor, width: 2, style: BorderStyle.solid),
          color: Colors.white,
          boxShadow: [customBoxShadow],
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: (width - 40) * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      email,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Medical File Number:',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: mainColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      medical,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: medicalColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            width: (width - 40) * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  elevation: 5,
                  color: mainColor,
                  onPressed: edit,
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                MaterialButton(
                  elevation: 5,
                  color: Colors.red,
                  onPressed: delete,
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
