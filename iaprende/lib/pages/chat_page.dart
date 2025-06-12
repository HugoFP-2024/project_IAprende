import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iaprende/consts.dart';
import 'package:iaprende/pages/quizz_page.dart';
import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart' as stt;


class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final Gemini gemini = Gemini.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
  
  //PARTE RESPONSÁVEL POR PEGAR OS DADOS DO USUÁRIO LOGADO MY FRIEND 
  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _speech = stt.SpeechToText();
  }

  void _loadCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        currentUser = ChatUser(
          id: user.uid,
          firstName: user.email.toString() ?? "Usuário",
          profileImage: null,
        );
        // print(user);
      });
    }
  }

  ChatUser? currentUser;
  
  final ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "IAprende",
    profileImage: "https://cdn-icons-png.flaticon.com/512/4712/4712109.png",
  );

  String? currentChatId;

  // Cria um novo chat e define o chatId atual, limpando o chat atual
  Future<void> _createNewChat() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final chatRef = FirebaseFirestore.instance.collection('chats').doc();
    await chatRef.set({
      'title': 'Novo Chat',
      'createdAt': FieldValue.serverTimestamp(),
      'owner': user.uid,
    });
    setState(() {
      currentChatId = chatRef.id;
      messages.clear(); // Limpa o chat atual ao criar novo chat
    });
  }

  // Carrega as mensagens do chat selecionado
  Future<void> _loadMessagesForChat(String chatId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .get();

    final loadedMessages = snapshot.docs.map((doc) {
      final data = doc.data();
      return ChatMessage(
        user: data['userId'] == geminiUser.id
            ? geminiUser
            : currentUser!,
        createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        text: data['text'] ?? '',
        // Adicione outros campos se necessário
      );
    }).toList();

    setState(() {
      messages = loadedMessages;
    });
  Navigator.pop(context);
  }

  // Função para deletar um chat e abrir o próximo disponível
  Future<void> _deleteChatAndOpenNext(String chatId, String userId) async {
    // Apaga todas as mensagens do chat
    final messagesSnapshot = await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .get();
    for (var doc in messagesSnapshot.docs) {
      await doc.reference.delete();
    }
    // Apaga o chat
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .delete();

    // Busca o próximo chat disponível
    final updatedSnapshot = await FirebaseFirestore.instance
        .collection('chats')
        .where('owner', isEqualTo: userId)
        .get();
    final updatedDocs = updatedSnapshot.docs;
    if (updatedDocs.isNotEmpty) {
      final firstChatId = updatedDocs.first.id;
      setState(() {
        messages.clear();
        currentChatId = firstChatId;
      });
      await _loadMessagesForChat(firstChatId);
    } else {
      // Se não houver chats, cria um novo chat automaticamente
      await _createNewChat();
    }
  }

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
        backgroundColor: const Color(0xFFF5F2D0),
        child: Builder(
          builder: (context) {
            final user = FirebaseAuth.instance.currentUser;
            if (user == null) {
              return Center(child: Text('Usuário não autenticado'));
            }
            final userId = user.uid;
            return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                  .collection('chats')
                  .where('owner', isEqualTo: userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar mensagens'));
                }
                final msgDocs = snapshot.data?.docs ?? [];
                return ListView.builder(
                  itemCount: msgDocs.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: ListTile(
                          title: Icon(Icons.add),
                          onTap: () async {
                            await _createNewChat();
                            Navigator.pop(context);
                          },
                        ),
                      );
                    }
                    final msgDoc = msgDocs[index - 1];
                    final data = msgDoc.data() as Map<String, dynamic>?;
                    final chatTitle = data != null && data.containsKey('title')
                        ? data['title']
                        : msgDoc.id;
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: ListTile(
                        title: Text('$chatTitle'),
                        trailing: _SmallDeleteButton(
                          onPressed: () async {
                            await _deleteChatAndOpenNext(msgDoc.id, userId);
                          },
                        ),
                        onTap: () async {
                          setState(() {
                            messages.clear();
                            currentChatId = msgDoc.id;
                          });
                          await _loadMessagesForChat(msgDoc.id);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
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
        
        // PopupMenuItem(
        //   value: 'settings',
        //   onTap: () => null ,
        //   child: ListTile(
        //     leading: const Icon(Icons.settings, color: Color(0xFF007DA6)),
        //     title: const Text('Configurações', style: TextStyle(color: Color(0xFF333333))),
        //   ),
        // ),

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

      final cleanedText = generatedText.toString().replaceAll("```json", "")
      .replaceAll("```", "")
      .trim();

      final decodedQuizz = jsonDecode(cleanedText);

      final List<dynamic> quizzList = decodedQuizz['quiz'];
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => QuizzPage(quizJson: quizzList),),
      );
      // Imprime no console o quiz gerado
      // print("===== QUIZ GERADO PELO GEMINI =====");
      // print(generatedText);
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
      currentUser: currentUser!,
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
          ),
          // Troque GestureDetector por IconButton para melhor usabilidade
          suffixIcon: IconButton(
            icon: Icon(
              _isListening ? Icons.mic : Icons.mic_none,
              color: _isListening ? Color(0xFF007DA6) : Colors.grey[600],
            ),
            onPressed: () async {
              if (_isListening) {
                await _stopListening();
              } else {
                await _startListening();
              }
            },
            tooltip: _isListening ? 'Parar gravação' : 'Falar',
          ),
        ),
        textController: _inputController,
      ),
      messageOptions: MessageOptions(
        currentUserContainerColor: Color(0xFF007DA6),
      ),
    );
  }

  // Adicione estas variáveis como membros da classe
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _voiceInput = "";
  final TextEditingController _inputController = TextEditingController();

  Future<void> _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (val) {
        if (val == "done" || val == "notListening") {
          setState(() => _isListening = false);
        }
      },
      onError: (val) {
        setState(() => _isListening = false);
      },
    );
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) {
          setState(() {
            _voiceInput = val.recognizedWords;
            _inputController.text = _voiceInput;
            _inputController.selection = TextSelection.fromPosition(
              TextPosition(offset: _inputController.text.length),
            );
          });
        },
        localeId: 'pt_BR',
      );
    }
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
  }

  // ESSE CARA AQUI É A FUNÇÃO QUANDO A MENSAGEM É ENVIADA NO CHAT
  void _handleSend(ChatMessage userMessage) {
    setState(() {
      messages.insert(0, userMessage);
    });

    _saveMessageToFirestore(userMessage);

    // Atualiza o título do chat com o texto da última mensagem enviada
    if (currentChatId != null) {
      FirebaseFirestore.instance
        .collection('chats')
        .doc(currentChatId)
        .update({'title': userMessage.text});
    }

    final typingMessage = ChatMessage(
      user: geminiUser,
      createdAt: DateTime.now(),
      text: "Digitando...",
    );

    setState(() {
      messages.insert(0, typingMessage);
    });

    String fullResponse = "";
    StreamSubscription? sub;

    try {
      String question = userMessage.text;

      sub = gemini.promptStream(parts: [Part.text(question)]).listen(
        (event) {
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
        },
        onDone: () async {
          // Salva a resposta completa apenas uma vez
          final responseMessage = ChatMessage(
            user: geminiUser,
            createdAt: typingMessage.createdAt,
            text: fullResponse.trim(),
          );
          await _saveMessageToFirestore(responseMessage);
        },
        onError: (e) {
          print("Erro ao chamar Gemini: $e");
          setState(() {
            messages[0] = ChatMessage(
              user: geminiUser,
              createdAt: DateTime.now(),
              text: "Erro inesperado: ${e.toString()}",
            );
          });
        },
        cancelOnError: true,
      );
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

  // Salva as mensagens do chat no Firestore usando o chatId atual
  Future<void> _saveMessageToFirestore(ChatMessage message) async {
    final user = _auth.currentUser;
    if (user == null || currentChatId == null) return;
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(currentChatId)
        .collection('messages')
        .add({
          'text': message.text,
          'createdAt': message.createdAt,
          'userId': message.user.id,
          'userName': message.user.firstName,
          'profileImage': message.user.profileImage,
        });
    print("entrou na função de salvar meu mano, se liga: $message");
  }
}

// Botão de lixeira pequeno e vermelho ao passar o mouse
class _SmallDeleteButton extends StatefulWidget {
  final VoidCallback onPressed;
  const _SmallDeleteButton({required this.onPressed, Key? key}) : super(key: key);

  @override
  State<_SmallDeleteButton> createState() => _SmallDeleteButtonState();
}

class _SmallDeleteButtonState extends State<_SmallDeleteButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: IconButton(
        icon: Icon(Icons.delete, color: _hovering ? Colors.red : Colors.black, size: 18),
        tooltip: 'Excluir chat',
        onPressed: widget.onPressed,
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(
          minWidth: 24,
          minHeight: 24,
        ),
      ),
    );
  }
}
