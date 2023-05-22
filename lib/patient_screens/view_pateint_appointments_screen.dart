import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'patient_update_appointment.dart';

class ViewPatientAppointments extends StatefulWidget {
  const ViewPatientAppointments({super.key});

  @override
  State<ViewPatientAppointments> createState() =>
      _ViewPatientAppointmentsState();
}

class _ViewPatientAppointmentsState extends State<ViewPatientAppointments> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(top: 70, left: 20, right: 20, bottom: 20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'View Appointments',
                style: TextStyle(
                    color: mainColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 28),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: StreamBuilder(
                  stream: firebaseFirestore
                      .collection('bookings')
                      .where('patientId',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .orderBy('startTime', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.isEmpty) {
                        return Center(
                            child: Text(
                          'There are no bookings ...',
                          style: TextStyle(
                              color: textColor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ));
                      } else {
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var item = snapshot.data!.docs[index];
                              DateTime bookingTime = item['startTime'].toDate();
                              return BookCard(
                                item: item,
                                tDate: bookingTime,
                                edit: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: Text(
                                        'Do you want to Update the Appointment..?',
                                        style: TextStyle(
                                            color: textColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      actions: [
                                        MaterialButton(
                                          elevation: 5,
                                          color: mainColor,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'No',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        MaterialButton(
                                          elevation: 5,
                                          color: textColor,
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PatientUpdateAppointment(
                                                  item: item,
                                                ),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            'Yes',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                cancel: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: Text(
                                        'Do you want to cancel the Appointment..?',
                                        style: TextStyle(
                                            color: textColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      actions: [
                                        MaterialButton(
                                          elevation: 5,
                                          color: mainColor,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'No',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        MaterialButton(
                                          elevation: 5,
                                          color: Colors.red,
                                          onPressed: () {
                                            firebaseFirestore
                                                .collection('bookings')
                                                .doc(item.id)
                                                .update({'status': 'canceled'});
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'Yes',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              );
                            });
                      }
                    } else if (snapshot.hasError) {
                      return Center(child: Text('${snapshot.error}'));
                    }
                    return const Center(
                        child: Text('There is no appointments'));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  const BookCard({
    super.key,
    required this.item,
    required this.tDate,
    required this.edit,
    required this.cancel,
  });

  final QueryDocumentSnapshot<Map<String, dynamic>> item;
  final DateTime tDate;
  final VoidCallback edit;
  final VoidCallback cancel;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(bottom: 15),
          width: width - 40,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(
                color: mainColor, width: 1, style: BorderStyle.solid),
            boxShadow: [customBoxShadow],
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 50,
                    height: 80,
                    decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${tDate.day}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            DateFormat.E().format(tDate),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    width: 50,
                    height: 40,
                    decoration: BoxDecoration(
                        // color: textColor,
                        color: newColor(),
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                        child: Text(
                      item['status'],
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    )),
                  )
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['doctor'],
                    style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    item['clinic'],
                    style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Time- ${tDate.hour}:${tDate.minute}',
                    style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ],
              )
            ],
          ),
        ),
        item['status'] == 'active'
            ? Positioned(
                bottom: 10,
                right: 10,
                child: Column(
                  children: [
                    MaterialButton(
                      elevation: 5,
                      color: mainColor,
                      onPressed: edit,
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    MaterialButton(
                      elevation: 5,
                      color: textColor,
                      onPressed: cancel,
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  Color newColor() {
    if (item['status'] == 'active') {
      return textColor;
    } else if (item['status'] == 'canceled') {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }
}
