import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iaprende/chat.page.dart';
import 'package:iaprende/email_login_page.dart';
import 'package:iaprende/register_page.dart';
import 'login_screen.dart';

const firebaseConfig = FirebaseOptions(
  apiKey: "AIzaSyAKCRtA68L8fssto3g4HHWl4atZrDND4bI", 
  appId: "1:890617491537:web:721f886c66397ae7e00870", 
  messagingSenderId: "890617491537", 
  projectId: "iaprende-f6cf0",
  authDomain: "iaprende-f6cf0.firebaseapp.com",
  storageBucket: "iaprende-f6cf0.firebasestorage.app"
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
      home: const LoginScreen(),

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