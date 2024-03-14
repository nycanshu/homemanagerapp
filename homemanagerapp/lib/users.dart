import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homemanagerapp/main.dart';
import 'package:homemanagerapp/paths.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  // List<UserModel> users = [];

  void toggleUserActivation(int index) {
    setState(() {
      users[index].isActive = !users[index].isActive;
    });
  }

  List users = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUsers();
  }

  void fetchUsers() async {
    //fetch secondary users from the database
    FirebaseFirestore.instance
        .collection('devices')
        .doc(deviceId)
        .collection("secondary_users")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        final userslist = [];
        userslist.add({
          'nickname': element.data()['nickname'],
          'user_id': element.data()['user_id']
        });
        setState(() {
          users = userslist;
        });
      });
    });
  }

  Stream<QuerySnapshot> fetchUsersAsStream() {
    return FirebaseFirestore.instance
        .collection('devices')
        .doc(deviceId)
        .collection("secondary_users")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alarmas',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Administra tus alarmas para tener más control de tu instalación',
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  StreamBuilder(
                      stream: fetchUsersAsStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }
                        if (!snapshot.hasData) {
                          return Center(child: Text('No data found'));
                        }
                        users = snapshot.data!.docs;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: users.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(users[index]['nickname']),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _showAddUserDialog(context);
              },
              child: const Text('Add User'),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    TextEditingController _nicknameController = TextEditingController();
    TextEditingController _emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add User'),
          content: Column(
            children: [
              TextField(
                controller: _nicknameController,
                decoration: const InputDecoration(hintText: "nickname"),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(hintText: "user's email"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('ADD'),
              onPressed: () {
                addUser(_nicknameController.text, _emailController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void addUser(String nickname, String email) async {
    try {
      // Add the document to the collection
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('devices')
          .doc(deviceId)
          .collection("secondary_users")
          .doc(); // Get a reference to a new document (without specifying an ID)

      // Retrieve the auto-generated document ID
      final id = docRef.id;

      // Store the document ID along with other fields
      await docRef.set({
        'nickname': nickname,
        'user_id': email,
        'doc_id': id, // Store the document ID in the document
      });

      print('Document added with ID: $id');
    } catch (e) {
      print('Error adding document: $e');
    }
  }
}

class UserModel {
  String name;
  bool isActive;

  UserModel({required this.name, required this.isActive});
}
