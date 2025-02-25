import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Future<void> saveLogin() async {
    await Future.delayed(Duration(seconds: 1)); // Example delay

    if (FirebaseAuth.instance.currentUser?.uid == null) {
      Navigator.pushReplacementNamed(context, "/login");
    } else {
      Navigator.pushReplacementNamed(context, "/home");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    saveLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            CircularProgressIndicator(), // Show a loading indicator while checking login state
      ),
    );
  }
}
