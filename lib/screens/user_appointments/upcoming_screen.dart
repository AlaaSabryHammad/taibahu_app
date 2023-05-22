import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/admin_screens/admin_update_app.dart';
import 'package:flutter/material.dart';
import 'package:taibahu_app/screens/user_appointments/widgets/user_card_upcoming.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import '../../widgets/user_action.dart';

class UpcomingScreen extends StatefulWidget {
  const UpcomingScreen({super.key});

  @override
  State<UpcomingScreen> createState() => _UpcomingScreenState();
}

class _UpcomingScreenState extends State<UpcomingScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  String serverToken =
      'AAAA-QED1ug:APA91bEFdibthFcdVMIa5X_iOaojxbaw0pUC82-WM67WjP738qBKzzYt7k7oIaWIi7bSvjvS_LzFEytQQDre19uiEEh_AliIoq-35PuYjggYqOEfiFgibyFSqX_LJ0TiO6VXT48F2EPd';
  sendNotification(String token, String doctor, DateTime startTime) async {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'you have an appointment with $doctor at $startTime',
            'title': 'Appointment Notification'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            'name': 'Alaaaaaaaaaaaaaaaa'
          },
          'to': token,
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: firebaseFirestore
              .collection('bookings')
              .where('status', isEqualTo: 'active')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    'no upcomming appointments ..',
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
                    return UserCard(
                      name: item['patientName'],
                      label: item['clinic'],
                      date: item['doctor'],
                      time: date,
                      onPressed: () async {
                        customShowModalSheet(context, item);
                      },
                      update: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AdminUpdateApp()),
                        );
                      },
                      send: () {
                        firebaseFirestore
                            .collection('patients')
                            .doc(item['patientId'])
                            .get()
                            .then((value) {
                          sendNotification(value.data()!['token'],
                              item['doctor'], item['startTime'].toDate());
                        });
                        // firebaseFirestore.collection('bookings').doc(item.id).
                        // sendNotification(item.get('field'))
                      },
                    );
                  });
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }

  Future<dynamic> customShowModalSheet(
      BuildContext context, QueryDocumentSnapshot item) {
    return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Cancel the Appointment..?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30,
                      color: mainColor,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 30,
                ),
                UserAction(
                  onPressed: () async {
                    Navigator.pop(context);
                    // Navigator.pushNamed(context, '/admin-view-patients');
                    await firebaseFirestore
                        .collection('bookings')
                        .doc(item.id)
                        .update({
                      'status': 'canceled',
                    });
                  },
                  label: 'Delete',
                  icon: Icons.delete,
                ),
                const SizedBox(
                  height: 30,
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          );
        });
  }
}
