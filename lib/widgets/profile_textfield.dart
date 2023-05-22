import 'package:flutter/material.dart';

class ProfileTextField extends StatelessWidget {
  const ProfileTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.requiredColor,
    required this.readOnly,
    required this.inputType,
  });
  final TextEditingController controller;
  final String hint;
  final Color requiredColor;
  final bool readOnly;
  final TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          keyboardType: inputType,
          readOnly: readOnly,
          textAlign: TextAlign.center,
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '* required field',
            style: TextStyle(color: requiredColor, fontSize: 10),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
