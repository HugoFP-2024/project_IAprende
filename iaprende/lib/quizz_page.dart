import 'package:flutter/material.dart';

class QuizzPage extends StatefulWidget {
  @override
  State<QuizzPage> createState() => _QuizzPageState();
}

class _QuizzPageState extends State<QuizzPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F2D0),
      appBar: AppBar(
        shadowColor: Colors.black,
        elevation: 6.0,
        title: Text("Quizz", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xFF007DA6),
        leading: IconButton(
          onPressed: null,
          icon: Icon(Icons.menu, color: Colors.white),
        ),
        actions: [
          PopupMenuButton(
            tooltip: 'Menu',
            icon: Icon(Icons.house, color: Colors.white),
            borderRadius: BorderRadius.circular(20),
            popUpAnimationStyle: AnimationStyle(
              curve: Easing.emphasizedAccelerate,
              duration: Duration(milliseconds: 800),
            ),
            itemBuilder:
                (context) => [
                  PopupMenuItem(child: ListTile(leading: Icon(Icons.settings), title: Text('Configurações'),),),
                  PopupMenuItem(child:  ListTile(leading: Icon(Icons.logout), title: Text('Sair'),), onTap: ()=> Navigator.pushReplacementNamed(context, '/login'),),
                ],
          ),
        ],
      ),
    );
  }
}