import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PatientAddServiceEvaluations extends StatefulWidget {
  const PatientAddServiceEvaluations({super.key});

  @override
  State<PatientAddServiceEvaluations> createState() =>
      _PatientAddServiceEvaluationsState();
}

class _PatientAddServiceEvaluationsState
    extends State<PatientAddServiceEvaluations> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  TextEditingController descController = TextEditingController();
  List<String> itemss = [];
  List<String> doctorsList = [];
  String? dropdownValue;
  String? dropdownValueDoctors;
  String? clinicID;
  String? doctorID;
  double ratingValue = 2;

  setClinicId(String clinicName) async {
    await firebaseFirestore
        .collection('clinics')
        .where('clinic_name', isEqualTo: clinicName)
        .get()
        .then((value) {
      clinicID = value.docs.first.id;
    });
  }

  setDoctorId(String doctorName) async {
    await firebaseFirestore
        .collection('doctors')
        .where('name', isEqualTo: doctorName)
        .get()
        .then((value) {
      doctorID = value.docs.first.id;
    });
  }

  getClinics() async {
    await firebaseFirestore.collection('clinics').get().then((value) {
      for (var element in value.docs) {
        setState(() {
          itemss.add(element.data()['clinic_name']);
        });
      }
      setState(() {
        dropdownValue = itemss[0];
      });
      setClinicId(dropdownValue!);
      getDoctors(dropdownValue!);
    });
  }

  getDoctors(String cliniName) async {
    await firebaseFirestore
        .collection('doctors')
        .where('clinic', isEqualTo: cliniName)
        .get()
        .then((value) {
      for (var element in value.docs) {
        setState(() {
          doctorsList.add(element.data()['name']);
        });
      }
      setState(() {
        dropdownValueDoctors = doctorsList[0];
      });
      setDoctorId(dropdownValueDoctors!);
    });
  }

  @override
  void initState() {
    super.initState();
    getClinics();
  }

  @override
  Widget build(BuildContext context) {
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
                    'Add Service Evaluation',
                    textAlign: TextAlign.center,
                    style: mainHeaderStyle,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  'Choose Clinic',
                  style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField(
                  isExpanded: true,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      //<-- SEE HERE
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      //<-- SEE HERE
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                    filled: true,
                    fillColor: Color(0xffcaf0f8),
                  ),
                  dropdownColor: const Color(0xffcaf0f8),
                  value: dropdownValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      doctorsList.clear();
                      dropdownValue = newValue!;
                    });
                    getDoctors(dropdownValue!);
                  },
                  items: itemss.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        overflow: TextOverflow.clip,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Choose Doctor',
                  style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField(
                  isExpanded: true,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      //<-- SEE HERE
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      //<-- SEE HERE
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                    filled: true,
                    fillColor: Color(0xffcaf0f8),
                  ),
                  dropdownColor: const Color(0xffcaf0f8),
                  value: dropdownValueDoctors,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValueDoctors = newValue!;
                    });
                  },
                  items:
                      doctorsList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 20,
                ),
                RatingBar.builder(
                  initialRating: ratingValue,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    ratingValue = rating;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Write An Evaluation',
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
                      color: const Color(0xffcaf0f8),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black)),
                  child: TextField(
                    maxLines: null, // Set this
                    expands: true, // and this
                    keyboardType: TextInputType.multiline,
                    decoration:
                        const InputDecoration(hintText: 'Write here ......'),
                    controller: descController,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  elevation: 5,
                  minWidth: 250,
                  color: mainColor,
                  onPressed: () async {
                    await firebaseFirestore.collection('evaluations').add({
                      'patientId': FirebaseAuth.instance.currentUser!.uid,
                      'patientName':
                          FirebaseAuth.instance.currentUser!.displayName,
                      'clinicName': dropdownValue,
                      'clinicID': clinicID,
                      'doctorName': dropdownValueDoctors,
                      'doctorId': doctorID,
                      'description': descController.text,
                      'read': false,
                      'rating': ratingValue,
                      'time': FieldValue.serverTimestamp()
                    });
                    Navigator.pushReplacementNamed(
                        context, '/patient-add-evaluation-success');
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
