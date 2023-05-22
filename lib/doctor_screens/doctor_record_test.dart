import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/constants.dart';
import 'package:flutter/material.dart';

class DoctorRecordTestScreen extends StatefulWidget {
  const DoctorRecordTestScreen({super.key, required this.item});
  final QueryDocumentSnapshot item;

  @override
  State<DoctorRecordTestScreen> createState() => _DoctorRecordTestScreenState();
}

class _DoctorRecordTestScreenState extends State<DoctorRecordTestScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  String testResult = '';
  List testItems = [];

  getItems() {
    firebaseFirestore
        .collection('bookings')
        .doc(widget.item.id)
        .get()
        .then((value) {
      if (value.data()!['tests'] == null) {
        firebaseFirestore.collection('tests').get().then((value) {
          for (var item in value.docs) {
            setState(() {
              testItems.add({
                'testName': item['name'],
                'result': item['result'],
                'choose': false
              });
            });
          }
        });
      } else {
        setState(() {
          testItems = value.get('tests');
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 70, left: 20, right: 20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'Test Records',
                style: mainHeaderStyle,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Patient Name: ${widget.item["patientName"]}',
                style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 100,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20),
                    itemCount: testItems.length,
                    itemBuilder: (context, index) {
                      var item = testItems[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            item['choose'] = true;
                          });
                          // showDialog(
                          //   context: context,
                          //   builder: (context) => AlertDialog(
                          //     title: Text(
                          //       item['testName'],
                          //       style: TextStyle(
                          //         fontSize: 20,
                          //         fontWeight: FontWeight.bold,
                          //         color: mainColor,
                          //       ),
                          //     ),
                          //     content: TextField(
                          //       textAlign: TextAlign.center,
                          //       onChanged: (value) {
                          //         testResult = value;
                          //       },
                          //     ),
                          //     actions: [
                          //       TextButton(
                          //         onPressed: () {
                          //           setState(() {
                          //             item['result'] = testResult;
                          //           });
                          //           Navigator.pop(context);
                          //         },
                          //         child: const Text('Save'),
                          //       ),
                          //       TextButton(
                          //         onPressed: () {
                          //           Navigator.pop(context);
                          //         },
                          //         child: const Text(
                          //           'Close',
                          //           style: TextStyle(color: Colors.red),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // );
                        },
                        child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: item['choose'] == false
                                    ? Colors.grey
                                    : mainColor,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [customBoxShadow]),
                            child: Center(
                              child: Text(
                                item['testName'],
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            )),
                      );
                    })),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              minWidth: 150,
              elevation: 10,
              color: const Color(0xff261447),
              onPressed: () async {
                await firebaseFirestore
                    .collection('bookings')
                    .doc(widget.item.id)
                    .update({
                  "testSend": 'send',
                });
                testItems.forEach((element) async {
                  if (element['choose'] == true) {
                    await firebaseFirestore
                        .collection('bookings')
                        .doc(widget.item.id)
                        .collection('tests')
                        .add({
                      "name": element['testName'],
                      "result": element['result']
                    });
                  }
                });
                await firebaseFirestore
                    .collection('bookings')
                    .doc(widget.item.id)
                    .update({'tests': true});
                testItems.clear();
                Navigator.pop(context);
              },
              child: const Text(
                'Save Test',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
