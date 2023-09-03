// ignore_for_file: file_names, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, avoid_print, avoid_unnecessary_containers, unused_local_variable, use_build_context_synchronously, unnecessary_cast, unused_import, unused_element, non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'package:app/rates.dart';
import 'package:app/user/placeorder.dart';
import 'package:app/user/signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FuelAppDashboard extends StatefulWidget {
  @override
  _FuelAppDashboardState createState() => _FuelAppDashboardState();
}

class _FuelAppDashboardState extends State<FuelAppDashboard> {
  User? user;
  String? userId;
  String? username;
  String? email;
  int order = 0;
  Timestamp? request_time;
  String searchInput = '';

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

  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    print("initState called");
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    userId = user?.uid;

    // Retrieve the profile image URL from Firestore and set it to `url`
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((snapshot) {
      var data = snapshot.data();
      print("Fetched data: $data");
      if (data != null) {
        print("User data retrieved: $data"); // Check if data is being retrieved
        setState(() {
          email = data['email'];
          username = data['username'];
        });
      } else {
        print(
            "User data not found!"); // Check if data retrieval is unsuccessful
      }
    }).catchError((error) {
      print("Error fetching user data: $error");
    });
  }

  void _deleteFuelStation(String index) {
    try {
      // Get the document ID
      FirebaseFirestore.instance.collection('stations').doc(index).delete();
      print('Document deleted successfully');
    } catch (e) {
      print('Error deleting document: $e');
    }
    setState(() {
      // fuelStations.removeAt(index);
    });
  }

  void _editFuelStation(String index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? newName;
        String? newAddress;

        return AlertDialog(
          title: Text('Edit Fuel Station'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) {
                  newName = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Address'),
                onChanged: (value) {
                  newAddress = value;
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
                print("index:$index");
                // Get the updated phone number
                // Update the phone number in Firestore
                await FirebaseFirestore.instance
                    .collection("stations")
                    .doc(index)
                    .update({
                  "name": newName ?? "",
                  "address": newAddress ?? "",
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

  void _deleteRecentFuelOrder(String index) {
    try {
      // Get the document ID
      FirebaseFirestore.instance.collection('orders').doc(index).delete();
      print('Document deleted successfully');
    } catch (e) {
      print('Error deleting document: $e');
    }
    setState(() {
      // fuelStations.removeAt(index);
    });
    setState(() {
      // recentFuelOrders.removeAt(index);
    });
  }

  void _editRecentFuelOrder(String index) async {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(index)
        .update({"orderstate": 1});
  }

  void _addFuelStation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newName = '';
        String newAddress = '';

        return AlertDialog(
          title: Text('Add Fuel Station'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) {
                  newName = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Address'),
                onChanged: (value) {
                  newAddress = value;
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
              child: Text('Add'),
              onPressed: () {
                setState(() {
                  FirebaseFirestore.instance
                      .collection('stations')
                      .doc()
                      .set({"name": newName, "address": newAddress});
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
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Fuel App',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        elevation: 4,
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
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for fuel stations',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchInput = value;
                });
              },
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Fuel Stations',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Divider(
            thickness: 2,
            indent: 16,
            endIndent: 16,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('stations')
                    .where('name',
                        isEqualTo: searchInput.isNotEmpty ? searchInput : null)
                    // .where('searchableNames', arrayContains: searchInput)
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
                        'No fule station yet.',
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
                      var name = data?['name'];
                      var address = data?['address'];

                      return Card(
                        elevation: 2,
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: Icon(Icons.local_gas_station),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  _editFuelStation(
                                      documents[index].id as String);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _deleteFuelStation(
                                      documents[index].id as String);
                                },
                              ),
                            ],
                          ),
                          subtitle: Text(
                            address,
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          trailing: Text(
                            'Distance ${index + 1} km',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
          ),
          SizedBox(height: 16),
          Text(
            'Recent Fuel Orders',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Divider(
            thickness: 2,
            indent: 16,
            endIndent: 16,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('orders')
                    .where('orderstate', isEqualTo: 0)
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
                      var price = data?['Total'];
                      var address = data?['address'];

                      request_time = data?['orderTime'] as Timestamp?;
                      String formattedRequestTime =
                          formatRequestTime(request_time);
                      order = index + 1;

                      return Card(
                        elevation: 2,
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                                  _editRecentFuelOrder(
                                      documents[index].id as String);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _deleteRecentFuelOrder(
                                      documents[index].id as String);
                                  (index);
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
                          trailing: Text(
                            'Amount: $price',
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _addFuelStation();
        },
        backgroundColor: Colors.orange,
      ),
    );
  }
}

class FuelStation {
  String name;
  String address;

  FuelStation({required this.name, required this.address});
}
