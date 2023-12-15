// ignore_for_file: prefer_const_constructors, unnecessary_cast, use_key_in_widget_constructors

import 'package:app/Admin/transaction/singletransaction.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TransactionsScreen(),
    );
  }
}

class TransactionsScreen extends StatelessWidget {
  // Fetch function as you provided
  // Future<void> _fetchAllTransactionData() async {
  //   CollectionReference transactions =
  //       FirebaseFirestore.instance.collection('transactions');

  //   try {
  //     QuerySnapshot transactionsSnapshot = await transactions.get();

  //     transactionsSnapshot.docs.forEach((transactionDoc) {
  //       String userId = transactionDoc['userId'];
  //       int month = transactionDoc['doc']['month'];
  //       String username = transactionDoc['doc']['username'];

  //       // // Display details
  //       // print('User ID: $userId');
  //       // print('Month: $month');
  //       // print('Username: $username');
  //       // print('------------------');
  //     });
  //   } catch (e) {
  //     print('Error fetching transactions: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All user transactions",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('transactions').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var transactions = snapshot.data!.docs;

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              var transaction =
                  transactions[index].data() as Map<String, dynamic>;

              return Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Color.fromARGB(26, 47, 144, 223),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  shadowColor:
                      Color.fromARGB(255, 198, 231, 235).withOpacity(0.5),
                  elevation: 5,
                  child: ListTile(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TransactionDetailsScreen(
                                    userId: "${transaction['userId']}",
                                  )))
                    },
                    leading: Container(
                      width: 50,
                      alignment: Alignment.topLeft,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.grey,
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                      ),
                      child: Text(
                        ' ${transaction['doc']['username']}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    subtitle: Padding(
                      padding:
                          const EdgeInsets.only(left: 5, bottom: 8.0, top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Username:${transaction['doc']['username']}'),
                          Text('Email:${transaction['doc']['email']}'),
                        ],
                      ),
                    ),
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
