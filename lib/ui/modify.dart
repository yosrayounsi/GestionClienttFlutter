import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class modify extends StatefulWidget {
  final String id;
  const modify({Key? key, required this.id}) : super(key: key);

  @override
  State<modify> createState() => _modifyState();
}

class _modifyState extends State<modify> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
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

  Future<void> updateUser(id, name, email, address, number, status) {
    return users
        .doc(id)
        .update({
          'name': name,
          'email': email,
          'address': address,
          'number': number,
          'status': status
        })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodeadress = FocusNode();
  final FocusNode _focusNodenumber = FocusNode();
  final FocusNode _focusNodestatus = FocusNode();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controlleradresse = TextEditingController();
  final TextEditingController _controllernumber = TextEditingController();
  final TextEditingController _controllerstatus = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (isAuth) {
      return Scaffold(
        backgroundColor: Color.fromARGB(0, 245, 240, 247),
        body: Form(
            key: _formKey,
            child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.id)
                  .get(),
              builder: (_, snapshot) {
                if (snapshot.hasError) {
                  print('Something Went Wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var data = snapshot.data!.data();
                var name = data!['name'];
                var email = data['email'];
                var address = data['address'];
                var number = data['number'];
                var status = data['status'];
                return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                    child: ListView(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Image.asset('images/protechlogo.png',
                                    height: 200, width: 200),
                                const SizedBox(height: 1),
                                Text(
                                  "Modify Client",
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                ),
                                const SizedBox(height: 30),
                                TextFormField(
                                  initialValue: name,
                                  autofocus: false,
                                  onChanged: (value) => name = value,
                                  decoration: InputDecoration(
                                    labelText: "Username",
                                    prefixIcon:
                                        const Icon(Icons.person_outlined),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter username.";
                                    }

                                    return null;
                                  },
                                  onEditingComplete: () =>
                                      _focusNodeEmail.requestFocus(),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  initialValue: email,
                                  autofocus: false,
                                  onChanged: (value) => email = value,
                                  decoration: InputDecoration(
                                    labelText: "Email",
                                    prefixIcon:
                                        const Icon(Icons.email_outlined),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter email.";
                                    } else if (!(value.contains('@') &&
                                        value.contains('.'))) {
                                      return "Invalid email";
                                    }
                                    return null;
                                  },
                                  onEditingComplete: () =>
                                      _focusNodeadress.requestFocus(),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  initialValue: address,
                                  autofocus: false,
                                  onChanged: (value) => address = value,
                                  decoration: InputDecoration(
                                    labelText: "Adress",
                                    prefixIcon:
                                        const Icon(Icons.streetview_outlined),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter adress.";
                                    } else if (value.contains(' ')) {
                                      return "Invalid adress";
                                    }
                                    return null;
                                  },
                                  onEditingComplete: () =>
                                      _focusNodenumber.requestFocus(),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  initialValue: number,
                                  autofocus: false,
                                  onChanged: (value) => number = value,
                                  decoration: InputDecoration(
                                    labelText: "Number",
                                    prefixIcon:
                                        const Icon(Icons.numbers_outlined),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter number.";
                                    } else if (value.length < 8) {
                                      return "number must be at least 8 character.";
                                    }
                                    return null;
                                  },
                                  onEditingComplete: () =>
                                      _focusNodestatus.requestFocus(),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  initialValue: status,
                                  autofocus: false,
                                  onChanged: (value) => status = value,
                                  decoration: InputDecoration(
                                    labelText: "Status",
                                    prefixIcon: const Icon(Icons.contact_page),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter status.";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                Column(
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size.fromHeight(50),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      onPressed: () {
                                        // Validate returns true if the form is valid, otherwise false.
                                        if (_formKey.currentState!.validate()) {
                                          updateUser(widget.id, name, email,
                                              address, number, status);
                                          Navigator.pop(context);
                                        }

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            width: 200,
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            content: const Text(
                                                "modified Successfully"),
                                          ),
                                        );

                                        _formKey.currentState?.reset();
                                      },
                                      child: const Text("modify"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ));
              },
            )),
      );
    } else {
      return Login();
    }
  }

  @override
  void dispose() {
    _focusNodeEmail.dispose();
    _focusNodeadress.dispose();
    _focusNodenumber.dispose();
    _focusNodestatus.dispose();
    _controllerUsername.dispose();
    _controllerEmail.dispose();
    _controlleradresse.dispose();
    _controllernumber.dispose();
    _controllerstatus.dispose();
    super.dispose();
  }
}
