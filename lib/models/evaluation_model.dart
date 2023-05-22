
// class Doctor {
//   final String id;
//   final String name;

//   Doctor({required this.id, required this.name});

//   factory Doctor.fromJson(Map<String, dynamic> json) {
//     return Doctor(id: json['id'], name: json['name']);
//   }

//   factory Doctor.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
//     final model = Doctor.fromJson(document.data() as Map<String, dynamic>);
//     return model;
//     // final data = document.data();
//     // return Doctor(id: document.id, name: data!["name"]);
//   }

//   // factory Doctor.fromSnapshotId(String doctor_id) {
//   //   DocumentSnapshot<Map<String, dynamic>>? xx;
//   //   // Future<DocumentSnapshot<Map<String, dynamic>>> doctor =
//   //   //     FirebaseFirestore.instance.collection('doctors').doc(doctor_id).get();
//   //   // FirebaseFirestore.instance
//   //   //     .collection('doctors')
//   //   //     .doc(doctor_id)
//   //   //     .snapshots()
//   //   //     .listen((event) {
//   //   //   xx = event;
//   //   // });
//   //   // DocumentSnapshot<Map<String, dynamic>> xx = getDocument(doctor);
//   //   // var item = Doctor.fromSnapshot(getDocument(doctor));
//   //   var dd =
//   //       FirebaseFirestore.instance.collection('doctors').doc(doctor_id).get();
//   //   // Doctor.fromSnapshot(dd);
//   //   return Doctor(id: xx!.id, name: xx!['name']);
//   // }

//   getDocument(
//       Future<DocumentSnapshot<Map<String, dynamic>>> futureDoctor) async {
//     DocumentSnapshot<Map<String, dynamic>> convertedDoctor = await futureDoctor;
//     return convertedDoctor;
//   }
// }

// class Evaluation {
//   final String desc;
//   final Doctor doctor;
//   final String time;

//   Evaluation({required this.desc, required this.doctor, required this.time});

//   factory Evaluation.fromSnapshot(Map<String, dynamic> document) {
//     // DocumentSnapshot<Map<String, dynamic>> document ) {
//     // final data = document.data();
//     return Evaluation(
//         desc: document['description'],
//         doctor: Doctor.fromSnapshotId(document['doctorid']),
//         time: document['time']);
//   }
// }
