import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AdminViewEvaluationDetails extends StatefulWidget {
  const AdminViewEvaluationDetails({super.key, required this.item});
  final QueryDocumentSnapshot item;

  @override
  State<AdminViewEvaluationDetails> createState() =>
      _AdminViewEvaluationDetailsState();
}

class _AdminViewEvaluationDetailsState
    extends State<AdminViewEvaluationDetails> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 70, left: 20, right: 20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'Service Evaluation',
                style: mainHeaderStyle,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Patient Name',
                style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: width - 40,
              height: 50,
              decoration: BoxDecoration(
                boxShadow: [customBoxShadow],
                color: const Color(0xffF1FAEE),
                border: Border.all(
                    color: textColor, width: 1, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(
                  widget.item['patientName'],
                  style: TextStyle(
                      color: mainColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Doctor Name',
                style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: width - 40,
              height: 50,
              decoration: BoxDecoration(
                boxShadow: [customBoxShadow],
                color: const Color(0xffF1FAEE),
                border: Border.all(
                    color: textColor, width: 1, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                  child: Text(
                widget.item['doctorName'],
                style: TextStyle(
                    color: mainColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Time',
                style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: width - 40,
              height: 50,
              decoration: BoxDecoration(
                boxShadow: [customBoxShadow],
                color: const Color(0xffF1FAEE),
                border: Border.all(
                    color: textColor, width: 1, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                  child: Text(
                '${widget.item['time'].toDate()}',
                style: TextStyle(
                    color: mainColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )),
            ),
            const SizedBox(
              height: 20,
            ),
            RatingBar.builder(
              itemSize: 20,
              initialRating: widget.item['rating'],
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
                // widget.item['rating'] = rating;
              },
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Evaluation',
                style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                width: width - 40,
                // height: 50,
                decoration: BoxDecoration(
                  boxShadow: [customBoxShadow],
                  border: Border.all(
                      color: textColor, width: 1, style: BorderStyle.solid),
                  color: const Color(0xffF1FAEE),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                    child: Text(
                  widget.item['description'],
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                      color: mainColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
              minWidth: width - 150,
              elevation: 5,
              color: mainColor,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Done',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
