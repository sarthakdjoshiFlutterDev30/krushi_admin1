import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:krushi_admin/Model/User_Model.dart';

import '../Model/Farmer_Model.dart';

class ViewUsers extends StatefulWidget {
  const ViewUsers({super.key});

  @override
  State<ViewUsers> createState() => _ViewUsersState();
}

class _ViewUsersState extends State<ViewUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Users"),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No Users found.'));
          }

          final Users =
          snapshot.data!.docs
              .map((doc) => User_Model.fromFirestore(doc))
              .toList();

          return ListView.builder(
            itemCount: Users.length,
            itemBuilder: (context, index) {
              final User = Users[index];
              return ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPassword(um: User) ,));
                },
                leading:
                 CircleAvatar(
                   backgroundColor: Colors.grey.shade600,
                  child: Text((index+1).toString(),style: TextStyle(color: Colors.white),),
                ),
                title: Text('Email:${User.Email}'),
                subtitle: Text('Role:${User.Role}'),
                trailing: Icon(Icons.remove_red_eye),
              );
            },
          );
        },
      ),
    );
  }
}
class ViewPassword extends StatelessWidget {
  final User_Model um;
  const ViewPassword({super.key, required this.um});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Password"),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('Email:${um.Email}'),
            Text('Password:${um.Password}'),
            Text('Role:${um.Role}'),
          ],
        ),
      ),

    );
  }
}
