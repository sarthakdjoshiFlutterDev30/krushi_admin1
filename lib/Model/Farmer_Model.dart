import 'package:cloud_firestore/cloud_firestore.dart';

class Farmer_Model {
  final String id;
  final String village;
  final String village_friend;
  final String profilePicUrl;
  final String name;
  final String gender;
  final String dob;
  final String contact;
  final String aadhaarCard;

  Farmer_Model({
    required this.id,
    required this.village,
    required this.village_friend,
    required this.profilePicUrl,
    required this.name,
    required this.gender,
    required this.dob,
    required this.contact,
    required this.aadhaarCard,
  });

  factory Farmer_Model.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data()!;
    return Farmer_Model(
      id: snapshot.id,
      village: data['village']??"",
      village_friend: data['village_friend']??"",
      profilePicUrl: data['profilePicUrl']??"",
      name: data['name']??"",
      gender: data['gender']??"",
      dob: data['dob']??"",
      contact: data['contact']??"",
      aadhaarCard: data['aadhaarCard']??"",
    );

  }
}
