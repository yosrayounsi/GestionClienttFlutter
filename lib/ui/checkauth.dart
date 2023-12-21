import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'login.dart';

class CheckAuth extends StatefulWidget {
  final String email;
  final String userName;
  String address;
  String password;
  String userid;
  CheckAuth(
      {required this.email,
      required this.userName,
      required this.address,
      required this.password,
      required this.userid});

  @override
  _CheckAuthState createState() => _CheckAuthState(
      email: email,
      userName: userName,
      address: address,
      password: password,
      userid: userid);
}

class _CheckAuthState extends State<CheckAuth> {
  final String email;
  final String userName;
  String address;
  String password;
  String userid;
  _CheckAuthState(
      {required this.email,
      required this.userName,
      required this.address,
      required this.password,
      required this.userid});
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

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (isAuth) {
      child = HomePage(
        email: email,
        userName: userName,
        address: address,
        password: password,
        userid: userid,
      );
    } else {
      child = Login();
    }
    return Scaffold(
      body: child,
    );
  }
}
