import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.receiverDocument});
  final QueryDocumentSnapshot receiverDocument;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
          title: Text(widget.receiverDocument['name']),
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
                            '${firebaseAuth.currentUser!.uid}${widget.receiverDocument.id}')
                        .collection('messages')
                        .where('patientEmail',
                            isEqualTo: firebaseAuth.currentUser!.email)
                        .where('doctorEmail',
                            isEqualTo: widget.receiverDocument['email'])
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<MessageWidget> messages = [];
                        for (var message in snapshot.data!.docs) {
                          messages.add(MessageWidget(
                            mDocument: message,
                            doctor1: widget.receiverDocument['name'],
                          ));
                        }
                        return messages.isEmpty
                            ? const CircularProgressIndicator()
                            : ListView(
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
                      DocumentSnapshot ds = await firebaseFirestore
                          .collection('chat')
                          .doc(
                              '${firebaseAuth.currentUser!.uid}${widget.receiverDocument.id}')
                          .get();
                      if (ds.exists) {
                        await firebaseFirestore
                            .collection('chat')
                            .doc(
                                '${firebaseAuth.currentUser!.uid}${widget.receiverDocument.id}')
                            .collection('messages')
                            .add({
                          'text': messageController.text,
                          'time': FieldValue.serverTimestamp(),
                          'patientEmail': firebaseAuth.currentUser!.email,
                          'patientName': firebaseAuth.currentUser!.displayName,
                          'doctorEmail': widget.receiverDocument['email'],
                          'doctorName': widget.receiverDocument['name'],
                          'read': false,
                          'sender': 'patient'
                        });
                      } else {
                        await firebaseFirestore
                            .collection('chat')
                            .doc(
                                '${firebaseAuth.currentUser!.uid}${widget.receiverDocument.id}')
                            .set({
                          'patientEmail': firebaseAuth.currentUser!.email,
                          'patientName': firebaseAuth.currentUser!.displayName,
                          'doctorEmail': widget.receiverDocument['email'],
                          'doctorName': widget.receiverDocument['name'],
                          'patientId': firebaseAuth.currentUser!.uid,
                          'doctorId': widget.receiverDocument.id,
                        });
                        await firebaseFirestore
                            .collection('chat')
                            .doc(
                                '${firebaseAuth.currentUser!.uid}${widget.receiverDocument.id}')
                            .collection('messages')
                            .add({
                          'text': messageController.text,
                          'time': FieldValue.serverTimestamp(),
                          'patientEmail': firebaseAuth.currentUser!.email,
                          'doctorEmail': widget.receiverDocument['email'],
                          'read': false,
                          'sender': 'patient'
                        });
                      }
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
  const MessageWidget(
      {super.key, required this.mDocument, required this.doctor1});
  final QueryDocumentSnapshot mDocument;
  final String doctor1;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: mDocument['sender'] == 'patient'
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Text(mDocument['sender'] == 'patient'
              ? FirebaseAuth.instance.currentUser!.displayName!
              : doctor1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              elevation: 10,
              color: mDocument['sender'] == 'patient' ? mainColor : textColor,
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
          Text(timeago.format(mDocument['time'].toDate()))
        ],
      ),
    );
  }
}
