import 'dart:html';
import 'dart:js_util';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clientsstage/ui/profile.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'add.dart';
import 'accueil.dart';
import 'my_drawer_header.dart';

import 'profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final String email;
  final String userName;
  String address;
  String password;
  String userid;
  HomePage(
      {required this.email,
      required this.userName,
      required this.address,
      required this.password,
      required this.userid});
  @override
  _HomePageState createState() => _HomePageState(
      email: email,
      userName: userName,
      address: address,
      password: password,
      userid: userid);
}

class _HomePageState extends State<HomePage> {
  final String email;
  final String userName;
  String address;
  String password;
  String userid;
  _HomePageState(
      {required this.email,
      required this.userName,
      required this.address,
      required this.password,
      required this.userid});
  var currentPage = DrawerSections.dashboard;
  bool isAuth = true;
  @override
  void initState() {
    super.initState();
    check(isAuth);
  }

  Future<bool> check(bool isAuth) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('email');
    var tok = localStorage.getString('password');
    if ((token != null) && (tok != null) && (isAuth == true)) {
      setState(() {
        isAuth = true;
      });
      return isAuth;
    } else if (isAuth == false) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('email');
      localStorage.remove('password');
      return false;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    var container;

    if (isAuth) {
      if (currentPage == DrawerSections.dashboard) {
        container = acc();
      } else if (currentPage == DrawerSections.contacts) {
        container = add();
      } else if (currentPage == DrawerSections.profile) {
        container = ProfilePage(
          email: email,
          userName: userName,
          address: address,
          password: password,
          userid: userid,
        );
      }

      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(157, 54, 26, 216),
          title: const Text("Customer Management"),
        ),
        body: container, // Use the chosen container here
        drawer: Drawer(
          child: SingleChildScrollView(
            child: Column(
              children: [
                MyHeaderDrawer(),
                MyDrawerList(),
              ],
            ),
          ),
        ),
      );
    } else {
      child = Login();
      return Scaffold(
        body: child, // Use the Login widget when not authenticated
      );
    }
  }

  Widget MyDrawerList() {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        children: [
          menuItem(1, "Home", Icons.dashboard_outlined,
              currentPage == DrawerSections.dashboard),
          menuItem(2, "Profile", Icons.logout_outlined,
              currentPage == DrawerSections.profile),
          menuItem(3, "Add Client", Icons.people_alt_outlined,
              currentPage == DrawerSections.contacts),
          menuItem(4, "logout", Icons.logout_outlined,
              currentPage == DrawerSections.logout),
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.dashboard;
            } else if (id == 3) {
              currentPage = DrawerSections.contacts;
            } else if (id == 2) {
              currentPage = DrawerSections.profile;
            } else if (id == 4) {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Logout"),
                    content: const Text("Are you sure you want to logout?"),
                    actions: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          bool a = false;
                          a = await check(a);
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ),
                            (route) => false,
                          );
                        },
                        icon: const Icon(
                          Icons.done,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum DrawerSections {
  dashboard,
  contacts,
  events,
  logout,
  settings,
  notifications,
  profile,
  send_feedback,
  add,
}
