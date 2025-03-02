import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:krushi_admin/controller/Firebase_Controller.dart';

class Add_Sarpanch extends StatefulWidget {
  const Add_Sarpanch({super.key});

  @override
  State<Add_Sarpanch> createState() => _Add_SarpanchState();
}

class _Add_SarpanchState extends State<Add_Sarpanch> {
  final GlobalKey<FormState> KEY= GlobalKey<FormState>();
  var name = TextEditingController();
  var contact = TextEditingController();
  var aadhaarCard = TextEditingController();
  var email = TextEditingController();
  var password = TextEditingController();
  String? selectedVillage;
  List<String> villageNames = [];

  Future<void> fetchVillageNames() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('location').get();
    List<String> names =
        snapshot.docs.map((doc) => doc['village'] as String).toList();

    setState(() {
      villageNames = names;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchVillageNames();
    print(selectedVillage);
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
      appBar: AppBar(
        title: Text("Add Gam Mitra"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
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
                    });
                  },
                  items:
                      villageNames.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                ),
                TextField(
                  controller: name,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Enter Gam Mitra Name",
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
                buildDateField("Choose Date of Birth", dob, (picked) {
                  setState(() {
                    dob = "${picked.day}-${picked.month}-${picked.year}";
                  });
                }),
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
                      Map<String, dynamic> data = {
                        "name": name.text.trim().toString(),
                        "contact": contact.text.trim().toString(),
                        "aadhaarCard": aadhaarCard.text.trim().toString(),
                        "dob": dob,
                        "village": selectedVillage.toString(),
                      };

                   Firebbase_Controller.singUp(email.text.toString(), password.text.toString());
                      Firebbase_Controller.addData("Sarpanch", data);
                      Firebbase_Controller.addUserData(
                        email.text.toString(),
                        password.text.toString(),
                        "Sarpanch",
                      );
                      name.clear();
                      contact.clear();
                      aadhaarCard.clear();
                      email.clear();
                      password.clear();
                      dob = "Choose Date of Birth";
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Data Added")));
                    }
                  },
                  child: Text("Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
