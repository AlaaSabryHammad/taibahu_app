import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class DoctorChatScreen extends StatefulWidget {
  const DoctorChatScreen(
      {super.key, required this.patientId, required this.patientEmail});
  final String patientId, patientEmail;

  @override
  State<DoctorChatScreen> createState() => _DoctorChatScreenState();
}

class _DoctorChatScreenState extends State<DoctorChatScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          title: Text(widget.patientEmail),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                    stream: firebaseFirestore
                        .collection('chat')
                        .doc(
                            '${widget.patientId}${firebaseAuth.currentUser!.uid}')
                        .collection('messages')
                        .where('doctorEmail',
                            isEqualTo: firebaseAuth.currentUser!.email)
                        .where('patientEmail', isEqualTo: widget.patientEmail)
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<MessageWidget> messages = [];
                        for (var message in snapshot.data!.docs) {
                          messages.add(MessageWidget(mDocument: message));
                        }
                        return ListView(
                          reverse: true,
                          children: messages,
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const Center(child: CircularProgressIndicator());
                    }),
              ),
              Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: messageController,
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                  )),
                  TextButton(
                    onPressed: () async {
                      await firebaseFirestore
                          .collection('chat')
                          .doc(
                              '${widget.patientId}${firebaseAuth.currentUser!.uid}')
                          .collection('messages')
                          .add({
                        'text': messageController.text,
                        'time': FieldValue.serverTimestamp(),
                        'doctorEmail': firebaseAuth.currentUser!.email,
                        'patientEmail': widget.patientEmail,
                        'read': false,
                        'sender': 'doctor'
                      });
                      messageController.clear();
                    },
                    child: const Text(
                      'SEND',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  const MessageWidget({super.key, required this.mDocument});
  final QueryDocumentSnapshot mDocument;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: mDocument['sender'] == 'doctor'
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Text(mDocument['sender'] == 'patient'
              ? mDocument['patientEmail']
              : mDocument['doctorEmail']),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              elevation: 10,
              color: mDocument['sender'] == 'doctor' ? mainColor : textColor,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  mDocument['text'],
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
