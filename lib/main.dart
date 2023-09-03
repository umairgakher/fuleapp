// import 'package:app/user/splashscree.dart';
// import 'package:app/user/splashscree.dart';
// ignore_for_file: unused_import

import 'package:app/loader.dart';
import 'package:app/user/splashscree.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'Admin/adminDashboard.dart';
import 'user/userdashboard.dart';

void main() async {
  // Ensure that Flutter is initialized.

  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase.
  await Firebase.initializeApp();
  // Continue with the rest of your application setup.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: FuelAppDashboard(),
      // home: UserDashboardScreen(), //test //22222222222222
      // ignore: prefer_const_constructors
      home: Splashscreen(),
      // home: FuelAppDashboard(),//admin
      debugShowCheckedModeBanner: false,
    );
  }
}
