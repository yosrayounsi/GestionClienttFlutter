import 'package:clientsstage/ui/login.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'accueil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class add extends StatefulWidget {
  const add({super.key});

  @override
  State<add> createState() => _addState();
}

class _addState extends State<add> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String name = '';
  String email = '';
  String address = '';
  String number = '';
  String status = '';
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodeadress = FocusNode();
  final FocusNode _focusNodenumber = FocusNode();
  final FocusNode _focusNodestatus = FocusNode();
  final _controllerUsername = TextEditingController();
  final _controllerEmail = TextEditingController();
  final _controlleradresse = TextEditingController();
  final _controllernumber = TextEditingController();
  final _controllerstatus = TextEditingController();
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

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<void> addUser() {
    return users
        .add({
          'name': name,
          'email': email,
          'address': address,
          'number': number,
          'status': status
        })
        .then((value) => print('user added'))
        .catchError((error) => print('failed to add user: $error'));
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (isAuth) {
      return Scaffold(
        backgroundColor: Color.fromARGB(0, 245, 240, 247),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: <Widget>[
                Image.asset('images/protechlogo.png', height: 200, width: 200),
                const SizedBox(height: 1),
                Text(
                  "Add Client",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _controllerUsername,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: "Username",
                    prefixIcon: const Icon(Icons.person_outlined),
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
                  onEditingComplete: () => _focusNodeEmail.requestFocus(),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _controllerEmail,
                  focusNode: _focusNodeEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.email_outlined),
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
                    } else if (!(value.contains('@') && value.contains('.'))) {
                      return "Invalid email";
                    }
                    return null;
                  },
                  onEditingComplete: () => _focusNodeadress.requestFocus(),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _controlleradresse,
                  focusNode: _focusNodeadress,
                  keyboardType: TextInputType.streetAddress,
                  decoration: InputDecoration(
                    labelText: "Adress",
                    prefixIcon: const Icon(Icons.streetview_outlined),
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
                  onEditingComplete: () => _focusNodenumber.requestFocus(),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _controllernumber,
                  focusNode: _focusNodenumber,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Number",
                    prefixIcon: const Icon(Icons.numbers_outlined),
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
                  onEditingComplete: () => _focusNodestatus.requestFocus(),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _controllerstatus,
                  focusNode: _focusNodestatus,
                  keyboardType: TextInputType.text,
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
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            name = _controllerUsername.text;
                            email = _controllerEmail.text;
                            address = _controlleradresse.text;
                            number = _controllernumber.text;
                            status = _controllerstatus.text;
                            addUser();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                width: 200,
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                behavior: SnackBarBehavior.floating,
                                content: const Text("added Successfully"),
                              ),
                            );
                          });
                        }

                        _formKey.currentState?.reset();
                      },
                      child: const Text("add"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
