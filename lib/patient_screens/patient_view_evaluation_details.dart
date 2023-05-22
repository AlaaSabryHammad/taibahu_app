import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class PatientViewEvaluationDetails extends StatefulWidget {
  const PatientViewEvaluationDetails({super.key, required this.item});
  final QueryDocumentSnapshot item;

  @override
  State<PatientViewEvaluationDetails> createState() =>
      _PatientViewEvaluationDetailsState();
}

class _PatientViewEvaluationDetailsState
    extends State<PatientViewEvaluationDetails> {
  TextEditingController evalConroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      evalConroller.text = widget.item['description'];
    });
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
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'View Service Evaluation',
                    textAlign: TextAlign.center,
                    style: mainHeaderStyle,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  'Clinic',
                  style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: width - 40,
                  height: 50,
                  decoration: BoxDecoration(color: mainColor),
                  child: Center(
                    child: Text(
                      widget.item['clinicName'],
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Doctor',
                  style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: width - 40,
                  height: 50,
                  decoration: BoxDecoration(color: mainColor),
                  child: Center(
                    child: Text(
                      widget.item['doctorName'],
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'The Evaluation',
                  style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  height: 250,
                  decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black)),
                  child: TextField(
                    readOnly: true,
                    controller: evalConroller,
                    maxLines: null, // Set this
                    expands: true, // and this
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  elevation: 5,
                  minWidth: 250,
                  color: mainColor,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
