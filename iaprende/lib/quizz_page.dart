import 'package:flutter/material.dart';

// Modelo simples para representar uma pergunta e suas opções
class StaticQuestion {
  final String questionText;
  final List<String> options;
  final String? correctAnswer; // Opcional, não usado na visualização estática de seleção

  StaticQuestion({
    required this.questionText,
    required this.options,
    this.correctAnswer,
  });
}

class QuizzPage extends StatefulWidget {
  @override
  State<QuizzPage> createState() => _QuizzPageState();
}

class _QuizzPageState extends State<QuizzPage> {
  // Dados estáticos para o quiz
  final List<StaticQuestion> _quizData = [
    StaticQuestion(
      questionText: "1. Qual a capital da França?",
      options: ["Berlim", "Madri", "Paris", "Lisboa"],
      correctAnswer: "Paris",
    ),
    StaticQuestion(
      questionText: "2. Qual o maior planeta do sistema solar?",
      options: ["Terra", "Júpiter", "Marte", "Vênus"],
      correctAnswer: "Júpiter",
    ),
    StaticQuestion(
      questionText: "3. Quem escreveu 'Dom Quixote'?",
      options: ["Machado de Assis", "Miguel de Cervantes", "Carlos Drummond de Andrade", "Fernando Pessoa"],
      correctAnswer: "Miguel de Cervantes",
    ),
    StaticQuestion(
      questionText: "4. Quantos lados tem um heptágono?",
      options: ["5", "6", "7", "8"],
      correctAnswer: "7",
    ),
    StaticQuestion(
      questionText: "5. Em que ano o homem pisou na Lua pela primeira vez?",
      options: ["1965", "1969", "1971", "1975"],
      correctAnswer: "1969",
    ),
  ];

  // Para guardar a opção selecionada para cada pergunta (index da pergunta -> opção selecionada)
  // Usaremos o texto da opção como valor para simplicidade neste exemplo estático
  final Map<int, String?> _selectedAnswers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F2D0), // Creme claro
      appBar: AppBar(
        shadowColor: Colors.black.withOpacity(0.5),
        elevation: 6.0,
        title: Text("Quizz", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color(0xFF007DA6), // Azul escuro
        leading: IconButton(
          // onPressed: null, // Mantido como null, conforme seu código original
          onPressed: () {
            // Ação para o menu (ex: Scaffold.of(context).openDrawer())
            print("Menu button pressed");
          },
          icon: Icon(Icons.menu, color: Colors.white),
        ),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Menu Opções',
            icon: Icon(Icons.more_vert, color: Colors.white), // Ícone mais comum para menu de opções
            color: Color(0xFFF5F2D0), // Cor de fundo do popup
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            offset: Offset(0, kToolbarHeight), // Para posicionar abaixo do AppBar
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings, color: Color(0xFF007DA6)),
                  title: Text('Configurações', style: TextStyle(color: Color(0xFF333333))),
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout, color: Color(0xFF007DA6)),
                  title: Text('Sair', style: TextStyle(color: Color(0xFF333333))),
                ),
                onTap: () {
                  // Adicionar um pequeno delay para o menu fechar antes de navegar
                  Future.delayed(Duration(milliseconds: 100), () {
                     Navigator.pushReplacementNamed(context, '/login');
                     print("Sair selecionado - Navegar para /login (comentado)");
                  });
                },
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView( // Permite rolagem se o conteúdo for maior que a tela
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Mapeia os dados estáticos para criar os cards de pergunta
            ...List.generate(_quizData.length, (index) {
              StaticQuestion question = _quizData[index];
              return Card(
                elevation: 4.0,
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                color: Colors.white, // Fundo do card
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.questionText,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333), // Cor escura para o texto da pergunta
                        ),
                      ),
                      SizedBox(height: 12.0),
                      // Mapeia as opções para criar RadioListTile
                      ...question.options.map((option) {
                        return RadioListTile<String>(
                          title: Text(option, style: TextStyle(color: Color(0xFF555555))),
                          value: option,
                          groupValue: _selectedAnswers[index],
                          onChanged: (String? value) {
                            setState(() {
                              _selectedAnswers[index] = value;
                            });
                          },
                          activeColor: Color(0xFF007DA6), // Cor do rádio selecionado
                          contentPadding: EdgeInsets.zero,
                        );
                      }).toList(),
                    ],
                  ),
                ),
              );
            }),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                // Lógica para checar as respostas (não implementada neste exemplo estático)
                print("Botão Enviar Pressionado!");
                print("Respostas selecionadas: $_selectedAnswers");
                // Aqui você adicionaria a lógica para comparar com _quizData[index].correctAnswer
                // e mostrar o resultado.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Respostas enviadas para verificação! (Simulação)'),
                    backgroundColor: Color(0xFF007DA6),
                  )
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00C2A8), // Verde-azulado para o botão
                padding: EdgeInsets.symmetric(vertical: 16.0),
                textStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)
                )
              ),
              child: Text("Enviar Respostas", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20.0), // Espaço extra no final
          ],
        ),
      ),
    );
  }
}