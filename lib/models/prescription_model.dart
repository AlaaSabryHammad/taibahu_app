
class Prescription {
  final String item, desc;

  Prescription({required this.item, required this.desc});

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(item: json['item'], desc: json['item']);
  }

  // factory Prescription.fromSnapshot(DocumentSnapshot document) {
  //   var item = document.data();
  //   return item;
  // }
  // toMap(Prescription pre) {
  //   return {
  //     'item' : pre.item,
  //     'desc' : pre.desc
  //   };
  // }
}
