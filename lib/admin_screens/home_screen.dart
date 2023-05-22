import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/admin_screens/admin_add_lap.dart';
import 'package:taibahu_app/admin_screens/admin_manage_dates.dart';
import 'package:taibahu_app/admin_screens/admin_view_lap_doctors.dart';
import 'package:taibahu_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../screens/choose_login_screen.dart';
import '../widgets/appointment_action.dart';
import '../widgets/custom_icon.dart';
import '../widgets/user_action.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String? password, newPassword, confirm;
  resetPass() {
    print(firebaseAuth.currentUser!.email);
    firebaseAuth.currentUser!.updatePassword(newPassword!);
    firebaseFirestore
        .collection('admins')
        .doc(firebaseAuth.currentUser!.uid)
        .update({'password': newPassword});
  }

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  getAndSaveToken() async {
    await firebaseMessaging.getToken().then((value) {
      firebaseFirestore
          .collection('admins')
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
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'Home Page',
                style: TextStyle(
                    color: mainColor,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            Expanded(
                child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIcon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/user-appointments');
                      },
                      label: "Manage Users' Appointments",
                      icon: Icons.book_rounded,
                    ),
                    CustomIcon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AdminManagaDates()));
                      },
                      label: 'Manage Available Dates',
                      icon: Icons.date_range_rounded,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIcon(
                      onPressed: () {
                        customShowModalSheet(context);
                      },
                      label: 'Manage Patients',
                      icon: Icons.groups_2_rounded,
                    ),
                    CustomIcon(
                      onPressed: () {
                        customShowModalSheetApp(context);
                      },
                      label: "Manage Doctors",
                      icon: Icons.groups_2_rounded,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIcon(
                      onPressed: () {
                        customShowModalSheetPharma(context);
                      },
                      label: 'Manage Pharmacists',
                      icon: Icons.groups_2_rounded,
                    ),
                    CustomIcon(
                      onPressed: () {
                        customShowModalLap(context);
                      },
                      label: "Manage Lap. Doctors",
                      icon: Icons.groups_2_rounded,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIcon(
                      onPressed: () {
                        // customShowModalSheet(context);
                        Navigator.pushNamed(context, '/add-clinic');
                      },
                      label: 'Manage Clinics',
                      icon: Icons.apartment_rounded,
                    ),
                    CustomIcon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/admin-view-evaluations');
                      },
                      label: "Review Users' Evaluations",
                      icon: Icons.analytics_rounded,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIcon(
                      onPressed: () {
                        resetPassword(context);
                      },
                      label: 'Reset Password',
                      icon: Icons.password,
                    ),
                    CustomIcon(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushNamed(context, '/choose-login');
                      },
                      label: 'Log out',
                      icon: Icons.logout_rounded,
                    ),
                  ],
                ),
              ],
            )),
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
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Manage Patients',
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
                    Navigator.pushNamed(context, '/admin-add-patient');
                  },
                  label: 'Add Patient',
                  icon: Icons.person_add_alt_1,
                ),
                const SizedBox(
                  height: 30,
                ),
                UserAction(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/admin-view-patients');
                  },
                  label: 'View Patient',
                  icon: Icons.groups_2_rounded,
                ),
                const SizedBox(
                  height: 30,
                ),
                // UserAction(
                //   onPressed: () {},
                //   label: 'Update Patient',
                //   icon: Icons.manage_accounts_rounded,
                // ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          );
        });
  }

  Future<dynamic> customShowModalLap(BuildContext context) {
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
                  'Manage Lap Doctors',
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminAddLap(),
                      ),
                    );
                    // Navigator.pushNamed(context, '/admin-add-pharmacian');
                  },
                  label: 'Add Lap. Doctor',
                  icon: Icons.person_add_alt_1,
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
                            builder: (context) => const AdminViewLapDoctors()));

                    // Navigator.pushNamed(context, '/admin-view-pharmacists');
                  },
                  label: 'View Lap. Doctors',
                  icon: Icons.groups_2_rounded,
                ),
                const SizedBox(
                  height: 30,
                ),
                // UserAction(
                //   onPressed: () {},
                //   label: 'Update Patient',
                //   icon: Icons.manage_accounts_rounded,
                // ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          );
        });
  }

  Future<dynamic> customShowModalSheetPharma(BuildContext context) {
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
                  'Manage Pharmacists',
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
                    Navigator.pushNamed(context, '/admin-add-pharmacian');
                  },
                  label: 'Add Pharmacist',
                  icon: Icons.person_add_alt_1,
                ),
                const SizedBox(
                  height: 30,
                ),
                UserAction(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/admin-view-pharmacists');
                  },
                  label: 'View Pharmacists',
                  icon: Icons.groups_2_rounded,
                ),
                const SizedBox(
                  height: 30,
                ),
                // UserAction(
                //   onPressed: () {},
                //   label: 'Update Patient',
                //   icon: Icons.manage_accounts_rounded,
                // ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          );
        });
  }

  Future<dynamic> resetPassword(BuildContext context) {
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
                  Text(
                    'Reset Password',
                    style: TextStyle(
                        fontSize: 30,
                        color: mainColor,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: const InputDecoration(
                        hintText: 'write old password ....'),
                  ),
                  TextField(
                    onChanged: (value) {
                      newPassword = value;
                    },
                    decoration: const InputDecoration(
                        hintText: 'write new password ....'),
                  ),
                  TextField(
                    onChanged: (value) {
                      confirm = value;
                    },
                    decoration: const InputDecoration(
                        hintText: 'confirm new password ....'),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MaterialButton(
                    minWidth: 120,
                    color: mainColor,
                    onPressed: () async {
                      await firebaseFirestore
                          .collection('admins')
                          .doc(firebaseAuth.currentUser!.uid)
                          .get()
                          .then((value) async {
                        if (password == value.get('password')) {
                          if (newPassword == confirm) {
                            await resetPass();
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ChooseLoginScreen()));

                            // Navigator.pop(context);
                            var snackBar = const SnackBar(
                                content:
                                    Text('Password reset successfully ...'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            var snackBar = const SnackBar(
                                content: Text('old Password not correct ...'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        }
                      });
                      // Navigator.pop(context);
                    },
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
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
                  'Manage Doctors',
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
                    Navigator.pushNamed(context, '/add-doctor');
                  },
                  label: 'Add a new doctor',
                  icon: Icons.person_add_alt_1,
                ),
                const SizedBox(
                  height: 30,
                ),
                AppointmentAction(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/view-doctors');
                  },
                  label: 'View doctors',
                  icon: Icons.groups_2_rounded,
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
