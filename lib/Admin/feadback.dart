// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Feadback extends StatefulWidget {
  const Feadback({super.key});

  @override
  State<Feadback> createState() => _FeadbackState();
}

class _FeadbackState extends State<Feadback> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feadback"),
      ),
    );
  }
}
