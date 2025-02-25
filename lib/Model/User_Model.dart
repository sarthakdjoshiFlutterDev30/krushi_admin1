import 'package:cloud_firestore/cloud_firestore.dart';

class User_Model {
  final String id;
  final String Email;
  final String Role;
  final String Password;

  User_Model({
    required this.id,
    required this.Email,
    required this.Role,
    required this.Password,
  });

  factory User_Model.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      ) {
    final data = snapshot.data()!;
    return User_Model(
      id: snapshot.id,
      Email: data['Email']??"",
      Password: data['Password']??"",
      Role: data['Role']??"",
    );

  }
}
