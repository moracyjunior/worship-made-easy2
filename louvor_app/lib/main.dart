import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/banda_page.dart';

import 'models/musica.dart';
import 'models/musico.dart';
import 'models/escala.dart';
import 'models/musica_escala.dart';
import 'models/linha_musica.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(MusicaAdapter());
  Hive.registerAdapter(MusicoAdapter());
  Hive.registerAdapter(EscalaAdapter());
  Hive.registerAdapter(MusicaEscalaAdapter());
  Hive.registerAdapter(LinhaMusicaAdapter());

  await Hive.openBox('musicas');
  await Hive.openBox('musicos');
  await Hive.openBox('escalas');

  await Supabase.initialize(
  url: 'https://wjelqmwlxemjyqbuikkx.supabase.co',
  anonKey: 'sb_publishable_1pZ62AqtCvCYtryi0FH-Uw_GEWgU4kQ',);

  runApp(const WorshipApp());
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {

  final supabase = Supabase.instance.client;

  bool carregando = true;
  bool temBanda = false;

  @override
  void initState() {
    super.initState();
    verificarUsuario();
  }

  Future<void> verificarUsuario() async {

    final user = supabase.auth.currentUser;

    if (user == null) {
      setState(() => carregando = false);
      return;
    }

    final usuario = await supabase
        .from('usuarios')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (usuario != null && usuario['banda_id'] != null) {
      temBanda = true;
    }

    setState(() => carregando = false);
  }

  @override
  Widget build(BuildContext context) {

    if (carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final user = supabase.auth.currentUser;

    if (user == null) {
      return LoginPage();
    }

    if (temBanda) {
      return const HomePage(); // ✅ já tem banda
    } else {
      return BandaPage(); // ❌ precisa entrar/criar
    }
  }
}

class WorshipApp extends StatelessWidget {
  const WorshipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Worship Made Easy',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0F1A),
      ),
      home: AuthGate(),
    );
  }
}