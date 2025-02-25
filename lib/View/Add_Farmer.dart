import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:krushi_admin/controller/Firebase_Controller.dart';
import 'package:uuid/uuid.dart';

class Add_Farmer extends StatefulWidget {
  const Add_Farmer({super.key});

  @override
  State<Add_Farmer> createState() => _Add_FarmerState();
}

class _Add_FarmerState extends State<Add_Farmer> {
  final GlobalKey<FormState> KEY= GlobalKey<FormState>();
  var name = TextEditingController();
  var contact = TextEditingController();
  var aadhaarCard = TextEditingController();
  var email = TextEditingController();
  var password = TextEditingController();
  int? selectedValue = 1;
  var result = "Male";
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String? selectedVillage;
  List<String> villageNames = [];
  String? selectedVillageFriend;
  List<String> villageFriendNames = [];
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> register() async {
    if (_image == null) return;

    String fileName = Uuid().v1();
    Reference storageRef = FirebaseStorage.instance.ref().child('Farmer-ProfilePic/$fileName');

    try {
      await storageRef.putFile(_image!);
   String downloadUrl = await storageRef.getDownloadURL();
      Map<String, dynamic> data = {
        "name": name.text.trim(),
        "contact": contact.text.trim(),
        "aadhaarCard": aadhaarCard.text.trim(),
        "dob": dob,
        "gender": result,
        "village": selectedVillage,
        "village_friend": selectedVillageFriend,
        "profilePicUrl": downloadUrl,
      };

    await Firebbase_Controller.addData("Farmer", data).then((_){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("data Added")));
      });

    } catch (e) {
      print('Error occurred while uploading: $e');
    }
  }
  Future<void> fetchVillageNames() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('location').get();
    List<String> names =
        snapshot.docs.map((doc) => doc['village'] as String).toList();

    setState(() {
      villageNames = names;
    });
  }

  Future<void> fetchVillageFriendNames() async {
    if (selectedVillage != null) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('GamMitra')
          .where("village", isEqualTo: selectedVillage)
          .get();
      List<String> names =
      snapshot.docs.map((doc) => doc['name'] as String).toList();

      setState(() {
        villageFriendNames = names;
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchVillageNames();
  }

  Row buildDateField(
      String labelText,
      String date,
      Function(DateTime) onDatePicked,
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          date,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              firstDate: DateTime(1950),
              lastDate: DateTime.now(),
              initialDate: DateTime.now(),
            );
            if (picked != null) {
              onDatePicked(picked);
            }
          },
          child: const Text("Choose Date Of Birth"),
        ),
      ],
    );
  }

  var dob = "Choose Date of Birth";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add_Farmer"), centerTitle: true),
      body: Form(
        key: KEY,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                DropdownButton<String>(
                  hint: Text('Select a village'),
                  value: selectedVillage,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedVillage = newValue;
                      fetchVillageFriendNames();
                    });
                  },
                  items: villageNames.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                DropdownButton<String>(
                  hint: Text('Select a GamMitra'),
                  value: selectedVillageFriend,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedVillageFriend = newValue;
                    });
                  },
                  items: villageFriendNames.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                _image == null
                    ? Text('No image selected.')
                    : CircleAvatar( radius: MediaQuery.of(context).size.width * 0.4, // Adjust the size as needed
                  backgroundImage: FileImage(_image!),),
                SizedBox(height: 20),
               TextField(
                  controller: name,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Enter Farmer Name",
                    hintStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                const SizedBox(height: 20),

                buildDateField("Choose Date of Birth", dob, (picked) {
                  setState(() {
                    dob = "${picked.day}-${picked.month}-${picked.year}";
                  });
                }),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  child: Text('Pick Image from Gallery'),
                ),
                SizedBox(height: 10),
                Text("Or"),
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.camera),
                  child: Text('Pick Image from Camera'),
                ),

                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio.adaptive(
                      value: 1,
                      groupValue: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value;
                          result = "Male";
                        });
                      },
                    ),
                    const Text("Male"),
                    Radio.adaptive(
                      value: 2,
                      groupValue: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value;
                          result = "Female";
                        });
                      },
                    ),
                    const Text("Female"),
                  ],
                ),

                SizedBox(height: 10),
                TextField(
                  controller: contact,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: InputDecoration(
                    hintText: "Enter Contact No.",
                    hintStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: aadhaarCard,
                  keyboardType: TextInputType.number,
                  maxLength: 12,
                  decoration: InputDecoration(
                    hintText: "Enter AadhaarCard No.",
                    hintStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Enter EmailAddress",
                    hintStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: password,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  obscuringCharacter: "*",
                  decoration: InputDecoration(
                    hintText: "Enter Password",
                    hintStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (name.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please enter your name.")),
                      );
                    } else if (contact.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please enter your contact number."),
                        ),
                      );
                    } else if (contact.text.length < 10) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Contact number must be at least 10 digits.",
                          ),
                        ),
                      );
                    } else if (aadhaarCard.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please enter your Aadhaar card number."),
                        ),
                      );
                    } else if (aadhaarCard.text.length < 12) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Aadhaar card number must be 12 digits."),
                        ),
                      );
                    } else if (dob == "Choose Date of Birth") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please select your date of birth."),
                        ),
                      );
                    } else if (selectedVillage == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please select your village.")),
                      );
                    } else if (EmailValidator.validate(email.text.toString()) !=
                        true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please Enter Valid Email")),
                      );
                    } else {
                      register();
                      Firebbase_Controller.singUp(email.text.toString(), password.text.toString());
                      Firebbase_Controller.addUserData(
                        email.text.toString(),
                        password.text.toString(),
                        "Farmer",
                      );
                    }
                  },
                  child: Text("Submit"),
                ),
                ElevatedButton(onPressed: (){
                  name.clear();
                  contact.clear();
                  aadhaarCard.clear();
                  email.clear();
                  password.clear();
                  dob = "Choose Date of Birth";
                  _image=null;
                  ScaffoldMessenger.of(
                  context,
                  ).showSnackBar(SnackBar(content: Text("Data Added")));

                }, child: Text("Reset "))

              ],
            ),
          ),
        ),
      ),
    );
  }
}
