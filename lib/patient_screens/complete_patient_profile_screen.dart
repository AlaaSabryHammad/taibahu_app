import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/profile_textfield.dart';

class CompletePatientProfileScreen extends StatefulWidget {
  const CompletePatientProfileScreen(
      {super.key, required this.patientEmail, required this.password});
  final String patientEmail;
  final String password;

  @override
  State<CompletePatientProfileScreen> createState() =>
      _CompletePatientProfileScreenState();
}

class _CompletePatientProfileScreenState
    extends State<CompletePatientProfileScreen> {
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nIDController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController allergyController = TextEditingController();
  TextEditingController chromesController = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  saveUserData() async {
    try {
      UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.patientEmail,
        password: widget.password,
      );
      await firestore.collection('patients').doc(credential.user!.uid).set({
        'medicalFileNumber': '',
        'fname': fNameController.text,
        'lname': lNameController.text,
        'socialstatus': status,
        'email': emailController.text,
        'password': widget.password,
        'nationalid': nIDController.text,
        'age': ageController.text,
        'allegry': allergyController.text,
        'chromes': chromesController.text
      });
      await credential.user!
          .updateDisplayName('${fNameController.text} ${lNameController.text}');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        const snackBar = SnackBar(
          content: Text('The password provided is too weak.'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (e.code == 'email-already-in-use') {
        const snackBar = SnackBar(
          content: Text('The account already exists for that email.'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      print(e);
    }
  }

  bool socialStatus = true;
  String status = 'married';
  @override
  void initState() {
    super.initState();
    setState(() {
      emailController.text = widget.patientEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            Padding(
              padding: const EdgeInsets.only(
                  top: 70, left: 30, right: 30, bottom: 50),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Patient Profile',
                        style: TextStyle(
                            color: mainColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ProfileTextField(
                        controller: fNameController,
                        hint: 'First Name',
                        requiredColor: Colors.red,
                        readOnly: false,
                        inputType: TextInputType.name),
                    ProfileTextField(
                        controller: lNameController,
                        hint: 'Last Name',
                        requiredColor: Colors.red,
                        readOnly: false,
                        inputType: TextInputType.name),
                    ProfileTextField(
                        controller: emailController,
                        hint: 'email address',
                        requiredColor: Colors.white,
                        readOnly: true,
                        inputType: TextInputType.emailAddress),
                    ProfileTextField(
                        controller: nIDController,
                        hint: 'National ID',
                        requiredColor: Colors.red,
                        readOnly: false,
                        inputType: TextInputType.number),
                    ProfileTextField(
                      controller: ageController,
                      hint: 'Age',
                      requiredColor: Colors.red,
                      readOnly: false,
                      inputType: TextInputType.number,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              socialStatus = true;
                              status = 'married';
                            });
                          },
                          child: Container(
                            width: 100,
                            height: 50,
                            decoration: BoxDecoration(
                                color: socialStatus
                                    ? mainColor
                                    : Colors.grey.withOpacity(0.5)),
                            child: const Center(
                              child: Text(
                                'Married',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              socialStatus = false;
                              status = 'single';
                            });
                          },
                          child: Container(
                            width: 100,
                            height: 50,
                            decoration: BoxDecoration(
                                color: socialStatus
                                    ? Colors.grey.withOpacity(0.5)
                                    : mainColor),
                            child: const Center(
                              child: Text(
                                'Single',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ProfileTextField(
                        controller: allergyController,
                        hint: 'Allergy',
                        requiredColor: Colors.red,
                        readOnly: false,
                        inputType: TextInputType.text),
                    ProfileTextField(
                        controller: chromesController,
                        hint: 'Chromes Diseases',
                        requiredColor: Colors.red,
                        readOnly: false,
                        inputType: TextInputType.text),
                    MaterialButton(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      color: mainColor,
                      elevation: 15,
                      onPressed: () {
                        if (fNameController.text == '' ||
                            lNameController.text == '' ||
                            nIDController.text == '' ||
                            ageController.text == '' ||
                            allergyController.text == '' ||
                            chromesController.text == '') {
                          const snackBar = SnackBar(
                            content: Text('Complete empty fields ...'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          saveUserData();
                          Navigator.pushReplacementNamed(
                              context, '/patient-register-success');
                        }
                      },
                      child: const Text(
                        'Done',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
