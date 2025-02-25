import 'package:flutter/material.dart';
import 'package:krushi_admin/controller/login_controller.dart';

import 'Add_Farmer.dart';
import 'Add_Village.dart';
import 'Add_Village_Friend.dart';
import 'View_Farmer.dart';
import 'View_GamMiitra.dart';
import 'View_Users.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> im = [
    "assets/images/village.png",
    "assets/images/friendship.png",
    "assets/images/farmer.png",
    "assets/images/people.png",
    "assets/images/users.png",
    "assets/images/Gammitra.png",
  ];
  List<String> nm=[
    "Add Village",
    "Add Village Friend",
    "Add Farmer",
    "View All Farmer",
    "View All Users",
    "View All GamMitra",
  ];
  List nav=[
     AddVillage(),
    Add_Village_Friend(),
    Add_Farmer(),
    FarmerView(),
    ViewUsers(),
    ViewGammiitra(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Login_Controller.signOut();
              Navigator.pushReplacementNamed(context, "/login");
            },
            icon: Icon(Icons.logout),
          ),
        ],
        title: Text("Home"),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body:Column(
          children: [
        const Text(
          "Welcome Admin Panel",
          style: TextStyle(
              fontSize: 30,
              color: Colors.indigo,
              fontWeight: FontWeight.w900),
        ),
        SizedBox(height: 20,),
        Expanded(
            child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0,
                children: List.generate(im.length, (index) {
                  return Card(
                    color: Colors.white70,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => nav[index],
                            ));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            child: Image.asset( im[index],
                              width: 50,
                              height: 50,),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            nm[index],
                            style: const TextStyle(
                                fontSize: 20, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  );
                }))),
      ])
    );
  }
}
