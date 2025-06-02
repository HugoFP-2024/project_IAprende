import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final Gemini gemini = Gemini.instance;

  List<ChatMessage> messages = [];

  final ChatUser currentUser = ChatUser(id: "0", firstName: "Francisco");
  final ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "IAprende",
    profileImage: "images/IAprende.png",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F2D0),
      appBar: AppBar(
        shadowColor: Colors.black,
        elevation: 6.0,
        title: const Text("IAprende", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF007DA6),
        leading: IconButton(
          onPressed: null,
          icon: const Icon(Icons.menu, color: Colors.white),
        ),
        actions: [_buildPopupMenu(context)],
      ),
      body: _buildChat(),
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Menu Opções',
      icon: const Icon(Icons.more_vert, color: Colors.white),
      color: const Color(0xFFF5F2D0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      offset: const Offset(0, kToolbarHeight),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'settings',
          child: ListTile(
            leading: const Icon(Icons.settings, color: Color(0xFF007DA6)),
            title: const Text('Configurações', style: TextStyle(color: Color(0xFF333333))),
          ),
        ),
        PopupMenuItem(
          value: 'logout',
          onTap: () {
            Future.delayed(const Duration(milliseconds: 100), () {
              Navigator.pushReplacementNamed(context, '/login');
            });
          },
          child: ListTile(
            leading: const Icon(Icons.logout, color: Color(0xFF007DA6)),
            title: const Text('Sair', style: TextStyle(color: Color(0xFF333333))),
          ),
        ),
      ],
    );
  }

  Widget _buildChat() {
  return DashChat(
    currentUser: currentUser,
    onSend: _handleSend,
    messages: messages,
    inputOptions: InputOptions( 
      alwaysShowSend: true,
      cursorStyle: CursorStyle(color: Colors.black),
      inputDecoration: InputDecoration(
        hintText: "Digite sua dúvida",
        filled: true,
        fillColor: Colors.white,
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
        )
      ),
    ),
    messageOptions: MessageOptions(
      currentUserContainerColor: Color(0xFF007DA6),
    )
    );

}

  void _handleSend(ChatMessage userMessage) async {
    // Adiciona mensagem do usuário
    setState(() {
      messages.insert(0, userMessage);
    });

    final typingMessage = ChatMessage(
      user: geminiUser,
      createdAt: DateTime.now(),
      text: "Digitando...",
    );

    setState(() {
      messages.insert(0, typingMessage);
    });

    try {
      String question = userMessage.text;
      String fullResponse = "";

      gemini.promptStream(parts: [Part.text(question)]).listen((event) {
        if (event == null || event.content == null || event.content!.parts == null) {
          return;
        }   
        final chunk = event.content!.parts!.whereType<TextPart>().map((p) => p.text).join();        
        fullResponse += chunk;

        setState(() {
          messages[0] = ChatMessage(
            user: geminiUser,
            createdAt: typingMessage.createdAt,
            text: fullResponse.trim(),
          );
        });
      });
    } catch (e) {
      print("Erro ao chamar Gemini: $e");

      setState(() {
        messages[0] = ChatMessage(
          user: geminiUser,
          createdAt: DateTime.now(),
          text: "Erro inesperado: ${e.toString()}",
        );
      });
    }
  }
}
