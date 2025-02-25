import 'package:cloud_firestore/cloud_firestore.dart';

class GamMitra_Model {
  final String id;
  final String village;
  final String name;
  final String dob;
  final String contact;
  final String aadhaarCard;

  GamMitra_Model({
    required this.id,
    required this.village,
    required this.name,
    required this.dob,
    required this.contact,
    required this.aadhaarCard,
  });

  factory GamMitra_Model.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      ) {
    final data = snapshot.data()!;
    return GamMitra_Model(
      id: snapshot.id,
      village: data['village']??"",
      name: data['name']??"",
      dob: data['dob']??"",
      contact: data['contact']??"",
      aadhaarCard: data['aadhaarCard']??"",
    );

  }
}
