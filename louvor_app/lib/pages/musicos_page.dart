import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/musico.dart';

class MusicosPage extends StatefulWidget {
  const MusicosPage({super.key});

  @override
  State<MusicosPage> createState() => _MusicosPageState();
}

class _MusicosPageState extends State<MusicosPage> {
  List<Musico> musicos = [];

  @override
  void initState() {
    super.initState();
    carregarMusicos();
  }

  void carregarMusicos() {
    final box = Hive.box('musicos');
    setState(() {
      musicos = box.values.cast<Musico>().toList();
    });
  }

  void adicionarMusico() {
    TextEditingController nome = TextEditingController();
    TextEditingController instrumento = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Novo Músico"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nome,
              decoration: const InputDecoration(labelText: "Nome"),
            ),
            TextField(
              controller: instrumento,
              decoration: const InputDecoration(labelText: "Instrumento"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nome.text.isNotEmpty) {
                final box = Hive.box('musicos');
                await box.add(
                  Musico(
                    nome: nome.text,
                    instrumento: instrumento.text,
                  ),
                );
                Navigator.pop(context);
                carregarMusicos();
              }
            },
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Músicos"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: adicionarMusico,
          ),
        ],
      ),
      body: musicos.isEmpty
          ? const Center(child: Text("Nenhum músico cadastrado"))
          : ListView.builder(
              itemCount: musicos.length,
              itemBuilder: (context, index) {
                final musico = musicos[index];
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(musico.nome),
                  subtitle: Text(musico.instrumento),
                );
              },
            ),
    );
  }
}