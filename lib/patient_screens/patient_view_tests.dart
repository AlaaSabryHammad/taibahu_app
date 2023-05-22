import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class PatientViewTests extends StatefulWidget {
  const PatientViewTests({super.key});

  @override
  State<PatientViewTests> createState() => _PatientViewTestsState();
}

class _PatientViewTestsState extends State<PatientViewTests> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  List<QueryDocumentSnapshot> queryItems = [];

  getTests() async {
    await firebaseFirestore
        .collection('bookings')
        .where('patientId', isEqualTo: firebaseAuth.currentUser!.uid)
        .where('tests', isEqualTo: true)
        .get()
        .then((value) async {
      for (var item in value.docs) {
        setState(() {
          queryItems.add(item);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getTests();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(top: 70, left: 20, right: 20, bottom: 20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'My Lap. Records',
                style: mainHeaderStyle,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            queryItems.isEmpty
                ? Expanded(
                    child: Center(
                      child: Text(
                        'No Tests',
                        style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                        itemCount: queryItems.length,
                        itemBuilder: (context, index) {
                          DateTime dateTime =
                              queryItems[index]['startTime'].toDate();
                          return Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.all(10),
                            width: width - 40,
                            height: height * 0.35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [customBoxShadow],
                              border: Border.all(
                                  color: mainColor,
                                  width: 2,
                                  style: BorderStyle.solid),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  queryItems[index]['doctor'],
                                  style: TextStyle(
                                      color: mainColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  queryItems[index]['clinic'],
                                  style: TextStyle(
                                      color: textColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '$dateTime',
                                  style: TextStyle(
                                      color: textColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                    child: StreamBuilder(
                                        stream: firebaseFirestore
                                            .collection('bookings')
                                            .doc(queryItems[index].id)
                                            .collection('tests')
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return ListView.builder(
                                                itemCount:
                                                    snapshot.data!.docs.length,
                                                itemBuilder: (context, index) {
                                                  var xData = snapshot
                                                      .data!.docs[index];
                                                  return Card(
                                                    elevation: 10,
                                                    child: ListTile(
                                                      title: Text(
                                                        "Test :${xData['name']}",
                                                        style: TextStyle(
                                                            color: mainColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      subtitle: Text(
                                                        xData['result'] == ""
                                                            ? 'Not Recorded'
                                                            : 'Result : ${xData['result']}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color: textColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  );
                                                });
                                          } else if (snapshot.hasError) {
                                            return Text('${snapshot.error}');
                                          }
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }))
                              ],
                            ),
                          );
                        }),
                  ),
          ],
        ),
      ),
    );
  }
}
