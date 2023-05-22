import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/constants.dart';
import 'package:flutter/material.dart';
import 'doctor_add_prescription.dart';
import 'doctor_record_test.dart';

class DoctorShowApp extends StatefulWidget {
  const DoctorShowApp({super.key, required this.item});
  final QueryDocumentSnapshot item;

  @override
  State<DoctorShowApp> createState() => _DoctorShowAppState();
}

class _DoctorShowAppState extends State<DoctorShowApp> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  TextEditingController diagController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController numController = TextEditingController();
  String? patientName, patientEmail, patientId, patientAge;
  String? description;
  int? numberOfItems;

  setPatientData() async {
    await firebaseFirestore
        .collection('patients')
        .doc(widget.item['patientId'])
        .get()
        .then((value) {
      setState(() {
        patientName = "${value['fname']} ${value['lname']}";
        patientEmail = value.get('email');
        patientId = value.get('nationalid');
        patientAge = value.get('age');
      });
    });
  }

  getDiagnosis() async {
    await firebaseFirestore
        .collection('bookings')
        .doc(widget.item.id)
        .get()
        .then((value) {
      setState(() {
        diagController.text = value.data()!['patientDiagnosis'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setPatientData();
    getDiagnosis();
  }

  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: mainColor,
        body: Column(
          children: [
            SizedBox(
              width: width,
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      patientName ?? '',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                    Text(
                      patientEmail ?? '',
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text(
                      'ID: $patientId',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Text(
                      'Age: $patientAge',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          MaterialButton(
                            elevation: 10,
                            color: textColor,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DoctorAddPrescription(
                                    item: widget.item,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'Add Prescription',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 100,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: StreamBuilder(
                                stream: firebaseFirestore
                                    .collection('bookings')
                                    .doc(widget.item.id)
                                    .collection('prescription')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          var item = snapshot.data!.docs[index];
                                          return snapshot.data!.docs.isEmpty
                                              ? const Center(
                                                  child:
                                                      Text('no prescription'),
                                                )
                                              : GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      description =
                                                          item['desc'];
                                                      numberOfItems =
                                                          item['count'];
                                                      descController.text =
                                                          item['desc'];
                                                      numController.text =
                                                          item['count']
                                                              .toString();
                                                    });
                                                    customShowModalSheetServiceEvaluation(
                                                        context,
                                                        item['item'],
                                                        item);
                                                  },
                                                  child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 10),
                                                      height: 80,
                                                      width: 80,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        gradient: LinearGradient(
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter,
                                                            colors: [
                                                              mainColor,
                                                              Colors.white,
                                                            ]),
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              item['item'],
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Text(
                                                              '${item['count']}',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                );
                                        });
                                  } else if (snapshot.hasError) {
                                    return Text('${snapshot.error}');
                                  }
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          MaterialButton(
                            elevation: 10,
                            color: textColor,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DoctorRecordTestScreen(
                                    item: widget.item,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'Request Test',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 100,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: StreamBuilder(
                                stream: firebaseFirestore
                                    .collection('bookings')
                                    .doc(widget.item.id)
                                    .collection('tests')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          var item = snapshot.data!.docs[index];
                                          return Container(
                                              padding: const EdgeInsets.all(10),
                                              margin: const EdgeInsets.only(
                                                  right: 10),
                                              height: 80,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      mainColor,
                                                      Colors.white,
                                                    ]),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      item['name'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Text(
                                                      item['result'] == ""
                                                          ? 'waiting'
                                                          : '${item['result']}',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ));
                                        });
                                  } else if (snapshot.hasError) {
                                    return Text('${snapshot.error}');
                                  }
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Patient Diagnosis',
                            style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 250,
                            child: TextField(
                              maxLines: null, // Set this
                              expands: true, // and this
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration(
                                  hintText: 'Write here ......',
                                  border: OutlineInputBorder()),
                              controller: diagController,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CheckboxListTile(
                            value: isChecked,
                            onChanged: (value) {
                              setState(() {
                                isChecked = value!;
                              });
                              firebaseFirestore
                                  .collection('bookings')
                                  .doc(widget.item.id)
                                  .update({'finished': isChecked});
                            },
                            title: Text(
                              'Check if finished',
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          MaterialButton(
                            elevation: 10,
                            color: mainColor,
                            onPressed: () {
                              firebaseFirestore
                                  .collection('bookings')
                                  .doc(widget.item.id)
                                  .update({
                                'patientDiagnosis': diagController.text,
                                'status': isChecked ? 'completed' : 'active',
                                'isWaiting': false
                              });

                              Navigator.pushReplacementNamed(
                                  context, '/doctor-app');
                            },
                            child: const Text(
                              'Finish',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> customShowModalSheetServiceEvaluation(
      BuildContext context, String itemName, QueryDocumentSnapshot qItem) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      itemName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30,
                          color: mainColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: descController,
                    onChanged: (value) {
                      description = value;
                    },
                    decoration: const InputDecoration(
                        hintText: 'write instructions ....'),
                  ),
                  TextField(
                    controller: numController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      numberOfItems = int.parse(value);
                    },
                    decoration:
                        const InputDecoration(hintText: 'Refel per month ....'),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MaterialButton(
                    minWidth: 120,
                    color: mainColor,
                    onPressed: () {
                      if (numberOfItems == null) {
                        var snackBar =
                            const SnackBar(content: Text('Complete data ...'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        firebaseFirestore
                            .collection('bookings')
                            .doc(widget.item.id)
                            .collection('prescription')
                            .doc(qItem.id)
                            .update({
                          'desc': description ?? '',
                          'count': numberOfItems,
                          'remain': numberOfItems,
                          'taken': 0
                        });
                        description = null;
                        numberOfItems = null;
                      }
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  MaterialButton(
                    minWidth: 120,
                    color: Colors.red,
                    onPressed: () async {
                      await firebaseFirestore
                          .collection('bookings')
                          .doc(widget.item.id)
                          .collection('prescription')
                          .doc(qItem.id)
                          .delete();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Remove',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
