import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {

  final supabase = Supabase.instance.client;

  Future signUp(String email, String senha, String nome) async {
  await Supabase.instance.client.auth.signUp(
    email: email,
    password: senha,
    data: {
      'nome': nome, 
    },
  );
}

  Future signIn(String email, String senha) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: senha,
    );
  }

  User? get user => supabase.auth.currentUser;
}