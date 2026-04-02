import 'package:flutter/material.dart';
import 'package:louvor_app/models/escala.dart';
import 'detalhe_escala_page.dart';
import 'musicos_page.dart';
import 'package:hive/hive.dart';

class EscalasPage extends StatefulWidget {
  const EscalasPage({super.key});

  @override
  State<EscalasPage> createState() => _EscalasPageState();
}

class _EscalasPageState extends State<EscalasPage> {
  List<Escala> escalas = [];

  @override
void initState() {
  super.initState();
  carregarEscalas();
}

void carregarEscalas() {
  final box = Hive.box('escalas');

  setState(() {
    escalas = box.values.cast<Escala>().toList();
  });
}

  Future<void> criarEscala() async {
  DateTime? dataSelecionada = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2024),
    lastDate: DateTime(2030),
  );

  if (dataSelecionada == null) return;

  TextEditingController horarioController = TextEditingController();

  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Horário do Culto"),
      content: TextField(
        controller: horarioController,
        decoration: const InputDecoration(hintText: "Ex: 19h"),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () async {
            if (horarioController.text.isNotEmpty) {

              final box = Hive.box('escalas');

              await box.add(
                Escala(
                  data: "${dataSelecionada.day}/${dataSelecionada.month}",
                  horario: horarioController.text,
                ),
              );

              Navigator.pop(context);

              carregarEscalas();
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
        title: const Text("Escalas"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: criarEscala,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MusicosPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.group),
                label: const Text("Gerenciar Músicos"),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: escalas.isEmpty
                ? const Center(child: Text("Nenhuma escala criada"))
                : ListView.builder(
                    itemCount: escalas.length,
                    itemBuilder: (context, index) {
                      final escala = escalas[index];
                      return ListTile(
                        leading: const Icon(Icons.event),
                        title: Text(
                            "${escala.data} - ${escala.horario}"),
                        trailing:
                            const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DetalheEscalaPage(escala: escala),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}