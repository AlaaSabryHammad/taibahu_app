import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/doctor_screens/doctor_appointments.dart';
import 'package:taibahu_app/doctor_screens/doctor_chat_screen.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class DoctorChatHome extends StatefulWidget {
  const DoctorChatHome({super.key});

  @override
  State<DoctorChatHome> createState() => _DoctorChatHomeState();
}

class _DoctorChatHomeState extends State<DoctorChatHome> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            width: width,
            height: 150,
            decoration: BoxDecoration(color: mainColor),
            child: const Center(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Chat with your Patients',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
                stream: firebaseFirestore
                    .collection('chat')
                    .where('doctorEmail',
                        isEqualTo: firebaseAuth.currentUser!.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var item = snapshot.data!.docs[index];
                          return Card(
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DoctorChatScreen(
                                      patientId: item.get('patientId'),
                                      patientEmail: item.get('patientEmail'),
                                    ),
                                  ),
                                );
                              },
                              leading: const CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage('images/girl.png'),
                              ),
                              title: Text(
                                item['patientName'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(item['patientEmail']),
                              trailing: const Icon(Icons.arrow_forward_ios),
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
          ),
        ],
      ),
    );
  }
}
