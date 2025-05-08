import 'package:flutter/material.dart';
import 'package:iaprende/register_page.dart';
import 'login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Estudos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginScreen(),

      routes: {
        "/login":(context) => LoginScreen(),
        "/register":(context) => RegisterPage(),
      },
    );
  }
}