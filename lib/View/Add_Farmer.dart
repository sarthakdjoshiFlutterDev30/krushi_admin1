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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController aadhaarCardController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  int? selectedValue = 1;
  String gender = "Male";
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String? selectedVillage;
  List<String> villageNames = [];
  String? selectedVillageFriend;
  List<String> villageFriendNames = [];
  String dob = "Choose Date of Birth";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchVillageNames();
  }

  Future<void> fetchVillageNames() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(
        'location').get();
    setState(() {
      villageNames =
          snapshot.docs.map((doc) => doc['village'] as String).toList();
    });
  }

  Future<void> fetchVillageFriendNames() async {
    if (selectedVillage != null) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Sarpanch')
          .where("village", isEqualTo: selectedVillage)
          .get();
      setState(() {
        villageFriendNames =
            snapshot.docs.map((doc) => doc['name'] as String).toList();
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> register() async {
    if (_image == null) return;

    setState(() {
      isLoading = true;
    });

    String fileName = Uuid().v1();
    Reference storageRef = FirebaseStorage.instance.ref().child('Farmer-ProfilePic/$fileName');

    try {
      await storageRef.putFile(_image!);
      String downloadUrl = await storageRef.getDownloadURL();
      Map<String, dynamic> data = {
        "name": nameController.text.trim(),
        "contact": contactController.text.trim(),
        "aadhaarCard": aadhaarCardController.text.trim(),
        "isApprove": "No",
        "dob": dob,
        "gender": gender,
        "village": selectedVillage,
        "sarpanch": selectedVillageFriend,
        "profilePicUrl": downloadUrl,
      };

      await Firebbase_Controller.addData("Farmer", data).then((e) {
        nameController.clear();
        contactController.clear();
        aadhaarCardController.clear();
        emailController.clear();
        passwordController.clear();
        dob = "Choose Date of Birth";
        setState(() {
          _image = null;
          selectedVillage = null;
          selectedVillageFriend = null;
          villageFriendNames.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Form Submitted")));
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Data Added")));
    } catch (e) {
      print('Error occurred while uploading: $e');
    } finally {
      setState(() {
        isLoading = false; // End loading
      });
    }
  }

  bool validateForm() {
    return _formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Farmer"), centerTitle: true),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: <Widget>[
            DropdownButton<String>(
              hint: const Text('Select a village'),
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
              hint: const Text('Select a Sarpanch'),
              value: selectedVillageFriend,
              onChanged: (String? newValue) {
                setState(() {
                  selectedVillageFriend = newValue;
                });
              },
              items: villageFriendNames.map<DropdownMenuItem<String>>((
                  String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            _image == null
                ? const Text('No image selected.')
                : CircleAvatar(
              radius: MediaQuery
                  .of(context)
                  .size
                  .width * 0.4,
              backgroundImage: FileImage(_image!),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: "Enter Farmer Name",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name.';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            buildDateField("Choose Date of Birth", dob, (picked) {
              setState(() {
                dob = "${picked.day}-${picked.month}-${picked.year}";
              });
            }),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: const Text('Pick Image from Gallery'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: const Text('Pick Image from Camera'),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio.adaptive(
                  value: 1,
                  groupValue: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                      gender = "Male";
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
                      gender = "Female";
                    });
                  },
                ),
                const Text("Female"),
              ],
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: contactController,
              keyboardType: TextInputType.number,
              maxLength: 10,
              decoration: const InputDecoration(
                hintText: "Enter Contact No.",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your contact number.';
                } else if (value.length < 10) {
                  return 'Contact number must be at least 10 digits.';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: aadhaarCardController,
              keyboardType: TextInputType.number,
              maxLength: 12,
              decoration: const InputDecoration(
                hintText: "Enter AadhaarCard No.",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your Aadhaar card number.';
                } else if (value.length < 12) {
                  return 'Aadhaar card number must be 12 digits.';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: "Enter Email Address",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty ||
                    !EmailValidator.validate(value)) {
                  return 'Please enter a valid email.';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: passwordController,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Enter Password",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password.';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: isLoading // Disable button when loading
                  ? null
                  : () {
                if (validateForm()) {
                  register();
                  Firebbase_Controller.singUp(emailController.text.trim(),
                      passwordController.text.trim());
                  Firebbase_Controller.addUserData(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                    "Farmer",
                  );
                }
              },
              child: isLoading // Show loading indicator
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(width: 10),
                  Text("Submitting..."),
                ],
              )
                  : const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

  Row buildDateField(String labelText, String date,
      Function(DateTime) onDatePicked) {
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
}