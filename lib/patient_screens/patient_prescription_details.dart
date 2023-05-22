import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/constants.dart';
import 'package:flutter/material.dart';

class PatientPrescriptionDetail extends StatefulWidget {
  const PatientPrescriptionDetail({super.key, required this.item});
  final QueryDocumentSnapshot item;

  @override
  State<PatientPrescriptionDetail> createState() =>
      _PatientPrescriptionDetailState();
}

class _PatientPrescriptionDetailState extends State<PatientPrescriptionDetail> {
  List items = [];
  getPrescriptionDetails() {
    setState(() {
      items = widget.item.get('prescription') as List;
    });
  }

  @override
  void initState() {
    super.initState();
    getPrescriptionDetails();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding:
            const EdgeInsets.only(top: 70, left: 20, right: 20, bottom: 20),
        width: width,
        height: height,
        decoration: const BoxDecoration(),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(width: 4, color: mainColor),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Dr. Samia Ragab',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Family Clinic',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '10/10/2010',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ),
                Divider(
                  color: mainColor,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'RX/',
                  style: TextStyle(
                      color: mainColor,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                items.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              var data = items[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    boxShadow: [customBoxShadow],
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      data['item'],
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      data['desc'],
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                              );
                            }),
                      )
                    : const Expanded(
                        child: Center(
                        child: Text('no items'),
                      ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
