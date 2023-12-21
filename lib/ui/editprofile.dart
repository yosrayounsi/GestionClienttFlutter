import 'package:clientsstage/ui/home.dart';
import 'package:clientsstage/ui/profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfilePage extends StatefulWidget {
  final String userid;
  final String userName;
  final String email;
  final String address;
  final String password;
  const EditProfilePage({
    Key? key,
    required this.userid,
    required this.userName,
    required this.email,
    required this.address,
    required this.password,
  }) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState(
      email: email,
      userName: userName,
      address: address,
      password: password,
      userid: userid);
}

class _EditProfilePageState extends State<EditProfilePage> {
  final String email;
  final String userName;
  String address;
  String password;
  String userid;
  _EditProfilePageState(
      {required this.email,
      required this.userName,
      required this.address,
      required this.password,
      required this.userid});
  final GlobalKey<FormState> _formKey = GlobalKey();
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

  CollectionReference usersregistred =
      FirebaseFirestore.instance.collection('usersregistred');

  Future<void> updateUser(userid, name, email, address, password) {
    return usersregistred
        .doc(userid)
        .update({
          'name': name,
          'email': email,
          'address': address,
          'password': password,
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

  Future<void> changeEmail(String email) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await user.updateEmail(email);

        print('Email updated successfully');
      } catch (error) {
        print('Error updating email: $error');
      }
    } else {
      print('User not signed in');
    }
  }

  Future<void> changePassword(String password) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await user.updatePassword(password);
        print('Password updated successfully');
      } catch (error) {
        print('Error updating password: $error');
      }
    } else {
      print('User not signed in');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isAuth) {
      return Scaffold(
        backgroundColor: Color.fromARGB(0, 245, 240, 247),
        body: Form(
            key: _formKey,
            child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection('usersregistred')
                  .doc(widget.userid)
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
                var password = data['password'];

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
                                  "Modify your information",
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
                                  initialValue: password,
                                  autofocus: false,
                                  onChanged: (value) => password = value,
                                  decoration: InputDecoration(
                                    labelText: "password",
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
                                      onPressed: () async {
                                        // Validate returns true if the form is valid, otherwise false.
                                        if (_formKey.currentState!.validate()) {
                                          await changeEmail(email);
                                          await changePassword(password);
                                          updateUser(widget.userid, name, email,
                                              address, password);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => HomePage(
                                                  userName: name,
                                                  email: email,
                                                  address: address,
                                                  password: password,
                                                  userid: userid),
                                            ),
                                          );
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ProfilePage(
                                                  userName: name,
                                                  email: email,
                                                  address: address,
                                                  password: password,
                                                  userid: userid),
                                            ),
                                          );
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
