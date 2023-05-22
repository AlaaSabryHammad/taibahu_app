import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/constants.dart';
import 'package:taibahu_app/data.dart';
import 'package:flutter/material.dart';

class DoctorAddPrescription extends StatefulWidget {
  const DoctorAddPrescription({super.key, required this.item});
  final QueryDocumentSnapshot item;
  @override
  State<DoctorAddPrescription> createState() => _DoctorAddPrescriptionState();
}

class _DoctorAddPrescriptionState extends State<DoctorAddPrescription> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  TextEditingController numberController = TextEditingController();
  List prescriptionList = [];
  String? item;
  String? description;
  int? numberOfItems;

  saveItemsInDb() async {
    await firebaseFirestore.collection('preItems').get().then((value) async {
      if (value.docs.isEmpty) {
        for (var item in preItems) {
          await firebaseFirestore
              .collection('preItems')
              .add({'itemName': item});
        }
      }
    });
  }

  String name = '';
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    saveItemsInDb();
  }

  @override
  Widget build(BuildContext context) {
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
                  'Add Prescription',
                  style: mainHeaderStyle,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            name = '';
                            searchController.text = '';
                          });
                        },
                        icon: const Icon(Icons.close)),
                    hintText: 'search for pre. Items .....',
                    border: const OutlineInputBorder()),
              ),
              Expanded(
                child: StreamBuilder(
                    stream:
                        firebaseFirestore.collection('preItems').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var item = snapshot.data!.docs[index];
                              if (name.isEmpty) {
                                return Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: mainColor,
                                            style: BorderStyle.solid,
                                            width: 1),
                                        boxShadow: [customBoxShadow],
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              item['itemName'],
                                              style: TextStyle(
                                                  color: textColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  customShowModalSheetServiceEvaluation(
                                                      context,
                                                      item['itemName']);
                                                },
                                                icon: Icon(
                                                  Icons.add_box,
                                                  color: mainColor,
                                                  size: 30,
                                                ))
                                          ],
                                        ),
                                      ],
                                    ));
                              }
                              if (item['itemName']
                                  .toString()
                                  .toLowerCase()
                                  .contains(name.toLowerCase())) {
                                return Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: mainColor,
                                            style: BorderStyle.solid,
                                            width: 1),
                                        boxShadow: [customBoxShadow],
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              item['itemName'],
                                              style: TextStyle(
                                                  color: textColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  customShowModalSheetServiceEvaluation(
                                                      context,
                                                      item['itemName']);
                                                },
                                                icon: Icon(
                                                  Icons.add_box,
                                                  color: mainColor,
                                                  size: 30,
                                                ))
                                          ],
                                        ),
                                      ],
                                    ));
                              }
                              return Container();
                            });
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const Center(child: CircularProgressIndicator());
                    }),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> customShowModalSheetServiceEvaluation(
      BuildContext context, String itemName) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      itemName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30,
                          color: mainColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    onChanged: (value) {
                      description = value;
                    },
                    decoration: const InputDecoration(
                        hintText: 'write instructions ....'),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      numberOfItems = int.parse(value);
                    },
                    decoration:
                        const InputDecoration(hintText: 'Refel per month ....'),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MaterialButton(
                    minWidth: 120,
                    color: mainColor,
                    onPressed: () {
                      if (numberOfItems == null) {
                        var snackBar =
                            const SnackBar(content: Text('Complete data ...'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        setState(() {
                          prescriptionList.add({
                            'item': itemName,
                            'desc': description ?? '',
                            'count': numberOfItems,
                            'remain': numberOfItems,
                            'taken': 0
                          });
                          firebaseFirestore
                              .collection('bookings')
                              .doc(widget.item.id)
                              .collection('prescription')
                              .add({
                            'item': itemName,
                            'desc': description ?? '',
                            'count': numberOfItems,
                            'remain': numberOfItems,
                            'taken': 0
                          });
                        });
                        description = null;
                        numberOfItems = null;
                        firebaseFirestore
                            .collection('bookings')
                            .doc(widget.item.id)
                            .update({'prescriptions': true});
                      }
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Add Item',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
