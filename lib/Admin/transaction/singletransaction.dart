// ignore_for_file: prefer_const_constructors, avoid_print, avoid_function_literals_in_foreach_calls, prefer_final_fields, library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ImageData {
  String imageUrl;
  DateTime time;

  ImageData(this.imageUrl, this.time);
}

class TransactionDetailsScreen extends StatefulWidget {
  final String userId;

  TransactionDetailsScreen({required this.userId});

  @override
  _TransactionDetailsScreenState createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  List<ImageData> _imageDataList = [];

  Future<void> _fetchImageData(String userId) async {
    CollectionReference transactions =
        FirebaseFirestore.instance.collection('transactions');
    DocumentReference transactionDoc = transactions.doc(userId);

    QuerySnapshot imagesSnapshot = await transactionDoc
        .collection('images')
        .orderBy('time', descending: true)
        .get();

    print("hello ali1");

    imagesSnapshot.docs.forEach((imageDoc) {
      if (imageDoc['imageUrl'] != null && imageDoc['time'] != null) {
        String imageUrl = imageDoc['imageUrl'];
        Timestamp timestamp = imageDoc['time'];
        DateTime time = timestamp.toDate();

        print("Image URL: $imageUrl");
        print("Time: $time");

        _imageDataList.add(ImageData(imageUrl, time));
      } else {
        print("Image document is missing 'imageUrl' or 'time' fields.");
      }
    });

    setState(() {});
  }

  Widget _buildImageList() {
    return ListView.builder(
      itemCount: _imageDataList.length,
      itemBuilder: (context, index) {
        ImageData imageData = _imageDataList[index];
        return Card(
          margin: EdgeInsets.all(8.0),
          child: ListTile(
            title: Image.network(imageData.imageUrl),
            subtitle: Text('Time: ${imageData.time}'),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchImageData(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transactions',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: _buildImageList(),
            ),
          ],
        ),
      ),
    );
  }
}
