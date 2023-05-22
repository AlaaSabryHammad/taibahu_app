import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/lap_doctor_screens/lap_record_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class LapViewRequests extends StatefulWidget {
  const LapViewRequests({super.key});

  @override
  State<LapViewRequests> createState() => _LapViewRequestsState();
}

class _LapViewRequestsState extends State<LapViewRequests> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool? isCompleted;
  PageController pageController = PageController(initialPage: 0);
  List<Widget> appScreens = [const NextWidget(), const FinishedWidget()];
  int selectedIndex = 0;

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
                'View Lap Requests',
                style: TextStyle(
                  color: mainColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                      pageController.animateToPage(0,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.linear);
                    },
                    child: Text(
                      'Upcomming',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color:
                              selectedIndex == 0 ? Colors.blue : Colors.grey),
                    )),
                TextButton(
                    onPressed: () {
                      setState(() {
                        selectedIndex = 1;
                      });
                      pageController.animateToPage(1,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.linear);
                    },
                    child: Text(
                      'Completed',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color:
                              selectedIndex == 1 ? Colors.blue : Colors.grey),
                    )),
              ],
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
                children: appScreens,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NextWidget extends StatelessWidget {
  const NextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return StreamBuilder(
        stream: firebaseFirestore
            .collection('bookings')
            .where('testSend', isEqualTo: 'send')
            .orderBy('startTime', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var item = snapshot.data!.docs[index];
                  DateTime date = item['startTime'].toDate();
                  return Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.only(
                            bottom: 15, right: 5, left: 5),
                        width: width - 50,
                        height: 200,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: mainColor,
                                width: 1,
                                style: BorderStyle.solid),
                            color: Colors.white,
                            boxShadow: [customBoxShadow],
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['patientName'],
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: textColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '${date.day}/${date.month}/${date.year}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '${date.hour}:${date.minute}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 15,
                        right: 20,
                        child: MaterialButton(
                          minWidth: 140,
                          color: mainColor,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LapRecordTest(item: item),
                              ),
                            );
                          },
                          child: const Text(
                            'Open',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  );
                });
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

class FinishedWidget extends StatelessWidget {
  const FinishedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return StreamBuilder(
        stream: firebaseFirestore
            .collection('bookings')
            .where('testCompleted', isEqualTo: true)
            .orderBy('startTime', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var item = snapshot.data!.docs[index];
                  DateTime date = item['startTime'].toDate();
                  return Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.only(
                            bottom: 15, right: 5, left: 5),
                        width: width - 50,
                        height: 200,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: mainColor,
                                width: 1,
                                style: BorderStyle.solid),
                            color: Colors.white,
                            boxShadow: [customBoxShadow],
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['patientName'],
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: textColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '${date.day}/${date.month}/${date.year}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '${date.hour}:${date.minute}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 15,
                        right: 20,
                        child: MaterialButton(
                          minWidth: 140,
                          color: mainColor,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LapRecordTest(item: item),
                              ),
                            );
                          },
                          child: const Text(
                            'Edit',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  );
                });
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
