import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/constants.dart';
import 'package:flutter/material.dart';

class AdminUpdatePatient extends StatefulWidget {
  const AdminUpdatePatient({super.key, required this.patient});
  final QueryDocumentSnapshot patient;

  @override
  State<AdminUpdatePatient> createState() => _AdminUpdatePatientState();
}

class _AdminUpdatePatientState extends State<AdminUpdatePatient> {
  String? fname;
  String? lname;
  String? email;
  String? password;
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController idController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fnameController.text = widget.patient['fname'];
    lnameController.text = widget.patient['lname'];
    emailController.text = widget.patient['email'];
    passwordController.text = widget.patient['password'];
    idController.text = widget.patient['medicalFileNumber'];
  }

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
                  height: 20,
                ),
                Text(
                  'Update Patient Profile',
                  style: mainHeaderStyle,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextFieldEdit(
                  onPressed: () {},
                  label: 'First Name',
                  icon: Icons.person,
                  isSecured: false,
                  controller: fnameController,
                ),
                CustomTextFieldEdit(
                  onPressed: () {},
                  label: 'Last Name',
                  icon: Icons.person,
                  isSecured: false,
                  controller: lnameController,
                ),
                CustomTextFieldEdit(
                  onPressed: () {},
                  label: 'Email Address',
                  icon: Icons.email,
                  isSecured: false,
                  controller: emailController,
                ),
                CustomTextFieldEdit(
                  onPressed: () {},
                  label: 'Password',
                  icon: Icons.password,
                  isSecured: false,
                  controller: passwordController,
                ),
                CustomTextFieldEdit(
                  onPressed: () {},
                  label: 'Medical File Number',
                  icon: Icons.person,
                  isSecured: false,
                  controller: idController,
                ),
                const SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  minWidth: width - 100,
                  color: mainColor,
                  elevation: 5,
                  onPressed: () async {
                    if (fnameController.text.isEmpty ||
                        lnameController.text.isEmpty ||
                        emailController.text.isEmpty ||
                        passwordController.text.isEmpty ||
                        idController.text.isEmpty) {
                      var snackBar = const SnackBar(
                          content: Text('Complete patient data ...'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      await FirebaseFirestore.instance
                          .collection('patients')
                          .doc(widget.patient.id)
                          .update({
                        'fname': fnameController.text,
                        'lname': lnameController.text,
                        'email': emailController.text,
                        'password': passwordController.text,
                        'medicalFileNumber': idController.text
                      });
                      await FirebaseFirestore.instance
                          .collection('bookings')
                          .where('patientId', isEqualTo: widget.patient.id)
                          .get()
                          .then((value) async {
                        for (var doc in value.docs) {
                          await FirebaseFirestore.instance
                              .collection('bookings')
                              .doc(doc.id)
                              .update({'medicalFileNumber': idController.text});
                        }
                      });
                      Navigator.pushReplacementNamed(
                          context, '/admin-update-patient-success');
                    }
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
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

class CustomTextFieldEdit extends StatelessWidget {
  const CustomTextFieldEdit({
    super.key,
    required this.onPressed,
    required this.label,
    required this.icon,
    required this.isSecured,
    required this.controller,
  });
  final Function onPressed;
  final String label;
  final IconData icon;
  final bool isSecured;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: controller,
          onChanged: (value) => onPressed(value),
          obscureText: isSecured,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
