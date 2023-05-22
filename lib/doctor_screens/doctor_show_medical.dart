import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/constants.dart';
import 'package:flutter/material.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class DoctorShowMedical extends StatelessWidget {
  const DoctorShowMedical(
      {super.key, required this.patient, required this.patientId});
  final Map<String, dynamic> patient;
  final String patientId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 70, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'Medical Report',
                style: mainHeaderStyle,
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: Text(
                  "${patient['fname']} ${patient['lname']}",
                  style: TextStyle(color: textColor, fontSize: 14),
                )),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: FutureBuilder(
                future: firebaseFirestore
                    .collection('bookings')
                    .where('isRefered', isEqualTo: false)
                    .where('status', isEqualTo: 'completed')
                    .orderBy('startTime', descending: true)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var item = snapshot.data!.docs[index];
                          return DetailWidget(
                            item: item,
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            MaterialButton(
              color: mainColor,
              elevation: 10,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Done',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DetailWidget extends StatelessWidget {
  const DetailWidget({
    super.key,
    required this.item,
  });
  final QueryDocumentSnapshot item;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      width: width - 40,
      // height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [customBoxShadow],
        border:
            Border.all(color: mainColor, width: 1, style: BorderStyle.solid),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.get('doctor'),
            style: TextStyle(
                color: textColor, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(
            item.get('clinic'),
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
          ),
          Text(
            "${item.get('startTime').toDate()}",
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
          ),
          Text(
            "Diagnosis : ${item.get('patientDiagnosis')}",
            style: TextStyle(
                color: mainColor, fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Prescriptions',
            style: TextStyle(
                color: mainColor, fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 40,
            child: FutureBuilder(
                future: firebaseFirestore
                    .collection('bookings')
                    .doc(item.id)
                    .collection('prescription')
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var xData = snapshot.data!.docs[index];
                          return Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: 100,
                              decoration: BoxDecoration(color: textColor),
                              child: Center(
                                  child: Text(
                                xData['item'],
                                style: const TextStyle(color: Colors.white),
                              )));
                        });
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Laporatory Results',
            style: TextStyle(
                color: mainColor, fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 40,
            child: FutureBuilder(
                future: firebaseFirestore
                    .collection('bookings')
                    .doc(item.id)
                    .collection('tests')
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var xData = snapshot.data!.docs[index];
                          return Container(
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.only(right: 10),
                              width: 100,
                              decoration: BoxDecoration(color: textColor),
                              child: Center(
                                  child: Text(
                                '${xData['name']}(${xData['result']})',
                                style: const TextStyle(color: Colors.white),
                              )));
                        });
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
          )
        ],
      ),
    );
  }
}
