import 'package:taibahu_app/pharmacist_screens/prescriptions/pharmacist_prescriptions_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/appointment_action.dart';
import '../widgets/custom_icon.dart';
import '../widgets/user_action.dart';

class PharmacistHomePage extends StatefulWidget {
  const PharmacistHomePage({super.key});

  @override
  State<PharmacistHomePage> createState() => _PharmacistHomePageState();
}

class _PharmacistHomePageState extends State<PharmacistHomePage> {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  getAndSaveToken() async {
    await firebaseMessaging.getToken().then((value) {
      firebaseFirestore
          .collection('pharmacists')
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
                                      const PharmacistPrescriptionSearch()));
                        },
                        label: "Prescriptions",
                        icon: Icons.book_rounded,
                      ),
                      // CustomIcon(
                      //   onPressed: () {
                      //     // Navigator.push(
                      //     //   context,
                      //     //   MaterialPageRoute(
                      //     //     builder: (context) => const DoctorChatHome(),
                      //     //   ),
                      //     // );
                      //   },
                      //   label: "Chats",
                      //   icon: Icons.email,
                      // ),
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
                  // CustomIcon(
                  //   onPressed: () {
                  //     FirebaseAuth.instance.signOut();
                  //     Navigator.pushReplacementNamed(context, '/choose-login');
                  //   },
                  //   label: 'Log out',
                  //   icon: Icons.logout_rounded,
                  // ),
                ],
              ),
            ),
          ],
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
                    Navigator.pushNamed(context, '/book-patient-app');
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
}
