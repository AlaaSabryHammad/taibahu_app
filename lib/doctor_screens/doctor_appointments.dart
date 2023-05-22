import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/constants.dart';
import 'package:taibahu_app/doctor_screens/doctor_show_completed_app_details.dart';
import 'package:taibahu_app/doctor_screens/doctor_show_medical.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'doctor_show_app.dart';
import 'refer_screens/refer_select_clinic.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class DoctorAppointments extends StatefulWidget {
  const DoctorAppointments({super.key});

  @override
  State<DoctorAppointments> createState() => _DoctorAppointmentsState();
}

class _DoctorAppointmentsState extends State<DoctorAppointments> {
  bool? isCompleted;
  PageController pageController = PageController(initialPage: 0);
  List<Widget> appScreens = [const UpcommingWidget(), const CompletedWidget()];
  int selectedIndex = 0;
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
                'View Appointments',
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

class UpcommingWidget extends StatelessWidget {
  const UpcommingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return StreamBuilder(
        stream: firebaseFirestore
            .collection('bookings')
            .where('doctorID', isEqualTo: firebaseAuth.currentUser!.uid)
            .where('status', isEqualTo: 'active')
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
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Waiting ....',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                    ),
                                    Text(
                                      'Not Refered',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 15,
                        right: 20,
                        top: 0,
                        child: Container(
                          width: 150,
                          color: mainColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              MaterialButton(
                                minWidth: 140,
                                color: Colors.white,
                                onPressed: () {
                                  if (item['medicalFileNumber'] == "") {
                                    var snackBar = const SnackBar(
                                        content: Text(
                                            'Patient has no medical file number'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DoctorShowApp(item: item),
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  'Open',
                                  style: TextStyle(
                                      color: mainColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              MaterialButton(
                                minWidth: 140,
                                color: Colors.white,
                                onPressed: () {
                                  if (item['medicalFileNumber'] == "") {
                                    var snackBar = const SnackBar(
                                        content: Text(
                                            'Patient has no medical file number'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else {
                                    firebaseFirestore
                                        .collection('patients')
                                        .doc(item['patientId'])
                                        .get()
                                        .then((value) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DoctorShowMedical(
                                            patient: value.data()!,
                                            patientId: item['patientId'],
                                          ),
                                        ),
                                      );
                                    });
                                  }
                                },
                                child: Text(
                                  'Medical File',
                                  style: TextStyle(
                                      color: mainColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              MaterialButton(
                                minWidth: 140,
                                color: Colors.white,
                                onPressed: () {
                                  if (item['medicalFileNumber'] == "") {
                                    var snackBar = const SnackBar(
                                        content: Text(
                                            'Patient has no medical file number'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else {
                                    firebaseFirestore
                                        .collection('patients')
                                        .doc(item['patientId'])
                                        .snapshots()
                                        .listen((value) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ReferSelectClinic(
                                                  oldApp: item,
                                                  patient: value.data()!),
                                        ),
                                      );
                                    });
                                  }
                                },
                                child: Text(
                                  'Refer',
                                  style: TextStyle(
                                      color: mainColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
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

class CompletedWidget extends StatelessWidget {
  const CompletedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return StreamBuilder(
        stream: firebaseFirestore
            .collection('bookings')
            .where('doctorID', isEqualTo: firebaseAuth.currentUser!.uid)
            .where('status', isEqualTo: 'completed')
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['isRefered']
                                          ? 'Refered'
                                          : 'Not Refered',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: item['isRefered']
                                              ? Colors.blue
                                              : Colors.black),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                MaterialButton(
                                  minWidth: 120,
                                  color: mainColor,
                                  elevation: 5,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DoctorShowCompletedAppDetails(
                                                    item: item)));
                                  },
                                  child: const Text(
                                    'Show',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            )
                          ],
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
