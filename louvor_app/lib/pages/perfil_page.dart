import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {

  final supabase = Supabase.instance.client;

  final nomeController = TextEditingController();
  final instrumentoController = TextEditingController();
  final vocalController = TextEditingController();

  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {

    final user = supabase.auth.currentUser;
    if (user == null) return;

    final usuario = await supabase
        .from('usuarios')
        .select()
        .eq('id', user.id)
        .single();

    nomeController.text = usuario['nome'] ?? '';
    instrumentoController.text = usuario['instrumento'] ?? '';
    vocalController.text = usuario['extensao_vocal'] ?? '';

    setState(() => carregando = false);
  }

  Future<void> salvar() async {

  final user = supabase.auth.currentUser;
  if (user == null) return;

  try {

    await supabase.from('usuarios').update({
      'nome': nomeController.text,
      'instrumento': instrumentoController.text,
      'extensao_vocal': vocalController.text,
    }).eq('id', user.id);

    if (!mounted) return;

    /// ✅ GARANTE QUE APARECE
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Dados salvos com sucesso!"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

  } catch (e) {

    if (!mounted) return;

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Erro ao salvar: $e"),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {

    if (carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Meu Perfil")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: nomeController,
              decoration: const InputDecoration(
                labelText: "Nome",
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: instrumentoController,
              decoration: const InputDecoration(
                labelText: "Instrumento",
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: vocalController,
              decoration: const InputDecoration(
                labelText: "Extensão Vocal",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: salvar,
              child: const Text("Salvar"),
            ),

          ],
        ),
      ),
    );
  }
}