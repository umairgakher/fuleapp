// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, unused_local_variable, unused_element, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Rates extends StatefulWidget {
  const Rates({super.key});

  @override
  State<Rates> createState() => _RatesState();
}

class _RatesState extends State<Rates> {
  User? user = FirebaseAuth.instance.currentUser;
  String? email;
  @override
  void initState() {
    super.initState();
    email = user?.email;
  }

  void _editFuelStation(String index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? newName;
        String? newAddress;

        return AlertDialog(
          title: Text('Edit $index price'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'price'),
                onChanged: (value) {
                  newName = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                // Get the updated phone number
                // Update the phone number in Firestore
                await FirebaseFirestore.instance
                    .collection("rate")
                    .doc(index)
                    .update({
                  "price": newName ?? "",
                });

                // Update the UI with the new phone number

                setState(() {
                  // fuelStations[index].name = newName;
                  // fuelStations[index].address = newAddress;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Rates",
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Colors.orange,
        ),
        body: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('rate').snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

              if (documents.isEmpty) {
                return Center(
                  child: Text(
                    'No docoment yet.',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: documents.length,
                itemBuilder: (BuildContext context, int index) {
                  QueryDocumentSnapshot document = documents[index];
                  Map<String, dynamic>? data =
                      documents[index].data() as Map<String, dynamic>?;
                  var price = data?['price'];

                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: Icon(Icons.local_gas_station),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              documents[index].id,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          email == "admin@example.com"
                              ? IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _editFuelStation(documents[index].id);
                                  },
                                )
                              : SizedBox(),
                        ],
                      ),
                      subtitle: Text(
                        "$price",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            // .where('sea,builder: ),
          ),
        ));
  }
}
