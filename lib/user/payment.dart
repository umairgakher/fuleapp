// ignore_for_file: deprecated_member_use, prefer_const_constructors, unused_local_variable, camel_case_types, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, unnecessary_string_interpolations, prefer_const_constructors_in_immutables, avoid_unnecessary_containers, sized_box_for_whitespace, unnecessary_cast

import 'package:app/user/location_controller.dart';
import 'package:app/user/order_controller.dart';
import 'package:app/user/success.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Paymet_next extends StatefulWidget {
  final String fuelType;
  final double fuelAmount;

  Paymet_next({
    required this.fuelType,
    required this.fuelAmount,
  });

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<Paymet_next> {
  bool isCashOnDeliverySelected = true;
  bool isEasypaisaSelected = false;
  User? user = FirebaseAuth.instance.currentUser;
  String? userId;
  int? cast = 0;
  String? fuelType;
  int? quantity;
  int? price;
  String? username;

  @override
  void initState() {
    super.initState();
    userId = user!.uid;
    fuelType = OrderController().fuelType;
    quantity = OrderController().quantity;
    fetchDataFromFirestore();

    // Retrieve user data from Firestore and set it to `username` and `email`
    FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          username = data['username'];
        });
      }
    }).catchError((error) {
      print("Error fetching user data: $error");
    });
    super.initState();

    // Fetch employee data from Firestore's "salary" collection
    // _fetchEmployeeData();
  }

  Future<void> fetchDataFromFirestore() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('rate')
          .doc(fuelType)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null) {
          print("Data retrieved successfully");
          price = data['price'] as int;
          print("$price price");
          setState(() {
            cast = ((quantity ?? 0) * (price ?? 0));
          });
        }
      } else {
        print("Document does not exist.");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  String formatRequestTime(Timestamp? timestamp) {
    if (timestamp != null) {
      DateTime dateTime = timestamp.toDate();
      var date = DateFormat('yyyy-MM-dd ').format(dateTime);
      return DateFormat('HH:mm:ss').format(dateTime);
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.local_gas_station,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.fuelType,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      ' Liters: ${OrderController().quantity ?? 0}.00',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orange),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Cost:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${cast?.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 100,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Delivery Address :${LocationController().currentLocation}',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose Payment Method',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Radio(
                              value: true,
                              groupValue: isCashOnDeliverySelected,
                              onChanged: (value) {
                                setState(() {
                                  isCashOnDeliverySelected = value as bool;
                                  isEasypaisaSelected = !value;
                                });
                              },
                              activeColor: Colors.orange,
                            ),
                            title: Text('Cash on Delivery'),
                          ),
                          ListTile(
                            leading: Radio(
                              value: true,
                              groupValue: isEasypaisaSelected,
                              onChanged: (value) {
                                setState(() {
                                  isEasypaisaSelected = value as bool;
                                  isCashOnDeliverySelected = !value;
                                });
                              },
                              activeColor: Colors.orange,
                            ),
                            title: Text('Easypaisa'),
                          ),
                          if (isEasypaisaSelected)
                            Text('We are working on it to Ease your assurance'),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 40),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (cast ?? 0) > 0
                      ? () {
                          FirebaseFirestore.instance
                              .collection('orders')
                              .doc()
                              .set({
                            "carNo": OrderController().carno,
                            "address": OrderController().address,
                            "quantity": OrderController().quantity ?? 0,
                            "phoneNo": OrderController().phoneno,
                            "fuleType": OrderController().fuelType,
                            "station": OrderController().station,
                            "stationAddress": OrderController().address,
                            "orderDeliver": "",
                            "Total": cast ?? 0,
                            "orderstate": 0,
                            "name": username,
                            "userId": userId,
                            "orderTime": DateTime.now(),
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Sucess()),
                          );
                          // Proceed button functionality
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    primary: (cast ?? 0) > 0 ? Colors.orange : Colors.grey,
                  ),
                  child: Text(
                    'Proceed',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
