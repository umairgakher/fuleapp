// ignore_for_file: camel_case_types, use_key_in_widget_constructors, prefer_const_constructors, avoid_unnecessary_containers, sort_child_properties_last, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class allUsers extends StatefulWidget {
  const allUsers({Key? key});

  @override
  State<allUsers> createState() => _allUsersState();
}

class _allUsersState extends State<allUsers> {
  late List<Map<String, dynamic>> allUsers = [];
  late List<Map<String, dynamic>> filteredUsers = [];
  String? username;
  String? email;
  String? userId;
  String? phone;
  int? checkuser;
  User user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    userId = user.uid;
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    await fetchUserCheckuser(user.uid);
    final querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .orderBy("username")
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        allUsers = querySnapshot.docs
            // ignore: unnecessary_cast
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        filterUsers(''); // Apply initial filter to show all users
      });
    }
  }

  Future<void> fetchUserCheckuser(String userId) async {
    final docSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      setState(() {
        checkuser = data?["checkuser"];
      });
    }
  }

  void filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        // If the search query is empty, show all users
        filteredUsers = List.from(allUsers);
      } else {
        filteredUsers = allUsers.where((user) {
          final String name = user['username'].toString().toLowerCase();
          final String email = user['email'].toString().toLowerCase();

          return name.contains(query.toLowerCase()) ||
              email.contains(query.toLowerCase());
        }).toList();
      }

      final int? currentUserCheckuser = checkuser;

      if (currentUserCheckuser == 0) {
        // Display users with checkuser value 0
        filteredUsers =
            filteredUsers.where((user) => user['checkuser'] == 0).toList();
      } else if (currentUserCheckuser == 2) {
        // Exclude admin users and users with checkuser value 1
        filteredUsers = filteredUsers
            .where((user) => user['checkuser'] != 1 && user['checkuser'] != 2)
            .toList();
      }
      // Show users with checkuser value 1 when currentUserCheckuser is 1
      else if (currentUserCheckuser == 1) {
        filteredUsers =
            filteredUsers.where((user) => user['checkuser'] != 1).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Users",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                onChanged: filterUsers,
                decoration: InputDecoration(
                  hintText: 'Search by name or email',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (BuildContext context, int index) {
                  final Map<String, dynamic> user = filteredUsers[index];
                  username = user['username'];
                  email = user['email'];
                  userId = user['userId'];
                  phone = user["uPhone"];
                  var warden = user["checkuser"] as int;

                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
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
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "  Name:$username",
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
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Email: $email"),
                                  Text("Contact: $phone"),
                                  warden == 0
                                      ? ElevatedButton(
                                          onPressed: () {},
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "User",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.orange,
                                          ),
                                        )
                                      : ElevatedButton(
                                          onPressed: () {},
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Driver",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.orange,
                                          ),
                                        )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
