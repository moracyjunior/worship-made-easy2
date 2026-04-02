import 'package:flutter/material.dart';
import 'package:louvor_app/models/musica.dart';

class NovaMusicaPage extends StatefulWidget {
  const NovaMusicaPage({super.key});

  @override
  State<NovaMusicaPage> createState() => _NovaMusicaPageState();
}

class _NovaMusicaPageState extends State<NovaMusicaPage> {
  final TextEditingController nome = TextEditingController();
  final TextEditingController tom = TextEditingController();
  final TextEditingController cifra = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nova Música"),
      ),
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
            const SizedBox(height: 12),
            TextField(
              controller: tom,
              decoration: const InputDecoration(
                labelText: "Tom",
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: cifra,
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                decoration: const InputDecoration(
                  labelText: "Letra + Cifra",
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (nome.text.isNotEmpty) {
                    Navigator.pop(
                      context,
                      Musica(
                        nome: nome.text,
                        tom: tom.text,
                        cifra: cifra.text,
                      ),
                    );
                  }
                },
                child: const Text("Salvar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}