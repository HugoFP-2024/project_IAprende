import 'package:flutter/material.dart';

class IAprendeApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/login":(context) => LoginPage(), 
        "/chat":(context) => ChatPage(),
      },
      initialRoute: "/login",
    );
  }
}

