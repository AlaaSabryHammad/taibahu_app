import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:taibahu_app/constants.dart';
import 'package:flutter/material.dart';

class DoctorRefer extends StatefulWidget {
  const DoctorRefer({super.key, required this.item});
  final QueryDocumentSnapshot item;

  @override
  State<DoctorRefer> createState() => _DoctorReferState();
}

class _DoctorReferState extends State<DoctorRefer> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  String? dropdownValue;
  String? patientName;
  String? clinicID;
  String? dropdownValueDoctors;
  String? doctorID;
  List<String> doctorsList = [];

  List<String> itemss = [];
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

  int? selectedIndex;
  @override
  void initState() {
    super.initState();
    getClinics();
    // getBookings(DateTime.now());
    // getPatientName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(top: 70, left: 20, right: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'Refer Patient',
                style: mainHeaderStyle,
              ),
            ),
            ////////////
            const SizedBox(
              height: 40,
            ),
            Text(
              'Choose Clinic',
              style: TextStyle(
                  color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  //<-- SEE HERE
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
                focusedBorder: const OutlineInputBorder(
                  //<-- SEE HERE
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
                filled: true,
                fillColor: mainColor,
              ),
              dropdownColor: mainColor,
              value: dropdownValue,
              onChanged: (String? newValue) {
                setState(() {
                  doctorsList.clear();
                  dropdownValue = newValue!;
                });
                setClinicId(dropdownValue!);
                getDoctors(dropdownValue!);
              },
              items: itemss.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
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
                  color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  //<-- SEE HERE
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
                focusedBorder: const OutlineInputBorder(
                  //<-- SEE HERE
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
                filled: true,
                fillColor: mainColor,
              ),
              dropdownColor: mainColor,
              value: dropdownValueDoctors,
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValueDoctors = newValue!;
                });
                setClinicId(dropdownValueDoctors!);
              },
              items: doctorsList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Choose Date',
              style: TextStyle(
                  color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            DatePicker(
              DateTime.now(),
              initialSelectedDate: DateTime.now(),
              // inactiveDates: [DateTime.now()],
              selectionColor: mainColor,
              onDateChange: (selectedDate) {
                print(selectedDate);
              },
            ),
          ],
        ),
      ),
    );
  }
}
