import 'package:flutter/material.dart';
import 'package:iaprende/pages/chat.page.dart';

class IAprendeApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/chat":(context) => ChatPage(),
      },
      initialRoute: "/chat",
    );
  }
}

