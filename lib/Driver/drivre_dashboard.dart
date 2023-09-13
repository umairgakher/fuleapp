// ignore_for_file: prefer_const_constructors, camel_case_types, unused_local_variable, non_constant_identifier_names, unnecessary_cast, avoid_print

import 'package:app/Driver/deleverOrders.dart';
import 'package:app/rates.dart';
import 'package:app/user/signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class driverDashbord extends StatefulWidget {
  const driverDashbord({super.key});

  @override
  State<driverDashbord> createState() => _driverDashbordState();
}

class _driverDashbordState extends State<driverDashbord> {
  User? user;
  String? userId;
  String? username;
  String? email;
  int order = 0;
  Timestamp? request_time;
  int? ondelivery;
  String searchInput = '';

  @override
  void initState() {
    print("initState called");
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    userId = user?.uid;
    fetchUserData();
    // Inside initState
    // FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(userId)
    //     .get()
    //     .then((snapshot) {
    //   var data = snapshot.data();
    //   print("Fetched data1: $data");
    //   print("Fetched data: $data");
    //   if (data != null) {
    //     print("User data retrieved: $data"); // Check if data is being retrieved
    //     setState(() {
    //       email = data['email'];
    //       username = data['username'];
    //       ondelivery = data['ondelivery'] as int?;
    //       // ignore: prefer_interpolation_to_compose_strings
    //       print("ondelivery $ondelivery"); // Fetch ondelivery as int
    //     });
    //   } else {
    //     print(
    //         "User data not found!"); // Check if data retrieval is unsuccessful
    //   }
    // }).catchError((error) {
    //   print("Error fetching user data: $error");
    // });
  }

  String? date;
  String formatRequestTime(Timestamp? timestamp) {
    if (timestamp != null) {
      DateTime dateTime = timestamp.toDate();
      date = DateFormat('yyyy-MM-dd ').format(dateTime);
      return DateFormat('HH:mm:ss').format(dateTime);
    } else {
      return '';
    }
  }

  void fetchUserData() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((snapshot) {
      var data = snapshot.data();
      print("Fetched data: $data");
      if (data != null) {
        setState(() {
          email = data['email'];
          username = data['username'];
          ondelivery = data['ondelivery'] as int?;
        });
      } else {
        print("User data not found!");
      }
    }).catchError((error) {
      print("Error fetching user data: $error");
    });
  }

  void _editRecentFuelOrder(String index) async {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(index)
        .update({"orderstate": 2, "orderDeliver": userId});
    await FirebaseFirestore.instance.collection("users").doc(userId).update({
      "ondelivery": 1,
    });
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
          'Driver Dashboard',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.orange),
                accountName: Text(
                  username ??
                      "Unknown", // Provide a default value if username is null
                  style: TextStyle(fontSize: 18),
                ),
                accountEmail: Text(email ??
                    ""), // Use the null-aware operator to handle null values
                currentAccountPictureSize: Size.square(100),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Rates'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Rates()),
                );

                // Handle accept feature
              },
            ),
            Divider(
              thickness: 1,
              color: Colors.grey,
              indent: 16,
              endIndent: 16,
            ),
            ListTile(
              leading: const Icon(Icons.av_timer_sharp),
              title: const Text('Recent Orders'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => deliverOrder()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete'),
              onTap: () {
                // Handle delete feature
              },
            ),
            Divider(
              thickness: 1,
              color: Colors.grey,
              indent: 16,
              endIndent: 16,
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Future.delayed(Duration(seconds: 2), () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => loginScreen()),
                      (route) => false,
                    );
                  });
                });
                // Handle logout feature
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where(
              'orderstate',
              isEqualTo: 1,
            )
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

          if (documents.isEmpty) {
            return Center(
              child: Text(
                'No fuel orders yet.',
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
              var price = data?['Total'];
              var address = data?['address'];
              var orderstate = data?["orderstate"];

              request_time = data?['orderTime'] as Timestamp?;
              String formattedRequestTime = formatRequestTime(request_time);
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
                          "Order$order",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.done),
                        onPressed: () {
                          print("ondelivery$ondelivery");
                          fetchUserData();

                          if (ondelivery == 0) {
                            _editRecentFuelOrder(documents[index].id as String);
                          } else {
                            Fluttertoast.showToast(
                              msg: "Firstly complete your first order",
                              toastLength: Toast
                                  .LENGTH_SHORT, // Duration of the toast (short or long)
                              gravity: ToastGravity
                                  .BOTTOM, // Location of the toast (e.g., top, center, bottom)
                              timeInSecForIosWeb:
                                  1, // Duration for iOS (ignored on Android)
                              backgroundColor: Colors.orange.withOpacity(
                                  0.7), // Background color of the toast
                              textColor: Colors
                                  .white, // Text color of the toast message
                              fontSize: 16.0, // Font size of the toast message
                            );
                          }
                        },
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
                        date!,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
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
