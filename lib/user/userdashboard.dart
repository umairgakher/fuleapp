// ignore_for_file: unnecessary_import, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, sized_box_for_whitespace, sort_child_properties_last, prefer_const_literals_to_create_immutables, deprecated_member_use, avoid_unnecessary_containers, avoid_print, unused_local_variable

import 'package:app/profile.dart';
import 'package:app/rates.dart';
import 'package:app/user/googlemap.dart';
import 'package:app/user/location_controller.dart';
import 'package:app/user/placeorder.dart';
import 'package:app/user/recent_order.dart';
import 'package:app/user/seemore.dart';
import 'package:app/user/signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'help.dart';
// Import the sign-in screen file

class UserDashboardScreen extends StatefulWidget {
  @override
  _UserDashboardScreenState createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  bool _loggingOut = false;
  User? user;
  String? userId;
  String? username;
  String? email;

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

  void _logout() {
    setState(() {
      _loggingOut = true;
    });

    FirebaseAuth.instance.signOut().then((value) {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => loginScreen()),
          (route) => false,
        );
      });
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
          'User Dashboard',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0),
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
            //DrawerHeader
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile '),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                )
              },
              // onTap: () {
              //   Navigator.pop(context);
              // },
            ),
            Divider(),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Rates'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Rates()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: const Icon(Icons.av_timer_sharp),
              title: const Text('Recent Orders'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecentOrder()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: const Icon(Icons.workspace_premium),
              title: const Text('Top Stations'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TrendingPumpsScreen()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TermsAndConditionsScreen()),
                );
              },
            ),

            Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('LogOut'),
              onTap: _logout,
            ),
          ],
        ),
      ), //Drawer
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  child:
                      Text("Firstly select location from map then place order"),
                )),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapSample()),
                );
              },
              child: Container(
                width: double.infinity,
                height: 250,
                child: Image.network(
                  'https://cdngeneral.rentcafe.com/dmslivecafe/2/83880/400%20Walmer%20map.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 0,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 100, top: 20, left: 10),
              child: Text(
                'Welcome to Fuel Mate',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.9,
              child: ElevatedButton(
                onPressed: () {
                  LocationController().currentLocation != null &&
                          LocationController().selectedLocationAddress != null
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => order()),
                        )
                      : Fluttertoast.showToast(
                          msg: "Select location from map please",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.orange,
                          textColor: Colors.white,
                        );

                  // Handle button press
                },
                child: const Text(
                  'Place an order',
                  style: TextStyle(
                    color: Colors.white, // Set text color to white
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Colors.orange), // Set button background color to yellow
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 250, top: 10),
                    child: Text(
                      "FUEL RATES",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('rate')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        List<QueryDocumentSnapshot> documents =
                            snapshot.data!.docs;

                        if (documents.isEmpty) {
                          return Center(
                            child: Text(
                              'No document yet.',
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                        }

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: documents.map((document) {
                              int index = documents.indexOf(document);
                              Map<String, dynamic>? data =
                                  document.data() as Map<String, dynamic>?;

                              var price = data?['price'];
                              // Provide a default value

                              return Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black87,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        documents[index].id,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        price.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w200,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 39),
                child: Text("TRENDING",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 370,
                height: 150,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 200,
                          height: 130,
                          child: Image.network(
                            'https://i5.walmartimages.com/asr/d3796860-f948-4ea7-b7f4-21278fca7707_1.4408abdaf1d43a866308fcc1d24503f8.jpeg',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SHELL',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 7),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.orange,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.orange,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.orange,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.orange,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.orange,
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TrendingPumpsScreen(),
                                ),
                              );
                              // Add your "See More" button functionality here
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors
                                  .orange, // Set the button color to orange
                            ),
                            child: Text(
                              'See More',
                              style: TextStyle(
                                color: Colors
                                    .white, // Set the button text color to white
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: _loggingOut
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            )
          : null,
    );
  }
}
