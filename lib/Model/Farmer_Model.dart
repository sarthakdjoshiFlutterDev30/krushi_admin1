import 'package:cloud_firestore/cloud_firestore.dart';

class Farmer_Model {
  final String id;
  final String village;
  final String sarpanch;
  final String profilePicUrl;
  final String name;
  final String gender;
  final String dob;
  final String contact;
  final String aadhaarCard;
  final String isApprove;

  Farmer_Model({
    required this.id,
    required this.village,
    required this.sarpanch,
    required this.profilePicUrl,
    required this.name,
    required this.gender,
    required this.dob,
    required this.contact,
    required this.aadhaarCard,
    required this.isApprove,
  });

  factory Farmer_Model.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data()!;
    return Farmer_Model(
      id: snapshot.id,
      village: data['village']??"",
      sarpanch: data['sarpanch'] ?? "",
      profilePicUrl: data['profilePicUrl']??"",
      name: data['name']??"",
      gender: data['gender']??"",
      dob: data['dob']??"",
      contact: data['contact']??"",
      aadhaarCard: data['aadhaarCard']??"",
      isApprove: data['isApprove'] ?? "",
    );

  }
}
