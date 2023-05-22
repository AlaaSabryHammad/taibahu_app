import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../constants.dart';


class DoctorViewEvaluations extends StatefulWidget {
  const DoctorViewEvaluations({super.key});

  @override
  State<DoctorViewEvaluations> createState() => _DoctorViewEvaluationsState();
}

class _DoctorViewEvaluationsState extends State<DoctorViewEvaluations> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  int? total, read, unread;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 70, right: 20, left: 20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'Doctors Evaluations',
                style: mainHeaderStyle,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: FutureBuilder(
                  future: firebaseFirestore
                      .collection('evaluations')
                      .where('doctorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .orderBy('time', descending: true)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var item = snapshot.data!.docs[index];
                            DateTime date = item['time'].toDate();
                            return EvaluationDoctorWidget(
                              ratingValue: item['rating'],
                              time: date,
                              desc: item['description'],
                              patient: item['patientName'],
                              doctor: item['doctorName'],
                              clinic: item['clinicName'],
                            );
                          });
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const Center(child: CircularProgressIndicator());
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class EvaluationDoctorWidget extends StatelessWidget {
  const EvaluationDoctorWidget({
    super.key,
    required this.ratingValue,
    required this.time,
    required this.desc,
    required this.patient,
    required this.doctor,
    required this.clinic,
  });
  final double ratingValue;
  final String desc, patient, doctor, clinic;
  final DateTime time;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      width: width - 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [customBoxShadow],
          color: Colors.white,
          border:
              Border.all(color: mainColor, width: 1, style: BorderStyle.solid)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            patient,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: mainColor),
          ),
          Text(
            'An Evaluation about $doctor',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14, color: textColor),
          ),
          Text(
            'Clinic: $clinic',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14, color: textColor),
          ),
          RatingBar.builder(
            maxRating: ratingValue,
            itemSize: 15,
            initialRating: ratingValue,
            minRating: ratingValue,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              // ratingValue = rating;
            },
          ),
          Text('$time'),
          const Divider(),
          Text(desc)
        ],
      ),
    );
  }
}
