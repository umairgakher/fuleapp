// ignore_for_file: prefer_final_fields, avoid_print, prefer_const_constructors, camel_case_types, library_private_types_in_public_api, sized_box_for_whitespace, use_key_in_widget_constructors, avoid_unnecessary_containers, sort_child_properties_last, unused_field

import 'dart:async';
import 'dart:io';
import 'package:app/user/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../order_controller.dart';
import '../success.dart';

class payment_method extends StatefulWidget {
  const payment_method({Key? key}) : super(key: key);

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<payment_method> {
  bool _isLoading = false;
  int? input;
  TextEditingController paymentController = TextEditingController();
  File? _selectedImage;

  @override
  void initState() {
    print("OrderController().rent${OrderController().quantity! + 150}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment Method',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            TextField(
              controller: paymentController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter amount including delivery charges',
              ),
            ),
            SizedBox(height: 16),
            BankAccountDisplay(),
            _selectedImage != null
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: double.infinity,
                      child: Image.file(
                        _selectedImage!,
                        height: 300,
                        width: double.infinity,
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            SizedBox(height: 16),
            Center(
              child: Container(
                width: 150,
                child: ElevatedButton(
                  onPressed: _pickImage,
                  child: Text(
                    'Select Image',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Container(
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    String inputText =
                        paymentController.text; // Get the input as a string
                    input =
                        int.tryParse(inputText); // Try to parse it to an int

                    if (input != null) {
                      if (OrderController().cast == input) {
                        if (!_isLoading) {
                          // _sendPayment(OrderController().uid);
                          if (_selectedImage != null) {
                            _sendImageToDatabase(_selectedImage!);
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
                              "Total": OrderController().cast ?? 0,
                              "orderstate": 0,
                              "name": OrderController().username,
                              "userId": OrderController().userId,
                              "orderTime": DateTime.now(),
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Sucess()),
                            );
                            //
                          } else {
                            Fluttertoast.showToast(
                              msg: "Select an image first",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.orange,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            return;
                          }
                        }
                      } else {
                        Fluttertoast.showToast(
                          msg: "Enter Correct price",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.orange,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    } else {
                      Fluttertoast.showToast(
                        msg: "Invalid input. Please enter a valid number.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.orange,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          'Proceed',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendImageToDatabase(File imageFile) async {
    DateTime now = DateTime.now();
    int currentMonth = now.month;

    // Save the image to Firebase Storage
    Reference storageReference =
        FirebaseStorage.instance.ref().child('images/${DateTime.now()}.jpg');
    UploadTask uploadTask = storageReference.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

    // Get the image URL from Firebase Storage
    String imageUrl = await taskSnapshot.ref.getDownloadURL();

    // Save image data to the database
    CollectionReference transactions =
        FirebaseFirestore.instance.collection('transactions');
    DocumentReference transactionDoc =
        transactions.doc(FirebaseAuth.instance.currentUser!.uid);

    await transactionDoc.set({
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'doc': {
        'month': currentMonth,
        'username': OrderController().username,
        "email": LocationController().email,
      },
    }, SetOptions(merge: true));

    // Add image data to the 'images' subcollection
    CollectionReference imagesCollection = transactionDoc.collection('images');
    await imagesCollection.add({
      'imageUrl': imageUrl,
      'time': FieldValue.serverTimestamp(),
    });

    print('Image sent to database');
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      _showImageDialog(_selectedImage!);
    } else {
      Fluttertoast.showToast(
        msg: "No image selected",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _showImageDialog(File imageFile) {
    // Implement a dialog to show the selected image
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Image.file(
            imageFile,
            height: 200,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class AmountInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      // controller: ,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Enter amount',
      ),
    );
  }
}

class BankAccountDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // Implement your bank account display UI here
      child: Text('Easypaisa Account:03488208308'),
    );
  }
}
