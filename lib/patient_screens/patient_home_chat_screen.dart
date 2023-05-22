import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/constants.dart';
import 'package:taibahu_app/patient_screens/patient_chat_screen.dart';
import 'package:flutter/material.dart';

class PatientHomeChatScreen extends StatefulWidget {
  const PatientHomeChatScreen({super.key});

  @override
  State<PatientHomeChatScreen> createState() => _PatientHomeChatScreenState();
}

class _PatientHomeChatScreenState extends State<PatientHomeChatScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  String name = '';
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              width: width,
              height: 200,
              decoration: BoxDecoration(color: mainColor),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Connect to your Doctor',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
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
                          hintText: 'Enter Doctor Name .....',
                          border: const OutlineInputBorder()),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: firebaseFirestore.collection('doctors').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var item = snapshot.data!.docs[index];
                            if (name.isEmpty) {
                              return Card(
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChatScreen(receiverDocument: item),
                                      ),
                                    );
                                  },
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: AssetImage(
                                        item['sex'] == 'Female'
                                            ? 'images/girl.png'
                                            : 'images/man.png'),
                                  ),
                                  title: Text(
                                    item['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(item['clinic']),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                ),
                              );
                            }
                            if (item['name']
                                .toString()
                                .toLowerCase()
                                .contains(name.toLowerCase())) {
                              return Card(
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChatScreen(receiverDocument: item),
                                      ),
                                    );
                                  },
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: AssetImage(
                                        item['sex'] == 'Female'
                                            ? 'images/girl.png'
                                            : 'images/man.png'),
                                  ),
                                  title: Text(
                                    item['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(item['clinic']),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                ),
                              );
                            }
                            return Container();
                          });
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
