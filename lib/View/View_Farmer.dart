import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Model/Farmer_Model.dart';
import '../controller/Firebase_Controller.dart';

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
                trailing:
                    (farmer.isApprove == "Yes")
                        ? ElevatedButton(
                          onPressed: () {
                            Firebbase_Controller.deleteData(
                              "Farmer",
                              farmer.id,
                            );
                          },
                          child: Text("Delete"),
                        )
                        : SizedBox(),
                onTap: () {
                  // Handle tap on the farmer item
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => FarmerDetailScreen(
                            farmer: farmer,
                            isapprove: farmer.isApprove,
                          ),
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

class FarmerDetailScreen extends StatefulWidget {
  final Farmer_Model farmer;
  final String isapprove;

  FarmerDetailScreen({
    super.key,
    required this.farmer,
    required this.isapprove,
  });

  @override
  State<FarmerDetailScreen> createState() => _FarmerDetailScreenState();
}

class _FarmerDetailScreenState extends State<FarmerDetailScreen> {
  bool _isLoading = false;

  void _approveFarmer() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Firebbase_Controller.updateData("Farmer", widget.farmer.id, {
        "name": widget.farmer.name,
        "contact": widget.farmer.contact,
        "aadhaarCard": widget.farmer.aadhaarCard,
        "isApprove": "Yes",
        "dob": widget.farmer.dob,
        "gender": widget.farmer.gender,
        "village": widget.farmer.village,
        "sarpanch": widget.farmer.sarpanch,
        "profilePicUrl": widget.farmer.profilePicUrl,
      });
      // Optionally show a success message
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _rejectFarmer() async {
    // Show confirmation dialog before rejecting
    bool? confirm = await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Confirm Reject'),
            content: Text(
              'Are you sure you want to reject And Delete  this farmer?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Firebbase_Controller.deleteData("Farmer", widget.farmer.id);
                  Navigator.pop(context, true);
                },
                child: Text('Yes'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      setState(() {
        _isLoading = true;
      });
      try {
        await Firebbase_Controller.deleteData("Farmer", widget.farmer.id);
        // Optionally show a success message
      } catch (e) {
        // Handle error
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.farmer.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${widget.farmer.name}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            Text('Village: ${widget.farmer.village}'),
            SizedBox(height: 8),
            Text('Sarpanch: ${widget.farmer.sarpanch}'),
            SizedBox(height: 8),
            Text('Gender: ${widget.farmer.gender}'),
            SizedBox(height: 8),
            Text('Date of Birth: ${widget.farmer.dob}'),
            SizedBox(height: 8),
            Text('Contact: ${widget.farmer.contact}'),
            SizedBox(height: 8),
            Text('Aadhaar Card: ${widget.farmer.aadhaarCard}'),
            SizedBox(height: 8),
            Text('Approve: ${widget.farmer.isApprove}'),
            SizedBox(height: 16),
            if (widget.isapprove == "No") ...[
              Row(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _isLoading ? null : _approveFarmer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child:
                        _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text("Approve"),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _rejectFarmer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    child:
                        _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text("Reject"),
                  ),
                ],
              ),
            ],
            SizedBox(height: 16),
            if (widget.farmer.profilePicUrl.isNotEmpty)
              CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.4,
                backgroundImage: NetworkImage(widget.farmer.profilePicUrl),
              ),
          ],
        ),
      ),
    );
  }
}
