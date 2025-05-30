import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// import 'google_button.dart';

class LoginScreen extends StatelessWidget {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential> signInWithGoogle() async {
    // Inicia o processo de login
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      throw Exception('Login cancelado pelo usuário');
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Cria uma credencial para o Firebase
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Faz o login no Firebase
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F2D0),
      body: Column(
        children: [
          // Conteúdo principal
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 300),
                    const Text(
                      'Vamos estudar?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF007DA6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Área dos botões com fundo preto
          
          Container(
            
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
    try {
      UserCredential user = await signInWithGoogle();
      print("Usuário logado: ${user.user?.displayName}");
    } catch (e) {
      print("Erro no login: $e");
    }
  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/google.png',
                        height: 24,
                        width: 24,
                      ),
                      const SizedBox(width: 12),
                      const Text('Continuar com o Google'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, "/register"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.white),
                    ),
                  ),
                  child: const Text('Cadastrar com o email'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  // onPressed: () => _navigateToSignIn(context),
                  onPressed: () => Navigator.pushReplacementNamed(context, '/emaillogin'),
                  child: const Text(
                    'Já tenho uma conta',
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
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