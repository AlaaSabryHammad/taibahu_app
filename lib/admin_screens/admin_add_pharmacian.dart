import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/admin_screens/success/admin_add_pharmacist_success.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class AdminAddPharmacian extends StatefulWidget {
  const AdminAddPharmacian({super.key});

  @override
  State<AdminAddPharmacian> createState() => _AdminAddPharmacianState();
}

class _AdminAddPharmacianState extends State<AdminAddPharmacian> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 70, left: 20, right: 20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: mainColor.withOpacity(0.3)),
                    child: Image.asset(
                      'images/pharmacian.png',
                      width: width * 0.5,
                      height: width * 0.5,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Add Pharmacist',
                    style: mainHeaderStyle,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AddDoctorTextField(
                    controller: userNameController,
                    hint: 'Doctor User Name ...',
                    icon: Icons.person,
                    label: 'User Name',
                  ),
                  AddDoctorTextField(
                    controller: emailController,
                    hint: 'Doctor Email Address ...',
                    icon: Icons.email,
                    label: 'Email Address',
                  ),
                  AddDoctorTextField(
                    controller: passwordController,
                    hint: 'Doctor password ...',
                    icon: Icons.lock,
                    label: 'Password',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    color: mainColor,
                    minWidth: width - 120,
                    elevation: 5,
                    onPressed: () async {
                      if (userNameController.text.isEmpty ||
                          emailController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        var snackBar = const SnackBar(
                            content: Text('Complete fields ...'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        if (emailController.text.contains('@taibahu.edu.sa')) {
                          FirebaseApp app = await Firebase.initializeApp(
                              name: 'Secondary',
                              options: Firebase.app().options);
                          try {
                            UserCredential userCredential =
                                await FirebaseAuth.instanceFor(app: app)
                                    .createUserWithEmailAndPassword(
                                        email: emailController.text,
                                        password: passwordController.text);
                            await firebaseFirestore
                                .collection('pharmacists')
                                .doc(userCredential.user!.uid)
                                .set({
                              'email': emailController.text,
                              'name': userNameController.text,
                              'password': passwordController.text,
                              'sex': 'Female',
                            });
                            await userCredential.user!
                                .updateDisplayName(userNameController.text);
                            Navigator.pushReplacementNamed(
                                context, '/view-doctors');
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
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AdminAddPharmacistSuccess()));
                        } else {
                          const snackBar = SnackBar(
                            content:
                                Text('Email must ends with @taibahu.edu.sa'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }
                    },
                    child: const Text(
                      'Done',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddDoctorTextField extends StatelessWidget {
  const AddDoctorTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
  });
  final TextEditingController controller;
  final String label, hint;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
            )),
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon),
              border: const OutlineInputBorder()),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
