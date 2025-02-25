import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:flutter/material.dart';

import '../controller/Firebase_Controller.dart';

class AddVillage extends StatefulWidget {
  const AddVillage({super.key});

  @override
  State<AddVillage> createState() => _AddVillageState();
}

class _AddVillageState extends State<AddVillage> {
  final GlobalKey<FormState> KEY= GlobalKey<FormState>();

  TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController village = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Village"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Form(
        key: KEY,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CountryStateCityPicker(
                  country: country,
                  state: state,
                  city: city,
                  dialogColor: Colors.grey.shade200,
                  textFieldDecoration: InputDecoration(
                    fillColor: Colors.blueGrey.shade100,
                    filled: true,
                    suffixIcon: const Icon(Icons.add),
                    border: const OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: village,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Enter Village",
                    hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    if (village.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please enter the village name."),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    } else if (country.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please enter the country name."),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    } else if (state.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please enter the state name."),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    } else if (city.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please enter the city name."),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    } else {
                      Map<String, dynamic> data = {
                        "country": country.text.trim().toString(),
                        "state": state.text.trim().toString(),
                        "city": city.text.trim().toString(),
                        "village": village.text.trim().toString(),
                      };
                   Firebbase_Controller.addData("location", data).then((value) {
                        village.clear();
                        country.clear();
                        state.clear();
                        city.clear();
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("Data Added")));
                      });
                    }
                    print("${country.text}, ${state.text}, ${city.text}");
                  },
                  child: Text("Add"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
