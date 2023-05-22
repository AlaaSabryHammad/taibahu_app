import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/time_model.dart';
import '../widgets/book_widget.dart';

class PatientUpdateAppointment extends StatefulWidget {
  const PatientUpdateAppointment({super.key, required this.item});
  final QueryDocumentSnapshot item;
  @override
  State<PatientUpdateAppointment> createState() =>
      _PatientUpdateAppointmentState();
}


class _PatientUpdateAppointmentState extends State<PatientUpdateAppointment> {
  String? patientName;
  List<String> itemss = [];
  List<String> doctorsList = [];
  String? dropdownValue;
  String? clinicID;
  String? dropdownValueDoctors;
  String? doctorID;
  DateTime bookingDate = DateTime.now();
  DateTime newBookingDate = DateTime.now();
  DateTime newBookingDateEnd = DateTime.now();
  int? bookingHr;
  int? bookingMin;
  int? bookingHrEnd;
  int? bookingMinEnd;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  getPatientName() {
    firebaseFirestore
        .collection('patients')
        .doc(auth.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        patientName = '${value.data()!['fname']} ${value.data()!['lname']}';
      });
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

  setClinicId(String clinicName) async {
    await firebaseFirestore
        .collection('clinics')
        .where('clinic_name', isEqualTo: clinicName)
        .get()
        .then((value) {
      doctorID = value.docs.first.id;
    });
  }

  setDoctorId(String doctorName) async {
    await firebaseFirestore
        .collection('doctors')
        .where('name', isEqualTo: doctorName)
        .get()
        .then((value) {
      clinicID = value.docs.first.id;
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

  List<DateTime> xTimes = [];
  getBookings(DateTime xNow) async {
    await firebaseFirestore
        .collection('bookings')
        .where('startTime',
            isGreaterThan:
                DateTime(xNow.year, xNow.month, xNow.day, 09, 00, 00))
        .where('startTime',
            isLessThan: DateTime(xNow.year, xNow.month, xNow.day, 20, 30, 00))
        .where('status', isEqualTo: 'active')
        .get()
        .then((value) {
      for (var item in value.docs) {
        setState(() {
          xTimes.add(item['startTime'].toDate());
        });
        print(xTimes);
        print('sssssssssss');
      }
    });
  }

  int? selectedIndex;
  @override
  void initState() {
    super.initState();
    getClinics();
    getBookings(DateTime.now());
    getPatientName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          padding:
              const EdgeInsets.only(top: 70, left: 20, right: 20, bottom: 20),
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'New Appointment',
                style: TextStyle(
                    color: mainColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ),
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
            BookWidget(
              onChoose: (date) {
                bookingDate = date;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Available Time',
              style: TextStyle(
                  color: textColor, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 300,
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 80,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemCount: bookingTimes.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                        bookingHr = bookingTimes[index].realHr;
                        bookingMin = bookingTimes[index].realMin;
                        newBookingDate = DateTime(
                            bookingDate.year,
                            bookingDate.month,
                            bookingDate.day,
                            bookingHr!,
                            bookingMin!);
                        if (index == bookingTimes.length - 1) {
                          newBookingDateEnd = DateTime(bookingDate.year,
                              bookingDate.month, bookingDate.day, 21, 00);
                        } else {
                          bookingHrEnd = bookingTimes[index + 1].realHr;
                          bookingMinEnd = bookingTimes[index + 1].realMin;
                          newBookingDateEnd = DateTime(
                              bookingDate.year,
                              bookingDate.month,
                              bookingDate.day,
                              bookingHrEnd!,
                              bookingMinEnd!);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color:
                              selectedIndex == index ? mainColor : Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            '${bookingTimes[index].houre}:${bookingTimes[index].min} ${bookingTimes[index].st}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: selectedIndex == index
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
              elevation: 5,
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: mainColor,
              onPressed: () async {
                if (bookingHr == null) {
                  var snackBar = const SnackBar(
                      content: Text('Please, Select The Time ...'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  // await firebaseFirestore.collection('bookings').add({
                  //   'patientId': FirebaseAuth.instance.currentUser!.uid,
                  //   'patientName': patientName,
                  //   'startTime': newBookingDate,
                  //   'endTime': newBookingDateEnd,
                  //   'clinic': dropdownValue,
                  //   'clinicID': clinicID,
                  //   'doctor': dropdownValueDoctors,
                  //   'doctorID': doctorID,
                  //   'status': 'active',
                  //   'isWaiting': true,
                  //   'isRefered': false
                  // });
                  Navigator.pushReplacementNamed(context, '/view-patient-app');
                }
              },
              child: const Text(
                'Done',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
