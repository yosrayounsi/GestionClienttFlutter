import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'editprofile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class ProfilePage extends StatefulWidget {
  final String userName;
  final String email;
  final String address;
  final String password;
  String userid;

  ProfilePage(
      {Key? key,
      required this.userName,
      required this.email,
      required this.address,
      required this.password,
      required this.userid})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState(
      email: email,
      userName: userName,
      address: address,
      password: password,
      userid: userid);
}

class _ProfilePageState extends State<ProfilePage> {
  final String email;
  final String userName;
  String address;
  String password;
  String userid;
  _ProfilePageState(
      {required this.email,
      required this.userName,
      required this.address,
      required this.password,
      required this.userid});
  late Stream<QuerySnapshot> studentsStream;
  bool isAuth = false;
  @override
  void initState() {
    super.initState();
    check();
    studentsStream =
        FirebaseFirestore.instance.collection('usersregistred').snapshots();
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

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (isAuth) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('images/user.png'),
              ),
              const SizedBox(height: 5),
              itemProfile('Name', widget.userName, CupertinoIcons.person),
              const SizedBox(height: 5),
              itemProfile('Email', widget.email, CupertinoIcons.mail),
              const SizedBox(height: 5),
              itemProfile('Address', widget.address, CupertinoIcons.location),
              const SizedBox(height: 5),
              itemProfile('Password', widget.password, CupertinoIcons.lock),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(
                          userName: widget.userName,
                          email: widget.email,
                          address: widget.address,
                          password: widget.password,
                          userid: widget.userid,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                  ),
                  child: const Text('Edit Profile'),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Login();
    }
  }

  Widget itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 5),
            color: Colors.deepOrange.withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(iconData),
        trailing: Icon(Icons.arrow_forward, color: Colors.grey.shade400),
        tileColor: Colors.white,
      ),
    );
  }
}
