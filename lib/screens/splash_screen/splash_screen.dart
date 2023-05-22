import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/admin_screens/home_screen.dart';
import 'package:taibahu_app/doctor_screens/doctor_home_screen.dart';
import 'package:taibahu_app/lap_doctor_screens/lap_home_screen.dart';
import 'package:taibahu_app/patient_screens/patient_home_screen.dart';
import 'package:taibahu_app/pharmacist_screens/pharmacist_home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  checkTypeOfUser() {
    if (user != null) {
      String userId = user!.uid;
      firebaseFirestore.collection('patients').doc(userId).get().then((value) {
        if (value.exists) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const PatientHomeScreen()));
        } else {
          firebaseFirestore
              .collection('doctors')
              .doc(userId)
              .get()
              .then((value) {
            if (value.exists) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DoctorHomeScreen()));
            } else {
              firebaseFirestore
                  .collection('lapDoctors')
                  .doc(userId)
                  .get()
                  .then((value) {
                if (value.exists) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LapHomeScreen()));
                } else {
                  firebaseFirestore
                      .collection('pharmacists')
                      .doc(userId)
                      .get()
                      .then((value) {
                    if (value.exists) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const PharmacistHomePage()));
                    } else {
                      firebaseFirestore
                          .collection('admins')
                          .doc(userId)
                          .get()
                          .then((value) {
                        if (value.exists) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()));
                        } else {
                          Navigator.pushReplacementNamed(
                              context, '/choose-login');
                        }
                      });
                    }
                  });
                }
              });
            }
          });
        }
      });
      // firebaseFirestore.collection('doctors').doc(userId).get().then((value) {
      //   if (value.exists) {
      //     Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) => const DoctorHomeScreen()));
      //   }
      // });
      // firebaseFirestore
      //     .collection('lapDoctors')
      //     .doc(userId)
      //     .get()
      //     .then((value) {
      //   if (value.exists) {
      //     Navigator.pushReplacement(context,
      //         MaterialPageRoute(builder: (context) => const LapHomeScreen()));
      //   }
      // });
      // firebaseFirestore
      //     .collection('pharmacists')
      //     .doc(userId)
      //     .get()
      //     .then((value) {
      //   if (value.exists) {
      //     Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) => const PharmacistHomePage()));
      //   }
      // });
      // firebaseFirestore.collection('admins').doc(userId).get().then((value) {
      //   if (value.exists) {
      //     Navigator.pushReplacement(context,
      //         MaterialPageRoute(builder: (context) => const HomeScreen()));
      //   }
      // });
    }
  }

  saveAdmin() async {
    await FirebaseFirestore.instance
        .collection('admins')
        .where('email', isEqualTo: 'admin@taibahu.edu.sa')
        .get()
        .then((value) async {
      if (value.docs.isEmpty) {
        FirebaseApp app = await Firebase.initializeApp(
            name: 'Secondary', options: Firebase.app().options);
        try {
          UserCredential userCredential =
              await FirebaseAuth.instanceFor(app: app)
                  .createUserWithEmailAndPassword(
                      email: 'admin@taibahu.edu.sa', password: '123456789');
          await firebaseFirestore
              .collection('admins')
              .doc(userCredential.user!.uid)
              .set({
            'email': 'admin@taibahu.edu.sa',
            'password': '123456789',
            'type': 'admin'
          });
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacementNamed(context, '/choose-login');
          });
        } on FirebaseAuthException {}
        await app.delete();
      }

      //
      Future.delayed(const Duration(seconds: 2), () {
        checkTypeOfUser();
        // Navigator.pushReplacementNamed(context, '/choose-login');
      });
    });
  }

  @override
  void initState() {
    super.initState();
    saveAdmin();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'logo',
              child: Image.asset(
                'images/logo.png',
                width: width * 0.4,
                height: width * 0.4,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'TAIBAH CARE',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
