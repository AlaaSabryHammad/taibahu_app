import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class AdminViewLapDoctors extends StatefulWidget {
  const AdminViewLapDoctors({super.key});

  @override
  State<AdminViewLapDoctors> createState() => _AdminViewLapDoctorsState();
}

class _AdminViewLapDoctorsState extends State<AdminViewLapDoctors> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 70, left: 20, right: 20),
          child: Column(
            children: [
              Text(
                'Manage Doctors',
                style: TextStyle(
                    color: mainColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: StreamBuilder(
                    stream: firebaseFirestore.collection('lapDoctors').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Text(
                              'no Doctors',
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        }
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var item = snapshot.data!.docs[index];
                              if (snapshot.data!.docs.isEmpty) {
                                return  Center(
                                  child: Text('No Doctors',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: textColor),),
                                );
                              } else {
                                return LapCard(
                                  email: item['email'],
                                  image: item['sex'] == 'male' ? 'man' : 'girl',
                                  name: item['name'],
                                  delete: () {
                                    print('ddddddddddddd');
                                  },
                                  update: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) =>
                                    //         DoctorDetailsScreen(
                                    //       ds: item,
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                );
                              }
                            });
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('${snapshot.error}'),
                        );
                      }
                      return const Center(
                        child: Text('There is no doctors'),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class LapCard extends StatelessWidget {
  const LapCard({
    super.key,
    required this.update,
    required this.delete,
    required this.name,
    required this.email,
    required this.image,
  });
  final VoidCallback update, delete;
  final String name, email,  image;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 15),
      height: 150,
      decoration: BoxDecoration(
        border:
            Border.all(color: mainColor, width: 1, style: BorderStyle.solid),
        boxShadow: [
          customBoxShadow,
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'images/$image.png',
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    email,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey),
                  )
                ],
              ),
              // Text(
              //   clinic,
              //   overflow: TextOverflow.ellipsis,
              //   style: TextStyle(
              //       fontSize: 16,
              //       color: mainColor,
              //       fontWeight: FontWeight.bold),
              // )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                elevation: 5,
                color: mainColor,
                onPressed: update,
                child: const Text(
                  'View',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              MaterialButton(
                elevation: 5,
                color: Colors.red,
                onPressed: delete,
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
