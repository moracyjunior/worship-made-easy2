import 'package:flutter/material.dart';
import '../models/musica_escala.dart';

class ModoCultoPage extends StatefulWidget {
  final List<MusicaEscala> setlist;
  final int indexInicial;

  const ModoCultoPage({
    super.key,
    required this.setlist,
    required this.indexInicial,
  });

  @override
  State<ModoCultoPage> createState() => _ModoCultoPageState();
}

class _ModoCultoPageState extends State<ModoCultoPage> {

  late int indexAtual;
  double tamanhoFonte = 16;

  final List<String> notas = [
    "C","C#","D","D#","E","F",
    "F#","G","G#","A","A#","B"
  ];

  @override
  void initState() {
    super.initState();
    indexAtual = widget.indexInicial;
  }

  /// PROCESSA CIFRA COM ? E |

  String processarCifra(String cifra) {

    List<String> linhas = cifra.split("\n");

    String resultado = "";

    for (int i = 0; i < linhas.length; i++) {

      if (linhas[i].contains("?") &&
          i + 1 < linhas.length &&
          linhas[i + 1].contains("|")) {

        String linhaAcorde = linhas[i];
        String linhaLetra = linhas[i + 1];

        resultado += alinharLinha(linhaAcorde, linhaLetra) + "\n";

        i++;

      } else {

        resultado += linhas[i]
            .replaceAll("?", "")
            .replaceAll("|", "") + "\n";

      }

    }

    return resultado;
  }

  /// ALINHA ACORDE COM LETRA

  String alinharLinha(String linhaAcorde, String linhaLetra) {

    RegExp regexAcorde = RegExp(r'\?([A-G][#b]?(?:m|maj7|7|sus4|dim|aug)?)');

    List<String> acordes = [];

    for (var match in regexAcorde.allMatches(linhaAcorde)) {
      acordes.add(match.group(1)!);
    }

    List<int> posicoes = [];

    for (int i = 0; i < linhaLetra.length; i++) {
      if (linhaLetra[i] == "|") {
        posicoes.add(i);
      }
    }

    String letraLimpa = linhaLetra.replaceAll("|", "");

    List<String> linhaAcordes =
        List.filled(letraLimpa.length + 30, " ");

    for (int i = 0; i < acordes.length && i < posicoes.length; i++) {

      int pos = posicoes[i];
      String acorde = acordes[i];

      for (int j = 0; j < acorde.length; j++) {

        if (pos + j < linhaAcordes.length) {
          linhaAcordes[pos + j] = acorde[j];
        }

      }

    }

    String acordesFinal = linhaAcordes.join().trimRight();

    return "$acordesFinal\n$letraLimpa";
  }

  @override
  Widget build(BuildContext context) {

    final musicaEscala = widget.setlist[indexAtual];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [

            /// TOPO

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  Column(
                    children: [
                      Text(
                        musicaEscala.musica.nome,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Tom: ${musicaEscala.tomAtual}",
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 48)

                ],
              ),
            ),

            /// CIFRA

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: SelectableText(
                  processarCifra(
                    gerarCifraTransposta(musicaEscala),
                  ),
                  style: TextStyle(
                    fontSize: tamanhoFonte,
                    fontFamily: 'RobotoMono',
                    color: Colors.white,
                    height: 1.35,
                  ),
                ),
              ),
            ),

            /// CONTROLES

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      IconButton(
                        icon: const Icon(Icons.remove),
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            if (tamanhoFonte > 12) {
                              tamanhoFonte -= 2;
                            }
                          });
                        },
                      ),

                      const Text(
                        "Fonte",
                        style: TextStyle(color: Colors.white),
                      ),

                      IconButton(
                        icon: const Icon(Icons.add),
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            tamanhoFonte += 2;
                          });
                        },
                      ),

                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      IconButton(
                        iconSize: 40,
                        color: Colors.white,
                        icon: const Icon(Icons.skip_previous),
                        onPressed: musicaAnterior,
                      ),

                      const SizedBox(width: 40),

                      IconButton(
                        iconSize: 40,
                        color: Colors.white,
                        icon: const Icon(Icons.skip_next),
                        onPressed: proximaMusica,
                      ),

                    ],
                  ),

                ],
              ),
            )

          ],
        ),
      ),
    );
  }

  void proximaMusica() {
    if (indexAtual < widget.setlist.length - 1) {
      setState(() {
        indexAtual++;
      });
    }
  }

  void musicaAnterior() {
    if (indexAtual > 0) {
      setState(() {
        indexAtual--;
      });
    }
  }

  /// TRANSPOSIÇÃO SEGURA

  String gerarCifraTransposta(MusicaEscala musicaEscala) {

    String tomOriginal = musicaEscala.musica.tom;
    String tomAtual = musicaEscala.tomAtual;

    int originalIndex = notas.indexOf(tomOriginal);
    int atualIndex = notas.indexOf(tomAtual);

    int deslocamento = atualIndex - originalIndex;

    if (deslocamento < 0) {
      deslocamento += 12;
    }

    String cifra = musicaEscala.musica.cifra.replaceAll("\t", "    ");

    List<String> linhas = cifra.split("\n");

    List<String> resultado = [];

    for (var linha in linhas) {

      if (linha.contains("?")) {

        linha = linha.replaceAllMapped(
          RegExp(r'\?([A-G](?:#|b)?[^\s]*)'),
          (match) {

            String acorde = match.group(1)!;

            String raiz;

            if (acorde.length > 1 &&
                (acorde[1] == '#' || acorde[1] == 'b')) {
              raiz = acorde.substring(0,2);
            } else {
              raiz = acorde.substring(0,1);
            }

            int index = notas.indexOf(raiz);

            if (index == -1) return match.group(0)!;

            int novoIndex = (index + deslocamento) % notas.length;

            String novaRaiz = notas[novoIndex];

            String novoAcorde = acorde.replaceFirst(raiz, novaRaiz);

            return "?$novoAcorde";
          },
        );
      }

      resultado.add(linha);
    }

    return resultado.join("\n");
  }
}