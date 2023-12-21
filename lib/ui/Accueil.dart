import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'modify.dart';
import 'login.dart';
import 'checkauth.dart';

class acc extends StatefulWidget {
  const acc({Key? key});

  @override
  State<acc> createState() => _accState();
}

class _accState extends State<acc> {
  bool isAuth = false;
  @override
  void initState() {
    super.initState();
    check();
  }

  Future<bool> check() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('email');
    var tok = localStorage.getString('password');
    if ((token != null) && (tok != null)) {
      setState(() {
        isAuth = true;
      });
      return true;
    } else {
      return false;
    }
  }

  final Stream<QuerySnapshot> studentsStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  // For Deleting User
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<void> deleteUser(id) async {
    try {
      await users.doc(id).delete();
      print('User Deleted');
    } catch (error) {
      print('Failed to Delete user: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (isAuth) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'User List', // Your title here
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: studentsStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                print('Something went Wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final List storedocs = [];
              snapshot.data!.docs.forEach((document) {
                Map<String, dynamic> a =
                    document.data() as Map<String, dynamic>;
                a['id'] = document.id;
                storedocs.add(a);
              });

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Table(
                    border: TableBorder.all(),
                    columnWidths: const <int, TableColumnWidth>{
                      1: FixedColumnWidth(140),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                            child: Container(
                              color: Color.fromARGB(255, 81, 95, 216),
                              child: Center(
                                child: Text(
                                  'Name',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              color: Color.fromARGB(255, 81, 95, 216),
                              child: Center(
                                child: Text(
                                  'Email',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              color: Color.fromARGB(255, 81, 95, 216),
                              child: Center(
                                child: Text(
                                  'Action',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      for (var i = 0; i < storedocs.length; i++) ...[
                        TableRow(
                          children: [
                            TableCell(
                              child: Center(
                                child: Text(
                                  storedocs[i]['name'],
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Center(
                                child: Text(
                                  storedocs[i]['email'],
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            modify(id: storedocs[i]['id']),
                                      ),
                                    ),
                                    icon: Icon(
                                      Icons.edit,
                                      color: Color.fromARGB(255, 117, 28, 117),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text("Delete User"),
                                            content: const Text(
                                                "Are you sure you want to delete this user?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  await deleteUser(
                                                      storedocs[i]['id']);
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          )
        ],
      );
    } else {
      return Login();
    }
  }
}
