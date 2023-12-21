import 'package:clientsstage/ui/add.dart';
import 'package:flutter/material.dart';

import 'ui/login.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(157, 54, 26, 216),
        ),
      ),
      home: const add(),
    );
  }
}
