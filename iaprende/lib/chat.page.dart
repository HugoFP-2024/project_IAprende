import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iaprende/consts.dart';
import 'package:iaprende/quizz_page.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final Gemini gemini = Gemini.instance;
  final _auth = FirebaseAuth.instance;
  
  Future<void> _logout(BuildContext context) async{
    try{
        await _auth.signOut();
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
        actions: [_buildPopupMenu(context)],
      ),
      drawer: Drawer(
        child: Text('create drawer widget tree here'),

      ),
      body: Column( 
        children:[ Expanded(child: _buildChat()),
                   _buildQuizButton(),
        ],
      ),
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
          value: 'Sair',
          onTap: () => {
            _logout(context)
          },
          child: ListTile(
            leading: const Icon(Icons.logout, color: Color(0xFF007DA6)),
            title: const Text('Sair', style: TextStyle(color: Color(0xFF333333))),
          ),
        ),
      ],
    );
  }

// ESSE CARA AQUI É O BOTÃO DO QUIZZ!!
  Widget _buildQuizButton() {
  bool isEnabled = messages.any((msg) => 
      msg.user == geminiUser && 
      msg.text.isNotEmpty && 
      msg.text != "Digitando...");

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    decoration: BoxDecoration(
      color: const Color(0xFFF5F2D0),
      border: Border(top: BorderSide(color: Colors.grey.shade300)),
    ),
    child: ElevatedButton( 
      onPressed: isEnabled ? _startQuiz : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF007DA6),
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: const Text(
        "TENTAR QUIZ", 
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
      ),
    ),
  );
}

// ESSA É A FUNÇÃO EXECUTADA QUANDO O BOTÃO QUIZZ É CLICADO
void _startQuiz() async {
  // Pega a última mensagem enviada pelo Gemini (IAprende)
  final lastGeminiMessage = messages
      .where((msg) => msg.user == geminiUser && msg.text.isNotEmpty).first;

  final prompt = lastGeminiMessage.text;

  final url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$GEMINI_API_KEY';

  final requestBody = {
    "contents": [
      {
        "parts": [
          {
            "text":
            "Crie um quiz com 5 perguntas de múltipla escolha com 4 alternativas, com base no seguinte conteúdo:\n\n$prompt\n\nFormate a saída EXCLUSIVAMENTE neste JSON:\n\n{\n  \"quiz\": [\n    {\n      \"question\": \"...\",\n      \"options\": [\"...\", \"...\", \"...\", \"...\"],\n      \"answer_index\": ...\n    }\n  ]\n}"          }
        ]
      }
    ]
  };
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final generatedText = json['candidates'][0]['content']['parts'][0]['text'];

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => QuizzPage(quizzData: generatedText),),
      // );
      // Imprime no console o quiz gerado
      print("===== QUIZ GERADO PELO GEMINI =====");
      print(generatedText);
    } else {
      print("Erro na resposta do Gemini: ${response.statusCode}");
      print("Corpo da resposta: ${response.body}");
    }
  } catch (e) {
    print("Erro ao fazer a requisição ao Gemini: $e");
  }
}

//ESSE CARA AQUI É O DASH_CHAT_2
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

// ESSE CARA AQUI É A FUNÇÃO QUANDO A MENSAGEM É ENVIADA NO CHAT
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
