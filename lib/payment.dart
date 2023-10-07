// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, avoid_print, unused_local_variable, unnecessary_brace_in_string_interps, non_constant_identifier_names, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Monthly Payments',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('payment')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
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
                        'No fule order yet.',
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

                      var Month = data?['Month'] as String?;
                      var year = data?["year"];
                      var total = data?["payment"];

                      return Card(
                        elevation: 2,
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: Icon(Icons.paypal),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "$Month $year",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text("Total: $total .Rs"),
                          trailing: Column(
                            children: [
                              Text(
                                "Gasoline: ${data?["gas"]}.00 kg", // Use the null operator to handle null values
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                "Petrol: ${data?["patrol"]}.00 Liters", // Use the null operator to handle null values
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                "Diesel: ${data?["desile"]}.00 Liters", // Use the null operator to handle null values
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
