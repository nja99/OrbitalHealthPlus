import 'package:flutter/material.dart';
import 'pages/loginpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealthSPHERE',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }

}