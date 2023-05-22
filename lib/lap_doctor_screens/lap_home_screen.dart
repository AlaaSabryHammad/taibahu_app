import 'package:taibahu_app/lap_doctor_screens/lap_view_requests.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/custom_icon.dart';

class LapHomeScreen extends StatefulWidget {
  const LapHomeScreen({super.key});

  @override
  State<LapHomeScreen> createState() => _LapHomeScreenState();
}

class _LapHomeScreenState extends State<LapHomeScreen> {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  getAndSaveToken() async {
    await firebaseMessaging.getToken().then((value) {
      firebaseFirestore
          .collection('lapDoctors')
          .doc(firebaseAuth.currentUser!.uid)
          .update({'token': value});
    });
  }

  @override
  void initState() {
    super.initState();
    getAndSaveToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(top: 90, left: 30, right: 30, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Home Page',
              style: TextStyle(
                  color: mainColor, fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 60,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomIcon(
                        onPressed: () {
                          // Navigator.pushNamed(context, '/doctor-app');
                          // customShowModalSheetApp(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const LapViewRequests()));
                        },
                        label: "Lap Requests",
                        icon: Icons.book_rounded,
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
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     CustomIcon(
                  //       onPressed: () {
                  //         // Navigator.push(
                  //         //     context,
                  //         //     MaterialPageRoute(
                  //         //         builder: (context) =>
                  //         //             const DoctorViewEvaluations()));
                  //         // customShowModalSheetServiceEvaluation(context);
                  //       },
                  //       label: 'Service Evaluation',
                  //       icon: Icons.medical_services_rounded,
                  //     ),
                  //     CustomIcon(
                  //       onPressed: () {
                  //         FirebaseAuth.instance.signOut();
                  //         Navigator.pushReplacementNamed(
                  //             context, '/choose-login');
                  //       },
                  //       label: 'Log out',
                  //       icon: Icons.logout_rounded,
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
