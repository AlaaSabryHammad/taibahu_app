import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/constants.dart';
import 'package:flutter/material.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class PharmacistPrescriptionDetails extends StatelessWidget {
  const PharmacistPrescriptionDetails({super.key, required this.item});
  final QueryDocumentSnapshot item;

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
                'Prescription Details',
                style: mainHeaderStyle,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: StreamBuilder(
                stream: firebaseFirestore
                    .collection('bookings')
                    .doc(item.id)
                    .collection('prescription')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var xItem = snapshot.data!.docs[index];
                          int? number;
                          TextEditingController textcontroller =
                              TextEditingController();
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: mainColor,
                                    style: BorderStyle.solid,
                                    width: 1),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [customBoxShadow]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  xItem['item'],
                                  style: TextStyle(
                                      color: mainColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Count : ${xItem['count']}',
                                      style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    Text(
                                      'Remain : ${xItem['remain']}',
                                      style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        controller: textcontroller,
                                        enabled:
                                            xItem['remain'] == 0 ? false : true,
                                        onChanged: (value) {
                                          number = int.parse(value);
                                        },
                                        decoration: InputDecoration(
                                            hintText: xItem['remain'] == 0
                                                ? 'No remaining quantity...'
                                                : 'Enter the quantity ..',
                                            border: const OutlineInputBorder()),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          if (number == null) {
                                            var snackBar = const SnackBar(
                                                content:
                                                    Text('write the count'));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          } else {
                                            firebaseFirestore
                                                .collection('bookings')
                                                .doc(item.id)
                                                .collection('prescription')
                                                .doc(xItem.id)
                                                .update({
                                              'remain':
                                                  xItem['remain'] - number,
                                              'taken': xItem['taken'] + number,
                                            });
                                            // List<QueryDocumentSnapshot> zz = [];
                                            // firebaseFirestore
                                            //     .collection('bookings')
                                            //     .doc(item.id)
                                            //     .collection('prescription')
                                            //     .get()
                                            //     .then((value) {
                                            //   for (var element in value.docs) {
                                            //     if (element.get('remain') !=
                                            //         0) {
                                            //       zz.add(element);
                                            //     }
                                            //   }
                                            // });
                                            // if (zz.isEmpty) {
                                            //   firebaseFirestore
                                            //       .collection('bookings')
                                            //       .doc(item.id)
                                            //       .update({
                                            //     'prescriptionCounts':
                                            //         'completed'
                                            //   });
                                            // }
                                            // textcontroller.clear();
                                          }
                                        },
                                        icon: Icon(
                                          Icons.save,
                                          size: 30,
                                          color: mainColor,
                                        ))
                                  ],
                                ),
                              ],
                            ),
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
              minWidth: 120,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Done',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
