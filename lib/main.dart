import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:krushi_admin/Splash.dart';
import 'package:krushi_admin/View/Add_Farmer.dart';
import 'package:krushi_admin/View/Add_Village.dart';
import 'package:krushi_admin/View/Add_Village_Friend.dart';
import 'package:krushi_admin/View/Home.dart';
import 'package:krushi_admin/View/Login.dart';
import 'package:krushi_admin/View/View_Farmer.dart';
import 'package:krushi_admin/View/View_GamMiitra.dart';
import 'package:krushi_admin/View/View_Users.dart';
import 'package:krushi_admin/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale('en'),
      supportedLocales: [
        Locale('en'),
        Locale('es'),

      ],
      debugShowCheckedModeBanner: false,
      title: 'Krushi_Admin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: "/splash",
      routes: {
        "/splash": (context) => Splash(),
        "/login": (context) => Login(),
        "/home": (context) => Home(),
        "/add_village": (context) => AddVillage(),
        "/add_village_friend": (context) => Add_Village_Friend(),
        "/add_farmer":(context)=>Add_Farmer(),
        "/View_Farmer":(context)=>FarmerView(),
        "/View_User":(context)=>ViewUsers(),
        "/View_Gm":(context)=>ViewGammiitra(),
      },
    );
  }
}
