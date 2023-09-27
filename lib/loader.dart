// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, sized_box_for_whitespace

import 'dart:async';
import 'package:app/Admin/adminDashboard.dart';
import 'package:app/Driver/drivre_dashboard.dart';
import 'package:app/user/splashscree.dart';
import 'package:app/user/userdashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    _checkUserAndNavigate();
  }

  void _checkUserAndNavigate() async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    String? email = user?.email;

    if (user != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("email", isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docSnapshot = querySnapshot.docs.first;
        Map<String, dynamic> data = docSnapshot.data();
        int? checkuser = data['checkuser'];

        if (checkuser == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FuelAppDashboard(),
            ),
          );
        } else if (checkuser == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => driverDashbord(),
            ),
          );
        } else if (checkuser == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UserDashboardScreen(),
            ),
          );
        }
      }
    } else {
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WelcomeScreen(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 400,
          height: 400,
          child: Center(
            child: Text(
              "Fule Mate",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }
}
