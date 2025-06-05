
import 'package:flutter/material.dart';

// Modelo simples para representar uma pergunta e suas opções
class StaticQuestion {
  final String questionText;
  final List<String> options;
  final int correctAnswer;
  
  StaticQuestion({
    required this.questionText,
    required this.options,
    required this.correctAnswer,
  });

}

class QuizzPage extends StatefulWidget {
  final List<dynamic> quizJson;
  const QuizzPage({super.key, required this.quizJson});
  @override
  State<QuizzPage> createState() => _QuizzPageState();
}

class _QuizzPageState extends State<QuizzPage> {
  //AQUI FAZ GUARDA AS INFORMAÇÕES DE CADA PERGUNTA COM SUAS ALTERNATIVAS
  final List<StaticQuestion> _quizData = [];
  // ESSE CARA AQUI GUARDA AS RESPOSTAS DO USUÁRIO
  final Map<int, String?> _selectedAnswers = {};
  // SERVE PARA VALIDAR SE A RESPOSTA FOI ENVIADA
  bool _respostasEnviadas = false;


  @override
 
  void initState() {
  super.initState();

  // AQUI CONVERTE O JSON NA CLASSE CRIADA STATIC QUESTION
  for (var item in widget.quizJson) {
    _quizData.add(
      StaticQuestion(
        questionText: item['question'],
        options: List<String>.from(item['options']),
        correctAnswer: item['answer_index'],
      ),
    );
  }
}

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F2D0), // Creme claro
      appBar: AppBar(
        shadowColor: Colors.black.withOpacity(0.5),
        elevation: 6.0,
        title: Text("Quizz", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color(0xFF007DA6), 
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_sharp, color: Colors.white),
        ),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Menu Opções',
            icon: Icon(Icons.more_vert, color: Colors.white), 
            color: Color(0xFFF5F2D0), 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            offset: Offset(0, kToolbarHeight), 
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // AQUI MAPEIA AS PERGUNTAS DA CLASSE STATIC PARA CRIAR OS CARDS
            ...List.generate(_quizData.length, (index) {
              StaticQuestion question = _quizData[index];
              return Card(
                elevation: 4.0,
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                color: Colors.white, 
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
                          color: Color(0xFF333333), 
                        ),
                      ),
                      SizedBox(height: 12.0),
                      // AQUI MAPEIA AS ALTERNATIVAS
                      ...question.options.map((option) {
                        return RadioListTile<String>(
                          title: Text(option, 
                          // ADICIONEI AQUI A FUNÇÃO PARA DEFINIR A COR DA ALTERNATIVA
                          style:TextStyle(
                            color: _getOptionColor(index, option) ?? Color(0xFF555555),
                            fontWeight: _getOptionColor(index, option) != null ? FontWeight.bold : FontWeight.normal,)),
                          value: option,
                          groupValue: _selectedAnswers[index],
                          onChanged: (String? value) {
                            setState(() {
                              _selectedAnswers[index] = value;
                            });
                          },
                          activeColor: Color(0xFF007DA6), 
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
                setState(() {
                  _respostasEnviadas = true;
                 });
                print("Respostas selecionadas: $_selectedAnswers");
                //COMEÇANDO VALIDAÇÃO AMIGÃO
                int correct = 0;
                for (int i = 0; i < _quizData.length; i++) {
                  final selected = _selectedAnswers[i];
                  final correctOption = _quizData[i].options[_quizData[i].correctAnswer];
                  if (selected == correctOption) correct++;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Você acertou $correct de ${_quizData.length} questões.'),
                    backgroundColor: Color.fromARGB(255, 0, 100, 133),
                  )
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF007DA6), 
                padding: EdgeInsets.symmetric(vertical: 16.0),
                textStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)
                )
              ),
              child: Text("Enviar Respostas", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20.0), 
          ],
        ),
      ),
    );
  }

  Color? _getOptionColor(int questionIndex, String option) {
    if (!_respostasEnviadas) return null;

    final question = _quizData[questionIndex];
    final selectedOption = _selectedAnswers[questionIndex];
    final correctOption = question.options[question.correctAnswer];

    if (option == selectedOption) {
    if (selectedOption == correctOption) {
      return Colors.green; // Correta selecionada
    } else {
      return Colors.red; // Errada selecionada
    }
  }
    return null;
  }

}

