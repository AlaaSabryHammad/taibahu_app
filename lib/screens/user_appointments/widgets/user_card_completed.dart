import 'package:flutter/material.dart';
import '../../../constants.dart';

class UserCardCompleted extends StatelessWidget {
  const UserCardCompleted(
      {super.key,
      required this.name,
      required this.label,
      required this.date,
      required this.time});
  final String name, label, date, time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.only(bottom: 20),
      height: 180,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(1, 1),
              blurRadius: 5,
            )
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    label,
                    style: TextStyle(
                        color: mainColor.withOpacity(0.5),
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: TextStyle(
                        color: mainColor, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    time,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 10),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       MaterialButton(
          //         onPressed: () {},
          //         color: const Color(0xff04c0c9),
          //         elevation: 5,
          //         child: const Text(
          //           'Update',
          //           style: TextStyle(color: Colors.white),
          //         ),
          //       ),
          //       MaterialButton(
          //         onPressed: () {},
          //         color: const Color(0xff04c0c9),
          //         elevation: 5,
          //         child: const Text(
          //           'Delete',
          //           style: TextStyle(color: Colors.white),
          //         ),
          //       )
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}
