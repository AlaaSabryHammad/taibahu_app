import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/patient_screens/patient_view_evaluation_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import '../constants.dart';

class PatientViewServiceEvaluations extends StatefulWidget {
  const PatientViewServiceEvaluations({super.key});

  @override
  State<PatientViewServiceEvaluations> createState() =>
      _PatientViewServiceEvaluationsState();
}

class _PatientViewServiceEvaluationsState
    extends State<PatientViewServiceEvaluations> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 70, left: 20, right: 20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                "Review",
                textAlign: TextAlign.center,
                style: mainHeaderStyle,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "My Evaluations",
                textAlign: TextAlign.center,
                style: mainHeaderStyle,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: StreamBuilder(
                  stream: firebaseFirestore
                      .collection('evaluations')
                      .where('patientId',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            'No Service Evaluations',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textColor),
                          ),
                        );
                      }
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var item = snapshot.data!.docs[index];
                            DateTime evalTime = item['time'].toDate();
                            String day = DateFormat('E').format(evalTime);
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PatientViewEvaluationDetails(
                                      item: item,
                                    ),
                                  ),
                                );
                              },
                              child: UserEvaluationCard(
                                doctorName: item['doctorName'],
                                day: evalTime.day,
                                textWidget: item['read'] == false
                                    ? Container(
                                        width: 60,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: mainColor,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'New',
                                            style: TextStyle(
                                                color: Colors.yellow,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: 60,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Read',
                                            style: TextStyle(
                                                color: mainColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                dayName: day,
                                clinic: item['clinicName'],
                                ratingValue: item['rating'],
                              ),
                            );
                          });
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class UserEvaluationCard extends StatelessWidget {
  const UserEvaluationCard({
    super.key,
    required this.doctorName,
    required this.day,
    required this.textWidget,
    required this.dayName,
    required this.clinic,
    required this.ratingValue,
  });
  final String doctorName;
  final int day;
  final Widget textWidget;
  final String dayName;
  final String clinic;
  final double ratingValue;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      width: width - 40,
      height: 150,
      decoration: BoxDecoration(
        border:
            Border.all(color: mainColor, width: 2, style: BorderStyle.solid),
        color: Colors.white,
        boxShadow: [customBoxShadow],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    color: mainColor, borderRadius: BorderRadius.circular(5)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$day',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                    Text(
                      dayName,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  ],
                ),
              ),
              textWidget
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doctorName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                clinic,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: mainColor),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                '$ratingValue Evaluation',
                style: const TextStyle(fontSize: 16),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: RatingBar.builder(
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
              ),
            ],
          )
        ],
      ),
    );
  }
}
