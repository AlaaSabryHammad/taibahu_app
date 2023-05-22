import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/constants.dart';
import 'package:flutter/material.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class DoctorShowCompletedAppDetails extends StatefulWidget {
  const DoctorShowCompletedAppDetails({super.key, required this.item});
  final QueryDocumentSnapshot item;

  @override
  State<DoctorShowCompletedAppDetails> createState() =>
      _DoctorShowCompletedAppDetailsState();
}

class _DoctorShowCompletedAppDetailsState
    extends State<DoctorShowCompletedAppDetails> {
  String? patientName, patientEmail, patientId, patientAge;
  setPatientData() async {
    await firebaseFirestore
        .collection('patients')
        .doc(widget.item['patientId'])
        .get()
        .then((value) {
      setState(() {
        patientName = value.get('fname');
        patientEmail = value.get('email');
        patientId = value.get('nationalid');
        patientAge = value.get('age');
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setPatientData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: firebaseFirestore
              .collection('bookings')
              .doc(widget.item.id)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.data()!['isRefered']) {
                return const ReferedWidget();
              } else {
                return CompletedWidgetDetails(
                  patientAge: patientAge!,
                  patientEmail: patientEmail!,
                  patientId: patientId!,
                  patientName: patientName!,
                  item: widget.item,
                );
              }
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}

class CompletedWidgetDetails extends StatelessWidget {
  const CompletedWidgetDetails({
    super.key,
    required this.patientName,
    required this.patientEmail,
    required this.patientId,
    required this.patientAge,
    required this.item,
  });
  final String patientName, patientEmail, patientId, patientAge;
  final QueryDocumentSnapshot item;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
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
                    patientName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                  Text(
                    patientEmail,
                    style: const TextStyle(
                        color: Colors.grey,
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
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Prescription :',
                          style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 100,
                          decoration: const BoxDecoration(color: Colors.white),
                          child: FutureBuilder(
                              future: firebaseFirestore
                                  .collection('bookings')
                                  .doc(item.id)
                                  .collection('prescription')
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        var itemData =
                                            snapshot.data!.docs[index];
                                        return Container(
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.only(
                                                right: 10),
                                            height: 80,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [customBoxShadow],
                                              gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    mainColor,
                                                    Colors.white,
                                                    mainColor
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
                                                    itemData['item'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    '${itemData['count']}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 12,
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
                          'Test Results :',
                          style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 100,
                          decoration: const BoxDecoration(color: Colors.white),
                          child: FutureBuilder(
                              future: firebaseFirestore
                                  .collection('bookings')
                                  .doc(item.id)
                                  .collection('tests')
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        var itemData =
                                            snapshot.data!.docs[index];
                                        return Container(
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.only(
                                                right: 10),
                                            height: 80,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [customBoxShadow],
                                              gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    mainColor,
                                                    Colors.white,
                                                    mainColor
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
                                                    itemData['name'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    itemData['result'] == ""
                                                        ? 'waiting'
                                                        : '${itemData['result']}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 12,
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
                          height: 20,
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
                        Text(
                          item.get('patientDiagnosis'),
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        MaterialButton(
                          elevation: 10,
                          color: mainColor,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Done',
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
    );
  }
}

class ReferedWidget extends StatelessWidget {
  const ReferedWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double hight = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Refered Appointment',
              style: TextStyle(
                  color: textColor, fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: hight / 2,
            ),
            MaterialButton(
              padding: const EdgeInsets.symmetric(vertical: 15),
              minWidth: width - 50,
              elevation: 20,
              color: mainColor,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Done',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
