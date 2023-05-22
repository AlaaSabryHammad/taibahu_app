import 'package:flutter/material.dart';

import '../constants.dart';

class AppointmentAction extends StatelessWidget {
  const AppointmentAction(
      {super.key,
      required this.onPressed,
      required this.label,
      required this.icon});
  final VoidCallback onPressed;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 7,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      onPressed: onPressed,
      color: const Color(0xfff1f1f1),
      child: Row(
        children: [
          Icon(
            icon,
            color: mainColor,
            size: 37,
          ),
          const SizedBox(
            width: 30,
          ),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
