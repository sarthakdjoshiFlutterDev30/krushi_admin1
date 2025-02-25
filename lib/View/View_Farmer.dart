import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:krushi_admin/controller/Firebase_Controller.dart';
import '../Model/Farmer_Model.dart';

class FarmerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Farmers')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('Farmer').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No farmers found.'));
          }

          final farmers =
              snapshot.data!.docs
                  .map((doc) => Farmer_Model.fromFirestore(doc))
                  .toList();

          return ListView.builder(
            itemCount: farmers.length,
            itemBuilder: (context, index) {
              final farmer = farmers[index];
              return ListTile(
                leading:
                    farmer.profilePicUrl.isNotEmpty
                        ? CircleAvatar(
                          backgroundImage: NetworkImage(farmer.profilePicUrl),
                        )
                        : CircleAvatar(child: Icon(Icons.person)),
                title: Text(farmer.name),
                subtitle: Text('Village: ${farmer.village}'),
                onTap: () {
                  // Handle tap on the farmer item
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FarmerDetailScreen(farmer: farmer),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class FarmerDetailScreen extends StatelessWidget {
  final Farmer_Model farmer;

  const FarmerDetailScreen({Key? key, required this.farmer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(farmer.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${farmer.name}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            Text('Village: ${farmer.village}'),
            SizedBox(height: 8),
            Text('Friend Village: ${farmer.village_friend}'),
            SizedBox(height: 8),
            Text('Gender: ${farmer.gender}'),
            SizedBox(height: 8),
            Text('Date of Birth: ${farmer.dob}'),
            SizedBox(height: 8),
            Text('Contact: ${farmer.contact}'),
            SizedBox(height: 8),
            Text('Aadhaar Card: ${farmer.aadhaarCard}'),
            SizedBox(height: 16),
            if (farmer.profilePicUrl.isNotEmpty)
              CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.4,
                backgroundImage: NetworkImage(farmer.profilePicUrl),
              ),
          ],
        ),
      ),
    );
  }
}
