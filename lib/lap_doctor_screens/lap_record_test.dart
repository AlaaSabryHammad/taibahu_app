import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class LapRecordTest extends StatelessWidget {
  const LapRecordTest({super.key, required this.item});
  final QueryDocumentSnapshot item;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 70, left: 20, right: 20),
          child: Column(
            children: [
              Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Record Tests',
                    style: mainHeaderStyle,
                  )),
              Expanded(
                child: StreamBuilder(
                    stream: firebaseFirestore
                        .collection('bookings')
                        .doc(item.id)
                        .collection('tests')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var itemdata = snapshot.data!.docs[index];
                              return Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(bottom: 10),
                                width: width - 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [customBoxShadow],
                                    color: Colors.white,
                                    border: Border.all(
                                        color: mainColor,
                                        style: BorderStyle.solid,
                                        width: 2)),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      itemdata['name'],
                                      style: TextStyle(
                                          color: textColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Current Record: ${itemdata['result']}",
                                      style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextField(
                                      onChanged: (value) async {
                                        await firebaseFirestore
                                            .collection('bookings')
                                            .doc(item.id)
                                            .collection('tests')
                                            .doc(itemdata.id)
                                            .update({'result': value});
                                      },
                                      decoration: const InputDecoration(
                                        hintText: 'write test record .... ',
                                        border: OutlineInputBorder(),
                                      ),
                                    )
                                  ],
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
              MaterialButton(
                color: mainColor,
                onPressed: () async {
                  await firebaseFirestore
                      .collection('bookings')
                      .doc(item.id)
                      .update({'testCompleted': true, 'testSend': 'finish'});
                  Navigator.pop(context);
                },
                child: const Text(
                  'Save Records',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
