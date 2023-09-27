// ignore_for_file: prefer_const_constructors, sort_child_properties_last, file_names, camel_case_types, non_constant_identifier_names, unused_element, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class deliverOrder extends StatefulWidget {
  const deliverOrder({Key? key}) : super(key: key);

  @override
  State<deliverOrder> createState() => _deliverOrderState();
}

class _deliverOrderState extends State<deliverOrder> {
  Timestamp? request_time;
  User? user = FirebaseAuth.instance.currentUser;
  int order = 0;
  String? userId;
  String? date;

  @override
  void initState() {
    userId = user?.uid;
    super.initState();
  }

  String formatRequestTime(Timestamp? timestamp) {
    if (timestamp != null) {
      DateTime dateTime = timestamp.toDate();
      date = DateFormat('yyyy-MM-dd ').format(dateTime);
      return DateFormat('HH:mm:ss').format(dateTime);
    } else {
      return '';
    }
  }

  void _editRecentFuelOrder(String index) async {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(index)
        .update({"orderstate": 1});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Recent Order',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where("orderDeliver", isEqualTo: userId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<QueryDocumentSnapshot> documents = snapshot.data?.docs ?? [];

          if (documents.isEmpty) {
            return Center(
              child: Text(
                'No fuel orders yet for this user.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (BuildContext context, int index) {
              QueryDocumentSnapshot document = documents[index];
              Map<String, dynamic>? data =
                  document.data() as Map<String, dynamic>?;

              var price = data?['Total'];

              request_time = data?['orderTime'] as Timestamp?;
              date = data?['date'] as String?;
              order = index + 1;
              var fuletype = data?['fuleType'] as String?;
              var phone = data?["phoneNo"];
              var carno = data?["carNo"];

              return Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Order $order",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatRequestTime(request_time),
                        style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text(
                        date!, // Use the null operator to handle null values
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      if (data?['orderstate'] == 0 || data?['orderstate'] == 1)
                        ElevatedButton(
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "pending",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                        )
                      else if (data?['orderstate'] == 2)
                        ElevatedButton(
                          onPressed: () async {
                            // Update orderstate to 3
                            await FirebaseFirestore.instance
                                .collection("orders")
                                .doc(document.id)
                                .update({
                              "orderstate": 3,
                            });

                            // Update ondelivery to 0
                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(userId)
                                .update({
                              "ondelivery": 0,
                            });

                            // Refresh the UI
                            setState(() {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Done",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                        )
                      else if (data?['orderstate'] == 3)
                        ElevatedButton(
                          onPressed: () async {
                            // Handle the action for orderstate 3
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Success",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                        ),
                    ],
                  ),
                  trailing: Column(
                    children: [
                      Text(
                        fuletype!, // Use the null operator to handle null values
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        "Car no:$carno", // Use the null operator to handle null values
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        'Amount: ${price?.toStringAsFixed(2) ?? ''}', // Use the null operator to handle null values
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
        },
      ),
    );
  }
}