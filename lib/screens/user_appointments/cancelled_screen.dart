import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/screens/user_appointments/widgets/user_card_cancelled.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../widgets/user_action.dart';

class CancelledScreen extends StatefulWidget {
  const CancelledScreen({super.key});

  @override
  State<CancelledScreen> createState() => _CancelledScreenState();
}

class _CancelledScreenState extends State<CancelledScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: firebaseFirestore
              .collection('bookings')
              .where('status', isEqualTo: 'canceled')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    'no cancelled appointments ..',
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
                    return UserCardCancelled(
                      name: item['patientName'],
                      label: item['clinic'],
                      date: item['doctor'],
                      time: date,
                      onPressed: () {
                        customShowModalSheet(context, item);
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
                  'Restore the Appointment..?',
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
                    await firebaseFirestore
                        .collection('bookings')
                        .doc(item.id)
                        .update({
                      'status': 'active',
                    });
                  },
                  label: 'Restore',
                  icon: Icons.add_business,
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
