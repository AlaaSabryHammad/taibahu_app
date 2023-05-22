import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/constants.dart';
import 'package:flutter/material.dart';

class DoctorDetailsScreen extends StatelessWidget {
  const DoctorDetailsScreen({super.key, required this.ds});
  final QueryDocumentSnapshot ds;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 250,
                    width: width,
                    decoration: BoxDecoration(color: textColor),
                    child: Center(
                      child: Text(
                        ds['name'],
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    bottom: -50,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          ds['sex'] == 'male'
                              ? 'images/man.png'
                              : 'images/girl.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 70,
              ),
              DoctorDetailCard(
                label: 'Name',
                value: ds['name'],
              ),
              DoctorDetailCard(
                label: 'Email Address',
                value: ds['email'],
              ),
              DoctorDetailCard(
                label: 'Clini',
                value: ds['clinic'],
              ),
              DoctorDetailCard(
                label: 'Password',
                value: ds['password'],
              ),
              const SizedBox(
                height: 10,
              ),
              MaterialButton(
                minWidth: 200,
                elevation: 5,
                color: textColor,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Done',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 35,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DoctorDetailCard extends StatelessWidget {
  const DoctorDetailCard({
    super.key,
    required this.label,
    required this.value,
  });
  final String label, value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
                color: textColor, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            textAlign: TextAlign.center,
            enabled: false,
            decoration: InputDecoration(
                hintText: value,
                hintStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18),
                border: const OutlineInputBorder(),
                fillColor: mainColor,
                filled: true),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
