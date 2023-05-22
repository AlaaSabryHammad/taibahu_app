import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'pharmacist_prescription_details.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class PharmacistPrescriptionSearch extends StatefulWidget {
  const PharmacistPrescriptionSearch({super.key});

  @override
  State<PharmacistPrescriptionSearch> createState() =>
      _PharmacistPrescriptionSearchState();
}

class _PharmacistPrescriptionSearchState
    extends State<PharmacistPrescriptionSearch> {
  String name = '';
  TextEditingController searchController = TextEditingController();

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
                'View Prescriptions',
                style: TextStyle(
                  color: mainColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
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
                  hintText: 'search for Medical File Number .....',
                  border: const OutlineInputBorder()),
            ),
            Expanded(
                child: StreamBuilder(
                    stream: firebaseFirestore
                        .collection('bookings')
                        .where('prescriptions', isEqualTo: true)
                        .orderBy('startTime', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var xItem = snapshot.data!.docs[index];
                              if (name.isEmpty) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PharmacistPrescriptionDetails(
                                                    item: xItem)));
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: mainColor,
                                              style: BorderStyle.solid,
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [customBoxShadow],
                                          color: Colors.white),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    xItem['patientName'],
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: mainColor),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    xItem['medicalFileNumber'],
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: textColor),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                xItem['doctor'],
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: textColor),
                                              ),
                                              Text(
                                                xItem['clinic'],
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: textColor),
                                              ),
                                              Text(
                                                '${xItem['startTime'].toDate()}',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: textColor),
                                              ),
                                            ],
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 25,
                                            color: mainColor,
                                          )
                                        ],
                                      )),
                                );
                              }
                              if (xItem['medicalFileNumber']
                                  .toString()
                                  .toLowerCase()
                                  .contains(name.toLowerCase())) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PharmacistPrescriptionDetails(
                                                    item: xItem)));
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: mainColor,
                                              style: BorderStyle.solid,
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [customBoxShadow],
                                          color: Colors.white),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    xItem['patientName'],
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: mainColor),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    xItem['medicalFileNumber'],
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: textColor),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                xItem['doctor'],
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: textColor),
                                              ),
                                              Text(
                                                xItem['clinic'],
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: textColor),
                                              ),
                                              Text(
                                                '${xItem['startTime'].toDate()}',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: textColor),
                                              ),
                                            ],
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 25,
                                            color: mainColor,
                                          )
                                        ],
                                      )),
                                );
                              }
                              return Container();
                            });
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const Center(child: CircularProgressIndicator());
                    }))
          ],
        ),
      ),
    );
  }
}
