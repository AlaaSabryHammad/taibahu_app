import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AddDoctorScreen extends StatefulWidget {
  const AddDoctorScreen({super.key});

  @override
  State<AddDoctorScreen> createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool sexStatus = true;
  String sex = 'male';
  String? dropdownValue;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  List<String> itemss = [];
  getClinics() async {
    await firebaseFirestore.collection('clinics').get().then((value) {
      for (var element in value.docs) {
        setState(() {
          itemss.add(element.data()['clinic_name']);
        });
      }
      setState(() {
        dropdownValue = itemss[0];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getClinics();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Padding(
          padding:
              const EdgeInsets.only(top: 70, left: 20, right: 20, bottom: 20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: mainColor.withOpacity(0.3)),
                    child: Image.asset(
                      'images/doctor.png',
                      width: width * 0.5,
                      height: width * 0.5,
                    ),
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
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     GestureDetector(
                  //       onTap: () {
                  //         setState(() {
                  //           sexStatus = true;
                  //           sex = 'Male';
                  //         });
                  //       },
                  //       child: Container(
                  //         width: 100,
                  //         height: 50,
                  //         decoration: BoxDecoration(
                  //             color: sexStatus
                  //                 ? mainColor
                  //                 : Colors.grey.withOpacity(0.5)),
                  //         child: const Center(
                  //           child: Text(
                  //             'Male',
                  //             style: TextStyle(color: Colors.white),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(
                  //       width: 10,
                  //     ),
                  //     GestureDetector(
                  //       onTap: () {
                  //         setState(() {
                  //           sexStatus = false;
                  //           sex = 'Female';
                  //         });
                  //       },
                  //       child: Container(
                  //         width: 100,
                  //         height: 50,
                  //         decoration: BoxDecoration(
                  //             color: sexStatus
                  //                 ? Colors.grey.withOpacity(0.5)
                  //                 : mainColor),
                  //         child: const Center(
                  //           child: Text(
                  //             'Female',
                  //             style: TextStyle(color: Colors.white),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Choose clinic',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          //<-- SEE HERE
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          //<-- SEE HERE
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.greenAccent,
                      ),
                      dropdownColor: Colors.greenAccent,
                      value: dropdownValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items:
                          itemss.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    color: mainColor,
                    minWidth: width * 0.5,
                    elevation: 5,
                    onPressed: () async {
                      if (emailController.text.contains('@taibahu.edu.sa')) {
                        FirebaseApp app = await Firebase.initializeApp(
                            name: 'Secondary', options: Firebase.app().options);
                        try {
                          UserCredential userCredential =
                              await FirebaseAuth.instanceFor(app: app)
                                  .createUserWithEmailAndPassword(
                                      email: emailController.text,
                                      password: passwordController.text);
                          await firebaseFirestore
                              .collection('doctors')
                              .doc(userCredential.user!.uid)
                              .set({
                            'email': emailController.text,
                            'name': userNameController.text,
                            'password': passwordController.text,
                            'sex': 'Female',
                            'clinic': dropdownValue,
                            'time': FieldValue.serverTimestamp(),
                            'type': 'doctor'
                          });
                          await userCredential.user!
                              .updateDisplayName(userNameController.text);
                          Navigator.pushReplacementNamed(
                              context, '/admin-add-doctor-success');
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
                          // Do something with exception. This try/catch is here to make sure
                          // that even if the user creation fails, app.delete() runs, if is not,
                          // next time Firebase.initializeApp() will fail as the previous one was
                          // not deleted.
                        }

                        await app.delete();
                      } else {
                        const snackBar = SnackBar(
                          content: Text('Email must end with @taibahu.edu.sa'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
