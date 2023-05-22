import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/lap_doctor_screens/lap_home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/custom_textfield.dart';

class LapLoginScreen extends StatefulWidget {
  const LapLoginScreen({super.key});

  @override
  State<LapLoginScreen> createState() => _LapLoginScreenState();
}

class _LapLoginScreenState extends State<LapLoginScreen> {
  String? emailAddress;
  String? password;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Hero(
                    tag: 'lap',
                    child: Image.asset(
                      'images/lap.png',
                      width: width * 0.4,
                      height: width * 0.4,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Lap. Doctor Login',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Login to continue ...... !',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomTextField(
                    hint: 'Enter your email address .....',
                    icon: Icons.email,
                    label: 'Email Adress',
                    onPressed: (value) {
                      emailAddress = value;
                    },
                    isSecured: false,
                    controller: emailController,
                  ),
                  CustomTextField(
                    hint: 'Enter your password .....',
                    icon: Icons.lock,
                    label: 'Password',
                    onPressed: (value) {
                      password = value;
                    },
                    isSecured: true,
                    controller: passwordController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    elevation: 5,
                    onPressed: () async {
                      try {
                        final credential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: emailAddress!, password: password!);
                        await firebaseFirestore
                            .collection('lapDoctors')
                            .doc(credential.user!.uid)
                            .get()
                            .then((value) {
                          if (value.exists) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const LapHomeScreen()));
                          } else {
                            const snackBar = SnackBar(
                                content: Text('login data not correct ...'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        });
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          const snackBar = SnackBar(
                              content: Text('No user found for that email.'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else if (e.code == 'wrong-password') {
                          const snackBar = SnackBar(
                              content: Text('login data not correct ...'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }
                    },
                    color: mainColor,
                    child: const Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          letterSpacing: 1.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
