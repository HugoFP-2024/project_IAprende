import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:iaprende/pages/chat_page.dart';
import 'package:iaprende/consts.dart';
import 'package:iaprende/pages/email_login_page.dart';
import 'package:iaprende/pages/quizz_page.dart';
import 'package:iaprende/pages/register_page.dart';
import "package:iaprende/pages/recover_page.dart";
import 'pages/login_page.dart';
import 'Pages/quizz_page.dart';

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
  Gemini.init(apiKey: GEMINI_API_KEY,);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseConfig);
  runApp(IAprendeApp());
}

class IAprendeApp extends StatelessWidget {

  final FirebaseAuth _auth = FirebaseAuth.instance;  

  Route<dynamic> _animatedRoute(RouteSettings settings) {
    WidgetBuilder builder;
    switch (settings.name) {
      case "/login":
        builder = (context) => LoginScreen();
        break;
      case "/register":
        builder = (context) => RegisterPage();
        break;
      case "/emaillogin":
        builder = (context) => EmailLogin();
        break;
      case "/chat":
        builder = (context) => ChatPage();
        break;
      case "/recovery":
        builder = (context) => RecoveryPage();
        break;
      default:
        builder = (context) => LoginScreen();
    }
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: 400),
      settings: settings,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Estudos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: _animatedRoute,
      initialRoute: _auth.currentUser == null ? "/login" : "/chat",
    );
  }

}