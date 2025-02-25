import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';

class Firebbase_Controller {
 static Future<void> addUserData(String email, String password, String role) async {
    FirebaseFirestore.instance.collection("Users").add({
      "Email": email,
      "Password": password,
      "Role": role,
    });
  }

 static Future<void> singUp(String email, String password) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

 static  Future<void> addData(String collection, Map<String, dynamic> data) async {
    try {
      FirebaseFirestore.instance.collection(collection).add(data);
    } catch (e) {
      print(e.toString());
    }
  }
 static  Future<void> updateData(
    String collection,
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      FirebaseFirestore.instance.collection(collection).doc(id).set(data);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteData(

    String collection,
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      FirebaseFirestore.instance.collection(collection).doc(id).delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
