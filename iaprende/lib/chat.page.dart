import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  var scafoldKey = GlobalKey();  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  Future<void> _logout(BuildContext context) async{
    try{
        await _auth.signOut();
        await _googleSignIn.signOut();
        Navigator.popAndPushNamed(context, '/login');        
    }
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao sair da conta, tente novamente: ${e.toString()}")
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F2D0),
      appBar: AppBar(
        shadowColor: Colors.black,
        elevation: 6.0,
        title: Text("IAprende", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xFF007DA6),
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(), 
              icon: Icon(
                Icons.list, 
                color: Colors.white
              )
            );
          }
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
                  PopupMenuItem(child: Text("Sair"), onTap: () => _logout(context)),
                ],
          ),
        ],
      ),
       drawer: Drawer(
        child: Text('create drawer widget tree here'),

      ),
      body: Column(
        children: [
          Flexible(child: ListView(children: [
              ListTile( 
                  leading: CircleAvatar(),
                  title: Text("ESTRANGULADOR FATECANO"),
                  subtitle: Text("vem aqui na fatec....."),
                  trailing: Text("10/05"),
                ),
              ],
            )),
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
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
                          borderSide: BorderSide(color: Color(0xFFF5F2D0)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF007DA6),
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
