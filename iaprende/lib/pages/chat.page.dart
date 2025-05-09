import 'dart:math';

import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F2D0),
      appBar: AppBar(
        title: Text("IAprende", style: TextStyle(color: Colors.white)),
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
                  PopupMenuItem(child: Text("Configurações")),
                  PopupMenuItem(child: Text("Sair")),
                ],
          ),
        ],
      ),
      body: Column(
        children: [
          Flexible(child: ListView(children: [

              ],
            )),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF007DA6),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 6.0,
                  spreadRadius: 0.0,
                  offset: Offset(0, -1),
                ),
              ],
            ),

            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                IconButton(
                  onPressed: null,
                  icon: Icon(Icons.add, color: Color(0xFFF5F2D0)),
                ),
                Expanded(
                  child: Container(
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.send, color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFF5F2D0),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: 'Vamos aprender algo?',
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: 'Exemplo: Me diga sobre astrofísica',
                        hintStyle: TextStyle(color: Colors.grey[200]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
