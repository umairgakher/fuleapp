// ignore_for_file: deprecated_member_use, prefer_const_constructors

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
  double cast = 0;
  String? fuelType;

  @override
  void initState() {
    userId = user!.uid;
    print("${OrderController().fuelType}");
    fuelType = OrderController().fuelType;
    getTotalCost(); // Call getTotalCost here to calculate and update the cost.

    super.initState();
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

  void getTotalCost() {
    FirebaseFirestore.instance
        .collection('rate')
        .doc(fuelType)
        .get()
        .then((snapshot) {
      var data = snapshot.data();
      if (data != null) {
        setState(() {
          cast = OrderController().quantity! * data['price'] as double;
        });
      }
    });
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
                      ' Liters: ${OrderController().quantity}.00',
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
                      '${cast.toStringAsFixed(2)}',
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
                  onPressed: cast > 0
                      ? () {
                          FirebaseFirestore.instance
                              .collection('orders')
                              .doc("$userId")
                              .set({
                            "carNo": OrderController().carno,
                            "address": OrderController().address,
                            "quantity": OrderController().quantity,
                            "phoneNo": OrderController().phoneno,
                            "fuleType": OrderController().fuelType,
                            "Total": cast,
                            "orderstate": 0,
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
                    primary: cast > 0 ? Colors.orange : Colors.grey,
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
