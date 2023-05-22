import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/constants.dart';
import 'package:flutter/material.dart';

class AddClinicScreen extends StatefulWidget {
  const AddClinicScreen({super.key});

  @override
  State<AddClinicScreen> createState() => _AddClinicScreenState();
}

class _AddClinicScreenState extends State<AddClinicScreen> {
  TextEditingController clinicController = TextEditingController();
  TextEditingController editController = TextEditingController();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  saveClinic() async {
    if (clinicController.text.isEmpty) {
      var snackBar = const SnackBar(content: Text('Field is empty'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      await FirebaseFirestore.instance.collection('clinics').add({
        'clinic_name': clinicController.text,
        'time': FieldValue.serverTimestamp()
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Padding(
          padding:
              const EdgeInsets.only(top: 70, left: 30, right: 30, bottom: 50),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Manage Clinics',
                  style: TextStyle(
                      color: mainColor,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: clinicController,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: 'Clinic description ....',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await saveClinic();
                      clinicController.clear();
                    },
                    icon: Icon(
                      Icons.add,
                      color: mainColor,
                      size: 40,
                    ),
                  )
                ],
              ),
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('clinics')
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (context, snapshots) {
                      if (snapshots.hasData) {
                        final clinics = snapshots.data!.docs;
                        return ListView.builder(
                            itemCount: snapshots.data!.docs.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(10),
                                width: width - 70,
                                height: 120,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: mainColor,
                                        width: 1,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [customBoxShadow]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      clinics[index]['clinic_name'],
                                      style: TextStyle(
                                          color: textColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        MaterialButton(
                                          elevation: 5,
                                          color: mainColor,
                                          onPressed: () {
                                            setState(() {
                                              editController.text =
                                                  clinics[index]['clinic_name'];
                                            });
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (context) => AlertDialog(
                                                          title: Text(
                                                            'Update Clinic',
                                                            style: TextStyle(
                                                                color:
                                                                    textColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18),
                                                          ),
                                                          content: TextField(
                                                            controller:
                                                                editController,
                                                            decoration:
                                                                const InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(),
                                                            ),
                                                          ),
                                                          actions: [
                                                            MaterialButton(
                                                              color: mainColor,
                                                              onPressed: () {
                                                                if (editController
                                                                    .text
                                                                    .isEmpty) {
                                                                  var snackBar =
                                                                      const SnackBar(
                                                                          content:
                                                                              Text('Field is empty'));
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          snackBar);
                                                                } else {
                                                                  firebaseFirestore
                                                                      .collection(
                                                                          'clinics')
                                                                      .where(
                                                                          'clinic_name',
                                                                          isEqualTo: clinics[index]
                                                                              [
                                                                              'clinic_name'])
                                                                      .limit(1)
                                                                      .get()
                                                                      .then(
                                                                          (value) {
                                                                    for (var element
                                                                        in value
                                                                            .docs) {
                                                                      firebaseFirestore
                                                                          .collection(
                                                                              'clinics')
                                                                          .doc(element
                                                                              .id)
                                                                          .update({
                                                                        'clinic_name':
                                                                            editController.text
                                                                      });
                                                                      Navigator.pop(
                                                                          context);
                                                                    }
                                                                  });
                                                                }
                                                              },
                                                              child: const Text(
                                                                'Update',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                            MaterialButton(
                                                              color: mainColor,
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                'Cancel',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            )
                                                          ],
                                                        ));
                                          },
                                          child: const Text(
                                            'Update',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        MaterialButton(
                                          elevation: 5,
                                          color: Colors.red,
                                          onPressed: () async {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      content: Text(
                                                        'Delete the clinic ...?',
                                                        style: TextStyle(
                                                            color: textColor,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      actions: [
                                                        MaterialButton(
                                                          color: mainColor,
                                                          onPressed: () async {
                                                            await firebaseFirestore
                                                                .collection(
                                                                    'clinics')
                                                                .where(
                                                                    'clinic_name',
                                                                    isEqualTo:
                                                                        clinics[index]
                                                                            [
                                                                            'clinic_name'])
                                                                .limit(1)
                                                                .get()
                                                                .then((value) {
                                                              for (var element
                                                                  in value
                                                                      .docs) {
                                                                firebaseFirestore
                                                                    .collection(
                                                                        'clinics')
                                                                    .doc(element
                                                                        .id)
                                                                    .delete();
                                                              }
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                          },
                                                          child: const Text(
                                                            'Ok',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        MaterialButton(
                                                          color: mainColor,
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        )
                                                      ],
                                                    ));
                                          },
                                          child: const Text(
                                            'Delete',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            });
                      } else if (snapshots.hasError) {
                        return Text('${snapshots.error}');
                      }
                      return const Center(
                        child: Text('There is no clinics ...'),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
