import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'signup.dart';
import 'checkauth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({
    Key? key,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  CollectionReference usersregistred =
      FirebaseFirestore.instance.collection('usersregistred');
  final FocusNode _focusNodePassword = FocusNode();
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              Image.asset('images/protechlogo.png', height: 200, width: 200),
              const SizedBox(height: 3),
              Text(
                "Welcome back",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 10),
              Text(
                "Login to your account",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 60),
              TextFormField(
                controller: _emailcontroller,
                keyboardType: TextInputType.name,
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
                onEditingComplete: () => _focusNodePassword.requestFocus(),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter Email.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordcontroller,
                focusNode: _focusNodePassword,
                obscureText: _obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.password_outlined),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: _obscurePassword
                          ? const Icon(Icons.visibility_outlined)
                          : const Icon(Icons.visibility_off_outlined)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter password.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 60),
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
                        sign(_emailcontroller.text, _passwordcontroller.text);
                      }
                    },
                    child: const Text("Login"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          _formKey.currentState?.reset();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const Signup();
                              },
                            ),
                          );
                        },
                        child: const Text("Signup"),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> usss(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('usersregistred')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.size > 0) {
        var doc = querySnapshot
            .docs.first; // Assuming there's only one matching document
        var name = doc['name'];
        print('Nom trouvé : $name');
        return name;
      } else {
        print('Aucun utilisateur avec cet email trouvé.');
        return 'Utilisateur inconnu';
      }
    } catch (error) {
      print('Erreur lors de la récupération des données : $error');
      return 'Utilisateur inconnu';
    }
  }

  Future<String> address(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('usersregistred')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.size > 0) {
        var doc = querySnapshot
            .docs.first; // Assuming there's only one matching document
        var address = doc['address'];
        print('Nom trouvé : $address');
        return address;
      } else {
        print('Aucun utilisateur avec cet email trouvé.');
        return 'Utilisateur inconnu';
      }
    } catch (error) {
      print('Erreur lors de la récupération des données : $error');
      return 'Utilisateur inconnu';
    }
  }

  Future<String> userid(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('usersregistred')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.size > 0) {
        var doc = querySnapshot.docs.first;
        var id = doc.id; // Accessing the document ID
        print('User document ID found: $id');
        return id;
      } else {
        print('No user with this email found.');
        return 'Unknown user';
      }
    } catch (error) {
      print('Error retrieving data: $error');
      return 'Unknown user';
    }
  }

  Future<String> pas(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('usersregistred')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.size > 0) {
        var doc = querySnapshot
            .docs.first; // Assuming there's only one matching document
        var number = doc['password'];
        print('Nom trouvé : $number');
        return number;
      } else {
        print('Aucun utilisateur avec cet email trouvé.');
        return 'Utilisateur inconnu';
      }
    } catch (error) {
      print('Erreur lors de la récupération des données : $error');
      return 'Utilisateur inconnu';
    }
  }

  void sign(String email, String password) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    if (_formKey.currentState!.validate()) {
      try {
        localStorage.setString('email', email);
        localStorage.setString('password', password);
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        String userName = await usss(email);
        String ad = await address(email);
        String n = await pas(email);
        String idd = await userid(email);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CheckAuth(
              email: email,
              userName: userName,
              address: ad,
              password: n,
              userid: idd,
            ),
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }
  }

  @override
  void dispose() {
    _focusNodePassword.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
  }
}
