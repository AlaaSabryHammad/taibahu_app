import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/screens/user_appointments/widgets/user_card_completed.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class CompletedScreen extends StatefulWidget {
  const CompletedScreen({super.key});

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  List<UserCardCompleted> completedDates = [];

  getCompletedDates() async {
    await firebaseFirestore
        .collection('bookings')
        .where('status', isEqualTo: 'completed')
        .get()
        .then((value) {
      for (var item in value.docs) {
        DateTime dateTime = item['startTime'].toDate();
        String date = '$dateTime';
        setState(() {
          completedDates.add(UserCardCompleted(
              name: item['patientName'],
              label: item['clinic'],
              date: item['doctor'],
              time: date));
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getCompletedDates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: firebaseFirestore
              .collection('bookings')
              .where('status', isEqualTo: 'completed')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    'no completed appointments ..',
                    style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var item = snapshot.data!.docs[index];
                    DateTime dateTime = item['startTime'].toDate();
                    String date = '$dateTime';
                    return UserCardCompleted(
                        name: item['patientName'],
                        label: item['clinic'],
                        date: item['doctor'],
                        time: date);
                  });
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const Center(child: CircularProgressIndicator());
          }),

      // body: ListView.builder(
      //     itemCount: completedDates.length,
      //     itemBuilder: (context, index) {
      //       var item = completedDates[index];
      //       return item;
      //     }),
    );
  }
}
