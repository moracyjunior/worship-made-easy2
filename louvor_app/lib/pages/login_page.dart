import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'banda_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final nome = TextEditingController();
  final email = TextEditingController();
  final senha = TextEditingController();
  final auth = AuthService();

  void login() async {

    await auth.signIn(email.text, senha.text);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => BandaPage()),
    );
  }

  void cadastro() async {

    if (nome.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Digite seu nome")),
        );
        return;
     }

    await auth.signUp(email.text, senha.text, nome.text);
    
    login();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Login")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
                controller: nome,
                decoration: const InputDecoration(
                    labelText: "Nome",
                ),
            ), 

            TextField(
              controller: email,
              decoration: InputDecoration(labelText: "Email"),
            ),

            TextField(
              controller: senha,
              obscureText: true,
              decoration: InputDecoration(labelText: "Senha"),
            ),

            ElevatedButton(
              onPressed: login,
              child: Text("Entrar"),
            ),

            TextButton(
              onPressed: cadastro,
              child: Text("Criar conta"),
            )

          ],
        ),
      ),
    );
  }
}