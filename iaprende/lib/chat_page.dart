
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
        actions: [
          IconButton(
           onPressed: () => Navigator.pushReplacementNamed(context, "/login"),
           icon: Icon(Icons.logout),
           ),
        ],
        ),
      body: Column(
        children: [
          Flexible(
            child: ListView(
              children: [
                ListTile( 
                  leading: CircleAvatar(),
                  title: Text("AAAAAA"),
                  subtitle: Text("mensagem....."),
                  trailing: Text("10/05"),
                ),
              ],
            ),
            ),
          Container(
            padding: EdgeInsets.all(10),
            height: 80,
            child: Row(
              spacing: 10,
              children: [
              ],
            ),
          ),
        ],
      ),
    );
  }
}