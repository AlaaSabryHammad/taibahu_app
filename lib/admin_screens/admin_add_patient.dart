import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_textfield.dart';

class AdminAddPatient extends StatefulWidget {
  const AdminAddPatient({super.key});

  @override
  State<AdminAddPatient> createState() => _AdminAddPatientState();
}

class _AdminAddPatientState extends State<AdminAddPatient> {
  String? fname;
  String? lname;
  String? email;
  String? password;
  String? age;
  String? nationalId;
  String? allegry;
  String? chromes;
  String? medicalnumber;
  bool socialStatus = true;
  String status = 'married';

  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 70, left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  'images/patient.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Add Patient',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: mainColor),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  onPressed: (value) {
                    fname = value;
                  },
                  label: 'First Name',
                  hint: 'first name ...',
                  icon: Icons.person,
                  isSecured: false,
                  controller: fnameController,
                ),
                CustomTextField(
                  onPressed: (value) {
                    lname = value;
                  },
                  label: 'Last Name',
                  hint: 'last name ...',
                  icon: Icons.person,
                  isSecured: false,
                  controller: lnameController,
                ),
                CustomTextField(
                  onPressed: (value) {
                    medicalnumber = value;
                  },
                  label: 'File Medical Number',
                  hint: 'file medical number ...',
                  icon: Icons.numbers,
                  isSecured: false,
                  controller: lnameController,
                ),
                CustomTextField(
                  onPressed: (value) {
                    age = value;
                  },
                  label: 'Age',
                  hint: 'age ...',
                  icon: Icons.date_range,
                  isSecured: false,
                  controller: fnameController,
                ),
                CustomTextField(
                  onPressed: (value) {
                    nationalId = value;
                  },
                  label: 'National ID',
                  hint: 'national id ...',
                  icon: Icons.person,
                  isSecured: false,
                  controller: fnameController,
                ),
                CustomTextField(
                  onPressed: (value) {
                    allegry = value;
                  },
                  label: 'Allergy',
                  hint: 'allergy ...',
                  icon: Icons.health_and_safety,
                  isSecured: false,
                  controller: fnameController,
                ),
                CustomTextField(
                  onPressed: (value) {
                    chromes = value;
                  },
                  label: 'Chromes Diseases',
                  hint: 'Chromes Diseases ...',
                  icon: Icons.health_and_safety,
                  isSecured: false,
                  controller: fnameController,
                ),
                CustomTextField(
                  onPressed: (value) {
                    email = value;
                  },
                  label: 'Email Address',
                  hint: 'email address ...',
                  icon: Icons.email,
                  isSecured: false,
                  controller: emailController,
                ),
                CustomTextField(
                  onPressed: (value) {
                    password = value;
                  },
                  label: 'Password',
                  hint: 'password ...',
                  icon: Icons.lock,
                  isSecured: false,
                  controller: passwordController,
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
                  height: 20,
                ),
                MaterialButton(
                  minWidth: width - 100,
                  color: mainColor,
                  onPressed: () async {
                    if (email!.contains('@taibahu.edu.sa')) {
                      FirebaseFirestore firebaseFirestore =
                          FirebaseFirestore.instance;
                      FirebaseApp app = await Firebase.initializeApp(
                          name: 'Secondary', options: Firebase.app().options);
                      if (lname == null ||
                          email == null ||
                          password == null ||
                          medicalnumber == null ||
                          fname == null ||
                          age == null ||
                          allegry == null ||
                          chromes == null ||
                          nationalId == null) {
                        var snackBar = const SnackBar(
                            content: Text('Complete patient data ...'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        try {
                          UserCredential userCredential =
                              await FirebaseAuth.instanceFor(app: app)
                                  .createUserWithEmailAndPassword(
                                      email: email!, password: password!);
                          await firebaseFirestore
                              .collection('patients')
                              .doc(userCredential.user!.uid)
                              .set({
                            'fname': fname,
                            'lname': lname,
                            'email': email,
                            'medicalFileNumber': medicalnumber,
                            'password': password,
                            'age': age,
                            'nationalid': nationalId,
                            'allegry': allegry,
                            'chromes': chromes,
                            'socialstatus': status,
                            'type': 'patient'
                          });
                          await userCredential.user!
                              .updateDisplayName('$fname $lname');
                          Navigator.pushReplacementNamed(
                              context, '/admin-add-patient-success');
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            const snackBar = SnackBar(
                              content:
                                  Text('The password provided is too weak.'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else if (e.code == 'email-already-in-use') {
                            const snackBar = SnackBar(
                              content: Text(
                                  'The account already exists for that email.'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        }
                        await app.delete();
                      }
                    } else {
                      const snackBar = SnackBar(
                        content: Text('email must end with @taibahu.edu.sa'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
