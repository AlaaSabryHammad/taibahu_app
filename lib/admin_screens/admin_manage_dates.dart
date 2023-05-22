import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/admin_screens/success/admin_cancel_dates_success.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
class AdminManagaDates extends StatefulWidget {
  const AdminManagaDates({super.key});

  @override
  State<AdminManagaDates> createState() => _AdminManagaDatesState();
}

class _AdminManagaDatesState extends State<AdminManagaDates> {
  PageController pageController = PageController(initialPage: 0);
  List<Widget> appScreens = [
    const DoctorWidget(),
    const CancelledDatesWidget()
  ];
  int selectedIndex = 0;

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
                'Manage Dates',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                      pageController.animateToPage(0,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.linear);
                    },
                    child: Text(
                      'Select Doctors',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color:
                              selectedIndex == 0 ? Colors.blue : Colors.grey),
                    )),
                TextButton(
                    onPressed: () {
                      setState(() {
                        selectedIndex = 1;
                      });
                      pageController.animateToPage(1,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.linear);
                    },
                    child: Text(
                      'Cancelled Dates',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color:
                              selectedIndex == 1 ? Colors.blue : Colors.grey),
                    )),
              ],
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
                children: appScreens,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorWidget extends StatefulWidget {
  const DoctorWidget({super.key});

  @override
  State<DoctorWidget> createState() => _DoctorWidgetState();
}

class _DoctorWidgetState extends State<DoctorWidget> {
  String name = "";
  TextEditingController searchController = TextEditingController();
  // List<QueryDocumentSnapshot> qDoctors = [];
  // List<String> ids = [];
  List<Map<String, dynamic>> xDoctors = [];
  getDoctors() async {
    await firebaseFirestore.collection('doctors').get().then((value) {
      for (var doc in value.docs) {
        setState(() {
          xDoctors.add({
            'name': doc.data()['name'],
            'clinic': doc.data()['clinic'],
            'doctorId': doc.reference.id,
            'selected': false,
          });
        });
      }
    });
  }

  String textDate = 'Select Date to be Cancelled';
  DateTime? dateTime;
  @override
  void initState() {
    super.initState();
    getDoctors();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Column(
          children: [
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
                  hintText: 'search for Doctor .....',
                  border: const OutlineInputBorder()),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: xDoctors.length,
                  itemBuilder: (context, index) {
                    var item = xDoctors[index];
                    if (name.isEmpty) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(5),
                        width: width - 40,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: mainColor,
                                width: 1,
                                style: BorderStyle.solid),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [customBoxShadow]),
                        child: ListTile(
                          title: Text(
                            item['name'],
                            style: TextStyle(
                                color: mainColor, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(item['clinic']),
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                item['selected'] = !item['selected'];
                              });
                            },
                            icon: Icon(
                              Icons.check_box,
                              color:
                                  item['selected'] ? Colors.blue : Colors.grey,
                            ),
                          ),
                        ),
                      );
                    }
                    if (item['name']
                        .toString()
                        .toLowerCase()
                        .contains(name.toLowerCase())) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(5),
                        width: width - 40,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: mainColor,
                                width: 1,
                                style: BorderStyle.solid),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [customBoxShadow]),
                        child: ListTile(
                          title: Text(
                            item['name'],
                            style: TextStyle(
                                color: mainColor, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(item['clinic']),
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                item['selected'] = !item['selected'];
                              });
                            },
                            icon: Icon(
                              Icons.check_box,
                              color:
                                  item['selected'] ? Colors.blue : Colors.grey,
                            ),
                          ),
                        ),
                      );
                    }
                    return Container();
                  }),
            ),
            MaterialButton(
              color: textColor,
              minWidth: width - 50,
              onPressed: () async {
                dateTime = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100));
                setState(() {
                  textDate = dateTime.toString();
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.date_range,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    textDate ?? 'Select Date to be Cancelled',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ],
              ),
            ),
            MaterialButton(
              color: mainColor,
              minWidth: width - 50,
              onPressed: () async {
                if (xDoctors.isEmpty) {
                  var snackBar =
                      const SnackBar(content: Text('Select Doctor ...'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  if (dateTime == null) {
                    var snackBar =
                        const SnackBar(content: Text('Select date ...'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    xDoctors.forEach((element) async {
                      if (element['selected'] == true) {
                        await firebaseFirestore
                            .collection('cancelledDates')
                            .add({
                          'doctor': element['name'],
                          'doctorId': element['doctorId'],
                          'clinic': element['clinic'],
                          'date': dateTime
                        });
                      }
                    });
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const AdminCancelDatesSuccess()));
                  }
                }
              },
              child: const Text(
                'Save Cancelled dates',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CancelledDatesWidget extends StatefulWidget {
  const CancelledDatesWidget({super.key});

  @override
  State<CancelledDatesWidget> createState() => _CancelledDatesWidgetState();
}

class _CancelledDatesWidgetState extends State<CancelledDatesWidget> {
  String name = "";
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Column(children: [
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
                icon: const Icon(Icons.close),
              ),
              hintText: 'search for Doctor .....',
              border: const OutlineInputBorder(),
            ),
          ),
          Expanded(
              child: StreamBuilder(
                  stream: firebaseFirestore
                      .collection('cancelledDates')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var item = snapshot.data!.docs[index];
                            if (name.isEmpty) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(5),
                                width: width - 40,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: mainColor,
                                        width: 1,
                                        style: BorderStyle.solid),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [customBoxShadow]),
                                child: ListTile(
                                  title: Text(
                                    item['doctor'],
                                    style: TextStyle(
                                        color: mainColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(item['clinic']),
                                      Text('${item['date'].toDate()}'),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                content:
                                                    const Text('Restore Date?'),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () async {
                                                        await firebaseFirestore
                                                            .collection(
                                                                'cancelledDates')
                                                            .doc(item.id)
                                                            .delete();
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text('Ok')),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child:
                                                          const Text('Cancel')),
                                                ],
                                              ));
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              );
                            }
                            if (item['doctor']
                                .toString()
                                .toLowerCase()
                                .contains(name.toLowerCase())) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(5),
                                width: width - 40,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: mainColor,
                                        width: 1,
                                        style: BorderStyle.solid),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [customBoxShadow]),
                                child: ListTile(
                                  title: Text(
                                    item['doctor'],
                                    style: TextStyle(
                                        color: mainColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(item['clinic']),
                                      Text('${item['date'].toDate()}'),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                content:
                                                    const Text('Restore Date?'),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () async {
                                                        await firebaseFirestore
                                                            .collection(
                                                                'cancelledDates')
                                                            .doc(item.id)
                                                            .delete();
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text('Ok')),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child:
                                                          const Text('Cancel')),
                                                ],
                                              ));
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              );
                            }
                            return Container();
                          });
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const Center(child: CircularProgressIndicator());
                  }))
        ]),
      ),
    );
  }
}
