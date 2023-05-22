import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/patient_screens/patient_profile.dart';
import 'package:taibahu_app/patient_screens/patient_view_doctor_evaluations.dart';
import 'package:taibahu_app/patient_screens/patient_view_tests.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/appointment_action.dart';
import '../widgets/custom_icon.dart';
import '../widgets/user_action.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Map<String, dynamic>? patientDocument;
  getPatientDocument() async {
    await firebaseFirestore
        .collection('patients')
        .doc(firebaseAuth.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        patientDocument = value.data();
      });
    });
  }

  getAndSaveToken() async {
    await firebaseMessaging.getToken().then((value) {
      firebaseFirestore
          .collection('patients')
          .doc(firebaseAuth.currentUser!.uid)
          .update({'token': value});
    });
  }

  // getNotification() async {
  //   FirebaseMessaging.onMessage.listen((event) {
  //     // print('===========');
  //     showDialog(
  //         context: context,
  //         builder: (context) => const AlertDialog(
  //               content: Text('ddddddd'),
  //             ));
  //   });
  // }
  initialMessage() async {
    var message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const PatientHomeScreen()));
      print('++++++++++++++++++++${message.notification!.body}');
    }
  }

  @override
  void initState() {
    super.initState();
    initialMessage();
    getPatientDocument();
    getAndSaveToken();
    // getNotification();
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print(event.notification!.body);
      print(event.notification!.title);
      print(event.data['name']);
      print('****************');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(top: 90, left: 30, right: 30, bottom: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Home Page',
                style: TextStyle(
                    color: mainColor,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 60,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomIcon(
                        onPressed: () {
                          // Navigator.pushNamed(context, '/user-appointments');
                          customShowModalSheetApp(context);
                        },
                        label: "Appointments",
                        icon: Icons.book_rounded,
                      ),
                      CustomIcon(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, '/patient-view-prescription');
                        },
                        label: 'View Prescription',
                        icon: Icons.contact_page_rounded,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomIcon(
                        onPressed: () {
                          // customShowModalSheet(context);
                        },
                        label: 'Book Health Awareness Session',
                        icon: Icons.menu_book_rounded,
                      ),
                      CustomIcon(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const PatientViewTests()));
                        },
                        label: "Test Results",
                        icon: Icons.analytics_rounded,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomIcon(
                        onPressed: () {
                          customShowModalSheetServiceEvaluation(context);
                        },
                        label: 'Service Evaluation',
                        icon: Icons.medical_services_rounded,
                      ),
                      CustomIcon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/patient-home-chat');
                        },
                        label: "Chat",
                        icon: Icons.email,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomIcon(
                        onPressed: () {
                          // Navigator.pushNamed(context, '/patient-profile');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PatientProfile(
                                      patientDocument: patientDocument!)));
                        },
                        label: 'Profile',
                        icon: Icons.person,
                      ),
                      CustomIcon(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.pushReplacementNamed(
                              context, '/choose-login');
                        },
                        label: 'Log out',
                        icon: Icons.logout_rounded,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> customShowModalSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            child: Column(
              children: [
                Text(
                  'Manage Users',
                  style: TextStyle(
                      fontSize: 30,
                      color: mainColor,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 30,
                ),
                UserAction(
                  onPressed: () {},
                  label: 'Add User',
                  icon: Icons.person_add_alt_1,
                ),
                const SizedBox(
                  height: 30,
                ),
                UserAction(
                  onPressed: () {},
                  label: 'Delete User',
                  icon: Icons.person_remove_alt_1_rounded,
                ),
                const SizedBox(
                  height: 30,
                ),
                UserAction(
                  onPressed: () {},
                  label: 'Update User',
                  icon: Icons.manage_accounts_rounded,
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          );
        });
  }

  Future<dynamic> customShowModalSheetApp(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Manage Appointments',
                  style: TextStyle(
                      fontSize: 30,
                      color: mainColor,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 30,
                ),
                AppointmentAction(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/patient-select-clinic');
                  },
                  label: 'Book a new appointment',
                  icon: Icons.note_add_rounded,
                ),
                const SizedBox(
                  height: 30,
                ),
                AppointmentAction(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/view-patient-app');
                  },
                  label: 'View appointments',
                  icon: Icons.book_rounded,
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          );
        });
  }

  Future<dynamic> customShowModalSheetServiceEvaluation(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Manage Evaluations',
                  style: TextStyle(
                      fontSize: 30,
                      color: mainColor,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 30,
                ),
                UserAction(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/patient-add-evaluation');
                  },
                  label: 'Add Evaluation',
                  icon: Icons.note_add_rounded,
                ),
                const SizedBox(
                  height: 30,
                ),
                UserAction(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/patient-view-evaluations');
                  },
                  label: 'View Evaluations',
                  icon: Icons.note_alt,
                ),
                const SizedBox(
                  height: 30,
                ),
                UserAction(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const PatientViewDoctorEvaluations()));
                  },
                  label: 'Doctor Evaluations',
                  icon: Icons.note_alt,
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          );
        });
  }
}
