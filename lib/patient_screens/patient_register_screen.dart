import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../widgets/custom_textfield.dart';
import 'complete_patient_profile_screen.dart';

class PatientRegisterScreen extends StatefulWidget {
  const PatientRegisterScreen({super.key});

  @override
  State<PatientRegisterScreen> createState() => _PatientRegisterScreenState();
}

class _PatientRegisterScreenState extends State<PatientRegisterScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  String? emailAddress;
  String? password;
  String? confirm;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  registerNewPatient() async {
    if (emailAddress!.contains('@taibahu.edu.sa')) {
      if (password == confirm) {
        if (password!.length >= 6) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CompletePatientProfileScreen(
                patientEmail: emailAddress!,
                password: password!,
              ),
            ),
          );
        } else {
          const snackBar = SnackBar(
            content: Text('The password provided is too weak.'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        const snackBar = SnackBar(
          content: Text('passwords are not the same ...'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      const snackBar = SnackBar(
        content: Text('email must ends with @taibahu.edu.sa'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                'images/back.png',
                fit: BoxFit.cover,
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.3)),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        'images/patient.png',
                        width: width * 0.4,
                        height: width * 0.4,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Patient Sign Up',
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
                          'Register New Account ...... !',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
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
                      CustomTextField(
                        hint: 'Confirm your password .....',
                        icon: Icons.lock,
                        label: 'Confirm Password',
                        onPressed: (value) {
                          confirm = value;
                        },
                        isSecured: true,
                        controller: confirmController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MaterialButton(
                        elevation: 5,
                        onPressed: () async {
                          await registerNewPatient();
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => CompletePatientProfileScreen(
                          //       patientEmail: emailAddress!,
                          //     ),
                          //   ),
                          // );
                        },
                        color: mainColor,
                        child: const Text(
                          'Continue...',
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
          ],
        ),
      ),
    );
  }
}
