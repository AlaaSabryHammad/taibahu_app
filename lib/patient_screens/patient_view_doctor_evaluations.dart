import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class PatientViewDoctorEvaluations extends StatefulWidget {
  const PatientViewDoctorEvaluations({super.key});

  @override
  State<PatientViewDoctorEvaluations> createState() =>
      _PatientViewDoctorEvaluationsState();
}

class _PatientViewDoctorEvaluationsState
    extends State<PatientViewDoctorEvaluations> {
  String name = '';
  TextEditingController searchController = TextEditingController();

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
            TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          name = '';
                          searchController.text = '';
                        });
                      },
                      icon: const Icon(Icons.close)),
                  hintText: 'search for Doctor .....',
                  border: const OutlineInputBorder()),
            ),
            // const SizedBox(
            //   height: 20,
            // ),
            Expanded(
              child: StreamBuilder(
                  stream: firebaseFirestore
                      .collection('evaluations')
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var item = snapshot.data!.docs[index];
                            DateTime date = item['time'].toDate();
                            if (name.isEmpty) {
                              return EvaluationDoctorWidget(
                                ratingValue: item['rating'],
                                time: date,
                                desc: item['description'],
                                patient: item['patientName'],
                                doctor: item['doctorName'],
                                clinic: item['clinicName'],
                              );
                            }
                            if (item['doctorName']
                                .toString()
                                .toLowerCase()
                                .contains(name.toLowerCase())) {
                              return EvaluationDoctorWidget(
                                ratingValue: item['rating'],
                                time: date,
                                desc: item['description'],
                                patient: item['patientName'],
                                doctor: item['doctorName'],
                                clinic: item['clinicName'],
                              );
                            }
                            return Container();
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
