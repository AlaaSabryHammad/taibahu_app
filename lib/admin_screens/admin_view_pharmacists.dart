import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../screens/view_screens/view_doctors_screen/doctor_details_screen.dart';

class AdminViewPharmacists extends StatefulWidget {
  const AdminViewPharmacists({super.key});

  @override
  State<AdminViewPharmacists> createState() => _AdminViewPharmacistsState();
}

class _AdminViewPharmacistsState extends State<AdminViewPharmacists> {
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
                'Manage Pharmacists',
                style: TextStyle(
                    color: mainColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Expanded(
                  child: StreamBuilder(
                      stream: firebaseFirestore
                          .collection('pharmacists')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                var item = snapshot.data!.docs[index];
                                return PharmacistCard(
                                  email: item['email'],
                                  image: 'girl',
                                  name: item['name'],
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DoctorDetailsScreen(
                                                  ds: item,
                                                )));
                                  },
                                  delete: () {
                                    print('ddddddddddddd');
                                  },
                                  update: () {},
                                );
                              });
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('${snapshot.error}'),
                          );
                        }
                        return const Center(
                          child: Text('There is no doctors'),
                        );
                      }))
            ],
          ),
        ),
      ),
    );
  }
}

class PharmacistCard extends StatelessWidget {
  const PharmacistCard({
    super.key,
    required this.onPressed,
    required this.update,
    required this.delete,
    required this.name,
    required this.email,
    required this.image,
  });
  final VoidCallback onPressed, update, delete;
  final String name, email, image;

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
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                elevation: 5,
                color: mainColor,
                onPressed: () {},
                child: const Text(
                  'Update',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              MaterialButton(
                elevation: 5,
                color: Colors.red,
                onPressed: () {},
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
