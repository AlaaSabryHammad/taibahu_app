import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import 'admin_view_evaluation_details.dart';

class AdminViewUserEvaluations extends StatefulWidget {
  const AdminViewUserEvaluations({super.key});

  @override
  State<AdminViewUserEvaluations> createState() =>
      _AdminViewUserEvaluationsState();
}

class _AdminViewUserEvaluationsState extends State<AdminViewUserEvaluations> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  int? total, read, unread;
  getRecords() async {
    firebaseFirestore.collection('evaluations').snapshots().listen((value) {
      setState(() {
        total = value.docs.length;
      });
    });
    firebaseFirestore
        .collection('evaluations')
        .where('read', isEqualTo: true)
        .snapshots()
        .listen((value) {
      setState(() {
        read = value.docs.length;
      });
    });
    firebaseFirestore
        .collection('evaluations')
        .where('read', isEqualTo: false)
        .snapshots()
        .listen((value) {
      setState(() {
        unread = value.docs.length;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getRecords();
  }

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
                "Review Users' Evaluations",
                textAlign: TextAlign.center,
                style: mainHeaderStyle,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: StreamBuilder(
                  stream: firebaseFirestore
                      .collection('evaluations')
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
                            DateTime dateTime = item['time'].toDate();
                            return GestureDetector(
                              onTap: () {
                                firebaseFirestore
                                    .collection('evaluations')
                                    .doc(item.id)
                                    .update({
                                  'read': true,
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AdminViewEvaluationDetails(
                                      item: item,
                                    ),
                                  ),
                                );
                              },
                              child: UserEvaluationCard(
                                status: item['read'] ? 'read' : 'new',
                                date: "${dateTime.day}",
                                day: DateFormat.E().format(dateTime),
                                name: item['patientName'],
                                bColor: item['read']
                                    ? Colors.grey.withOpacity(0.3)
                                    : Colors.yellow,
                                ratingValue: item['rating'],
                              ),
                            );
                          });
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const Center(child: CircularProgressIndicator());
                  }),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                          color: Colors.black, shape: BoxShape.circle),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text('Total Evaluations $total',
                        style: const TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                          color: Colors.blue, shape: BoxShape.circle),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Read Evaluations $read',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text('Unread Evaluations $unread',
                        style: const TextStyle(fontWeight: FontWeight.bold))
                  ],
                )
              ],
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
    required this.status,
    required this.date,
    required this.day,
    required this.name,
    required this.bColor,
    required this.ratingValue,
  });
  final String status, date, day, name;
  final Color bColor;
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
                      date,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                    Text(day,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22))
                  ],
                ),
              ),
              Container(
                width: 80,
                height: 40,
                decoration: BoxDecoration(
                  color: bColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    status,
                    style: TextStyle(
                        color: mainColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Recordes Added',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Recorded by $name',
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
            ],
          )
        ],
      ),
    );
  }
}
