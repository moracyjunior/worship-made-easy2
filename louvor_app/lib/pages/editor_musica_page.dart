import 'package:flutter/material.dart';
import 'package:louvor_app/models/musica.dart';
import 'package:hive/hive.dart';
import '../services/musica_service.dart';

class EditorMusicaPage extends StatefulWidget {
  
  @override
  State<EditorMusicaPage> createState() => _EditorMusicaPageState();
}

class _EditorMusicaPageState extends State<EditorMusicaPage> {

  String bandaId = "671d5a7c-c348-495d-93d3-64b922a5b2b2"; 

  TextEditingController nome = TextEditingController();
  TextEditingController tom = TextEditingController();

  List<Map<String, dynamic>> blocos = [];

  void salvarMusica() async {

    if (nome.text.isEmpty || tom.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Preencha o nome da música e o tom."),
        ),
      );
      return;
    }

    String cifraFinal = "";

    for (var bloco in blocos) {

      cifraFinal += "\n${bloco["tipo"].toUpperCase()}\n\n";

      for (var linha in bloco["linhas"]) {

        /// =========================
        /// CIFRAS (SEM AUTOMAÇÃO)
        /// =========================
        if (linha["acorde"].toString().isNotEmpty) {

          List<String> acordes = (linha["acorde"] as String)
              .split(" ")
              .where((e) => e.isNotEmpty)
              .toList();

          String linhaFormatada = acordes.join(" ");

          cifraFinal += "$linhaFormatada\n";
        }

        /// =========================
        /// LETRA (SEM AUTOMAÇÃO)
        /// =========================
        if (bloco["letra"] && linha["letra"].toString().isNotEmpty) {

          cifraFinal += "${linha["letra"]}\n";
        }

        cifraFinal += "\n";
      }
    }

    final musica = Musica(
      nome: nome.text,
      tom: tom.text,
      cifra: cifraFinal,
    );

    final box = Hive.box('musicas');

    await box.add(musica);

    Navigator.pop(context);

    final musicaService = MusicaService();

    await musicaService.salvarMusica(musica, bandaId);

  }

  void adicionarBloco(String tipo, {bool letra = true}) {
    setState(() {
      blocos.add({
        "tipo": tipo,
        "letra": letra,
        "linhas": [
          {"acorde": "", "letra": ""}
        ]
      });
    });
  }

  void adicionarLinha(int blocoIndex) {
    setState(() {
      blocos[blocoIndex]["linhas"].add({"acorde": "", "letra": ""});
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Editor de Música"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: salvarMusica,
          )
        ],
      ),

      body: Column(
        children: [

          /// NOME E TOM
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [

                TextField(
                  controller: nome,
                  decoration: const InputDecoration(
                    labelText: "Nome da música",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: tom,
                  decoration: const InputDecoration(
                    labelText: "Tom original",
                    border: OutlineInputBorder(),
                  ),
                ),

              ],
            ),
          ),

          const Divider(),

          /// BOTÕES DE BLOCO
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [

                botao("Verso"),
                botao("Refrão"),
                botao("Ponte"),
                botao("Final"),
                botao("Intro", letra: false),
                botao("Solo", letra: false),

              ],
            ),
          ),

          const Divider(),

          /// LISTA DE BLOCOS
          Expanded(
            child: ListView.builder(
              itemCount: blocos.length,
              itemBuilder: (context, blocoIndex) {

                final bloco = blocos[blocoIndex];

                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        bloco["tipo"],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Column(
                        children: List.generate(
                          bloco["linhas"].length,
                          (linhaIndex) {

                            return Column(
                              children: [

                                /// CIFRAS
                                TextField(
                                  decoration: const InputDecoration(
                                    labelText: "Linha de Cifras",
                                    border: OutlineInputBorder(),
                                  ),
                                  style: const TextStyle(
                                    fontFamily: "monospace",
                                  ),
                                  onChanged: (valor) {
                                    bloco["linhas"][linhaIndex]["acorde"] = valor;
                                  },
                                ),

                                const SizedBox(height: 8),

                                /// LETRA
                                if (bloco["letra"])
                                  TextField(
                                    maxLength: 42,
                                    decoration: const InputDecoration(
                                      labelText: "Linha de Letra",
                                      border: OutlineInputBorder(),
                                    ),
                                    style: const TextStyle(
                                      fontFamily: "monospace",
                                    ),
                                    onChanged: (valor) {
                                      bloco["linhas"][linhaIndex]["letra"] = valor;
                                    },
                                  ),

                                const SizedBox(height: 10),

                              ],
                            );
                          },
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () => adicionarLinha(blocoIndex),
                        child: const Text("+ Linha"),
                      ),

                      const Divider()

                    ],
                  ),
                );
              },
            ),
          )

        ],
      ),
    );
  }

  Widget botao(String tipo, {bool letra = true}) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ElevatedButton(
        onPressed: () => adicionarBloco(tipo, letra: letra),
        child: Text(tipo),
      ),
    );
  }
}