import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:krushi_admin/Model/Sarpanch_Model.dart';


class ViewSarpanch extends StatefulWidget {
  const ViewSarpanch({super.key});

  @override
  State<ViewSarpanch> createState() => _ViewSarpanchState();
}

class _ViewSarpanchState extends State<ViewSarpanch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Sarpanch"),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('Sarpanch').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No gms found.'));
          }

          final GamMitra =
          snapshot.data!.docs
              .map((doc) => sarpanch_Model.fromFirestore(doc))
              .toList();

          return ListView.builder(
            itemCount: GamMitra.length,
            itemBuilder: (context, index) {
              final gm = GamMitra[index];
              return ListTile(
                leading:
                CircleAvatar(
                  backgroundColor: Colors.grey.shade600,
                  child: Text((index+1).toString(),style: TextStyle(color: Colors.white),),
                ),
                title: Text(gm.name),
                subtitle: Text('Village: ${gm.village}'),
                onTap: () {
                  // Handle tap on the gm item
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => gmDetailScreen(gm: gm),
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
class gmDetailScreen extends StatelessWidget {
  final sarpanch_Model gm;

  const gmDetailScreen({Key? key, required this.gm}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text(gm.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${gm.name}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            Text('Village: ${gm.village}'),
            SizedBox(height: 8),
            Text('Date of Birth: ${gm.dob}'),
            SizedBox(height: 8),
            Text('Contact: ${gm.contact}'),
            SizedBox(height: 8),
            Text('Aadhaar Card: ${'*' * gm.aadhaarCard.length}'),
          ],
        ),
      ),
    );
  }
}
