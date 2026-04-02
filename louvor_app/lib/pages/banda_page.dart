import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/banda_service.dart';
import 'repertorio_page.dart';
import 'home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BandaPage extends StatefulWidget {
  @override
  State<BandaPage> createState() => _BandaPageState();
}

class _BandaPageState extends State<BandaPage> {

    TextEditingController codigoController = TextEditingController();

  final nomeBanda = TextEditingController();
  final codigo = TextEditingController();

  final bandaService = BandaService();
  final auth = AuthService();

  void criarBanda() async {

    final user = auth.user!;

    final banda = await bandaService.criarBanda(nomeBanda.text);

    await bandaService.criarUsuario(
      userId: user.id,
      nome: user.userMetadata?['nome'] ?? "Usuário",
      funcao: "lider",
      bandaId: banda['id'],
    );

    mostrarCodigo(banda['codigo']);

    Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  void entrarNaBanda() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) return;

    try {

        final banda = await Supabase.instance.client
            .from('bandas')
            .select()
            .eq('codigo', codigoController.text.trim())
            .maybeSingle();

        if (banda == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Código inválido")),
        );
        return;
        }

        await bandaService.criarUsuario(
        userId: user.id,
        nome: user.userMetadata?['nome'] ?? "Usuário",
        funcao: "membro",
        bandaId: banda['id'],
        );

        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
        );

    } catch (e) {

        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
        );
    }
    }
  void mostrarCodigo(String codigo) {

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Código da banda"),
        content: Text(
          codigo,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Banda")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// CRIAR
            TextField(
              controller: nomeBanda,
              decoration: InputDecoration(labelText: "Nome da banda"),
            ),

            ElevatedButton(
              onPressed: criarBanda,
              child: Text("Criar Banda"),
            ),

            Divider(),

            /// ENTRAR
            TextField(
                controller: codigoController,
                decoration: const InputDecoration(
                    labelText: "Código da banda",
                ),
                ),

            ElevatedButton(
              onPressed: entrarNaBanda,
              child: Text("Entrar na Banda"),
            ),

          ],
        ),
      ),
    );
  }
}