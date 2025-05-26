import 'package:flutter/material.dart';
import 'package:iaprende/chat.page.dart';
import 'package:iaprende/email_login_page.dart';
import 'package:iaprende/quizz_page.dart';
import 'package:iaprende/register_page.dart';
import 'login_screen.dart';

void main() {
  runApp(IAprendeApp());
}

class IAprendeApp extends StatelessWidget {
  const IAprendeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Estudos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginScreen(),

      routes: {
        "/login":(context) => LoginScreen(),
        "/register":(context) => RegisterPage(),
        "/emaillogin":(context) => EmailLogin(),
        "/chat":(context) => ChatPage(),
        "/quizz":(context) => QuizzPage()
      },
      initialRoute: "/login",
    );
  }

}