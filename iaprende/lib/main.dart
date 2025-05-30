import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iaprende/chat.page.dart';
import 'package:iaprende/email_login_page.dart';
import 'package:iaprende/register_page.dart';
import 'login_screen.dart';

const firebaseConfig = FirebaseOptions(
  apiKey: "AIzaSyCFA3Uxf-HBKj6t8UmD_pLcX_RH3eRRYRo  ", 
  appId: "1:1079924366614:web:b03cad92c1f7ac97bdc437", 
  messagingSenderId: "1079924366614", 
  projectId: "aprendaia-b64fd",
  authDomain: "aprendaia-b64fd.firebaseapp.com",
  storageBucket: "aprendaia-b64fd.firebasestorage.app",
  measurementId: "G-KVTFSY9E8W"
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseConfig);
  runApp(IAprendeApp());
}

class IAprendeApp extends StatelessWidget {

  final FirebaseAuth _auth = FirebaseAuth.instance;  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Estudos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),

      routes: {
        "/login":(context) => LoginScreen(),
        "/register":(context) => RegisterPage(),
        "/emaillogin":(context) => EmailLogin(),
        "/chat":(context) => ChatPage()
      },
      initialRoute: _auth.currentUser == null ? "login" : "chat",
    );
  }

}