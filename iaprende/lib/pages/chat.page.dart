import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: null, 
          icon: Icon(Icons.menu, color: Colors.white,)
        ),
        actions: [
          IconButton(
            onPressed: null, 
            icon: Icon(Icons.account_circle, color: Colors.white,)
          )
        ],
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView(
              children: [

              ],
            )
          ),
            Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                IconButton(
                  onPressed: null,
                  icon: Icon(Icons.add, color: Colors.white,)
                  ),
                Expanded(
                  child: Container(
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.menu_book, color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color:Color.fromARGB(255, 0, 125, 166), width: 2.0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: 'Vamos aprender algo?',
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: 'Exemplo: Me diga sobre astrofísica',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ],
            )
          )
        ])
      )
    ;
  }
}
