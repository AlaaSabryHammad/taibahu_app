import 'package:taibahu_app/constants.dart';
import 'package:flutter/material.dart';

class AdminAddDoctorSuccess extends StatelessWidget {
  const AdminAddDoctorSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
            child: Center(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Doctor has been added successfully',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: mainColor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: MaterialButton(
                padding: const EdgeInsets.symmetric(vertical: 20),
                elevation: 10,
                color: textColor,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/view-doctors');
                },
                child: const Text(
                  'Done',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ))
        ],
      ),
    );
  }
}
