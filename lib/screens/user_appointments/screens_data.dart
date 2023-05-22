import 'package:taibahu_app/screens/user_appointments/cancelled_screen.dart';
import 'package:taibahu_app/screens/user_appointments/completed_screen.dart';
import 'package:taibahu_app/screens/user_appointments/upcoming_screen.dart';
import 'package:flutter/material.dart';

List<Widget> screens = [
  const UpcomingScreen(),
  const CompletedScreen(),
  const CancelledScreen()
];
