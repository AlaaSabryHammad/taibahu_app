import 'dart:ui';
import 'package:taibahu_app/lap_doctor_screens/lap_login_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/choose_icon.dart';

class ChooseLoginScreen extends StatefulWidget {
  const ChooseLoginScreen({super.key});

  @override
  State<ChooseLoginScreen> createState() => _ChooseLoginScreenState();
}

class _ChooseLoginScreenState extends State<ChooseLoginScreen> {
  bool isViewed = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    MediaQuery.of(context).size.width;
    return Scaffold(
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
            padding:
                const EdgeInsets.only(top: 50, left: 30, right: 30, bottom: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    Hero(
                      tag: 'logo',
                      child: Image.asset(
                        'images/logo.png',
                        width: width * 0.3,
                        height: width * 0.3,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'TAIBAH CARE',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                ChooseIcon(
                  label: 'Login',
                  image: 'images/patient.png',
                  onPressed: () {
                    Navigator.pushNamed(context, '/patient-login');
                  },
                  tag: 'patient',
                ),
              ],
            ),
          ),
          AnimatedPositioned(
            top: isViewed ? 0 : -2 * height,
            bottom: isViewed ? 0 : 2 * height,
            right: 0,
            left: 0,
            duration: const Duration(milliseconds: 800),
            child: Container(
              decoration: BoxDecoration(
                  color:
                      isViewed ? Colors.black.withOpacity(0.5) : Colors.white),
              width: width,
              height: height,
              child: Center(
                child: Container(
                  height: height * 0.5,
                  width: width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    // color: Colors.white,
                    // boxShadow: [customBoxShadow],
                    // border: Border.all(
                    //     color: mainColor, width: 1, style: BorderStyle.solid),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ChooseIcon(
                            label: 'Lap. Doctor',
                            image: 'images/lap.png',
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LapLoginScreen()));
                              // Navigator.pushNamed(context, '/patient-login');
                            },
                            tag: 'lap',
                          ),
                          ChooseIcon(
                            label: 'Doctor',
                            image: 'images/doctor.png',
                            onPressed: () {
                              Navigator.pushNamed(context, '/doctor-login');
                            },
                            tag: 'doctor',
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ChooseIcon(
                            label: 'Pharmacist',
                            image: 'images/pharmacian.png',
                            onPressed: () {
                              Navigator.pushNamed(context, '/pharmacian-login');
                            },
                            tag: 'pharmacian',
                          ),
                          ChooseIcon(
                            label: 'Admin',
                            image: 'images/admin.png',
                            onPressed: () {
                              Navigator.pushNamed(context, '/admin-login');
                            },
                            tag: 'admin',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 70,
            left: 40,
            child: IconButton(
              onPressed: () {
                setState(() {
                  isViewed = !isViewed;
                });
              },
              icon: isViewed
                  ? const Icon(
                      Icons.close,
                      size: 35,
                      color: Colors.white,
                    )
                  : const Icon(
                      Icons.menu,
                      size: 35,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
