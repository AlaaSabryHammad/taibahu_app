import 'package:flutter/material.dart';
import '../constants.dart';



class ChooseIcon extends StatelessWidget {
  const ChooseIcon({
    super.key,
    required this.onPressed,
    required this.image,
    required this.label,
    required this.tag,
  });
  final VoidCallback onPressed;
  final String image;
  final String label;
  final String tag;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: (width - 120) / 2,
        height: (width - 120) / 2,
        decoration: BoxDecoration(
          border:
              Border.all(color: mainColor, width: 2, style: BorderStyle.solid),
          boxShadow: [customBoxShadow],
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: tag,
              child: Image.asset(
                image,
                width: width / 2 - 130,
                height: width / 2 - 130,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              label,
              style: TextStyle(
                  color: textColor, fontWeight: FontWeight.bold, fontSize: 16),
            )
          ],
        )),
      ),
    );
  }
}
