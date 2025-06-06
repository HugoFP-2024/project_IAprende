import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecoveryPage extends StatelessWidget {

  final txtEmail = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _recover (BuildContext context) async {
    try{
       await  _auth.sendPasswordResetEmail(email: txtEmail.text);
       final snackBar = SnackBar(content: Text("E-mail enviado ao endereço indicado. Redefina sua senha e realize o login"));
       ScaffoldMessenger.of(context).showSnackBar(snackBar);
       Navigator.popAndPushNamed(context, "/login");
      }
    on FirebaseAuthException catch(ex) {
      final snackBar = SnackBar(content: Text(ex.message!));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F2D0),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Icon(Icons.school, size: 80, color: Color(0xFF007DA6)),
              const SizedBox(height: 20),
              const Text(
                'Redefina sua senha',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF007DA6),
                ),
              ),
              const SizedBox(height: 40),

              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextField(
                        controller: txtEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email, color: Colors.grey[600]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          hintText: "E-mail",
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              // Botão principal
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _recover(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007DA6),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    "Enviar e-mail",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, "/login"),
                child: const Text(
                  "Voltar",
                  style: TextStyle(
                    color: Color(0xFF007DA6),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





