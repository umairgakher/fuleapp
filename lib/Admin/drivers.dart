import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Driver extends StatefulWidget {
  const Driver({Key? key});

  @override
  State<Driver> createState() => _DriverState();
}

class _DriverState extends State<Driver> {
  late List<Map<String, dynamic>> Driver = [];
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
        Driver = querySnapshot.docs
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
        filteredUsers = List.from(Driver);
      } else {
        filteredUsers = Driver.where((user) {
          final String name = user['username'].toString().toLowerCase();
          final String email = user['email'].toString().toLowerCase();

          return name.contains(query.toLowerCase()) ||
              email.contains(query.toLowerCase());
        }).toList();
      }

      final int? currentUserCheckuser = checkuser;

      // Customize these conditions to filter based on your needs
      if (currentUserCheckuser == 0) {
        // Display users with checkuser value 0
        filteredUsers =
            filteredUsers.where((user) => user['checkuser'] == 0).toList();
      } else if (currentUserCheckuser == 2) {
        // Display users with checkuser value 2
        filteredUsers =
            filteredUsers.where((user) => user['checkuser'] == 2).toList();
      } else if (currentUserCheckuser == 1) {
        // Display users with checkuser value 1
        filteredUsers =
            filteredUsers.where((user) => user['checkuser'] == 2).toList();
      }
      // Add more conditions as needed.
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
                  var userCheckuser = user["checkuser"] as int;

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
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        userCheckuser == 0
                                            ? "User"
                                            : userCheckuser == 1
                                                ? "Employee"
                                                : "Driver",
                                        style: TextStyle(color: Colors.white),
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
