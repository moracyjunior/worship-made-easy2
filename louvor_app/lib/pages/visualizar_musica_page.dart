import 'package:flutter/material.dart';
import 'package:louvor_app/models/musica.dart';
import 'package:louvor_app/models/musica_escala.dart';
import 'modo_culto_page.dart';

class VisualizarMusicaPage extends StatefulWidget {
  final Musica musica;
  final MusicaEscala? musicaEscala;

  const VisualizarMusicaPage({
    super.key,
    required this.musica,
    this.musicaEscala,
  });

  @override
  State<VisualizarMusicaPage> createState() =>
      _VisualizarMusicaPageState();
}

class _VisualizarMusicaPageState
    extends State<VisualizarMusicaPage> {

  late String cifraAtual;
  late String tomOriginal;
  late String tomAtual;

  int deslocamento = 0;

  final List<String> notas = [
    "C","C#","D","D#","E","F",
    "F#","G","G#","A","A#","B"
  ];

  @override
  void initState() {
    super.initState();

    cifraAtual = widget.musica.cifra;
    tomOriginal = widget.musica.tom;

    tomAtual = widget.musicaEscala?.tomAtual ?? widget.musica.tom;

    deslocamento = calcularDeslocamento();

    cifraAtual = transporCifra(widget.musica.cifra);
  }

  int calcularDeslocamento() {

    int originalIndex = notas.indexOf(tomOriginal);
    int atualIndex = notas.indexOf(tomAtual);

    if (originalIndex == -1 || atualIndex == -1) return 0;

    int diff = atualIndex - originalIndex;

    if (diff < 0) {
      diff += notas.length;
    }

    return diff;
  }

  String transporCifra(String cifra) {

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

      else if (RegExp(r'^[A-G]').hasMatch(linha.trim())) {

        linha = linha.replaceAllMapped(
          RegExp(r'\b([A-G](?:#|b)?)([^\s/]*)?(?:/([A-G](?:#|b)?))?\b'),
          (match) {

            String raiz = match.group(1)!;
            String sufixo = match.group(2) ?? "";
            String? baixo = match.group(3);

            int index = notas.indexOf(raiz);

            if (index == -1) return match.group(0)!;

            int novoIndex = (index + deslocamento) % notas.length;

            String novoAcorde = notas[novoIndex] + sufixo;

            if (baixo != null) {

              int baixoIndex = notas.indexOf(baixo);

              if (baixoIndex != -1) {

                int novoBaixoIndex =
                    (baixoIndex + deslocamento) % notas.length;

                novoAcorde += "/${notas[novoBaixoIndex]}";
              }
            }

            return novoAcorde;
          },
        );
      }

      resultado.add(linha);
    }

    return resultado.join("\n");
  }

  void transpor(int direcao) {

    setState(() {

      deslocamento += direcao;

      cifraAtual = transporCifra(widget.musica.cifra);

      tomAtual = transporNota(tomOriginal, deslocamento);

      if (widget.musicaEscala != null) {
        widget.musicaEscala!.tomAtual = tomAtual;
        widget.musicaEscala!.save();
      }

    });
  }

  String transporNota(String nota, int deslocamento) {

    final Map<String, String> bemolParaSustenido = {
      'Bb': 'A#',
      'Db': 'C#',
      'Eb': 'D#',
      'Gb': 'F#',
      'Ab': 'G#',
    };

    if (nota.endsWith('b')) {
      nota = bemolParaSustenido[nota] ?? nota;
    }

    int index = notas.indexOf(nota);
    if (index == -1) return nota;

    int novoIndex = (index + deslocamento) % notas.length;

    if (novoIndex < 0) novoIndex += notas.length;

    return notas[novoIndex];
  }

  void resetarTom() {

    setState(() {

      deslocamento = 0;

      cifraAtual = widget.musica.cifra;

      tomAtual = tomOriginal;

      if (widget.musicaEscala != null) {
        widget.musicaEscala!.tomAtual = tomOriginal;
        widget.musicaEscala!.save();
      }

    });
  }

  /// =========================
  /// NOVA FUNÇÃO DE CORES
  /// =========================

  List<TextSpan> colorirCifra(String cifra) {

    List<TextSpan> spans = [];

    List<String> linhas = cifra.split("\n");

    Color corAtual = Colors.white;

    for (var linha in linhas) {

      String upper = linha.trim().toUpperCase();

      if (upper == "INTRO") {
        corAtual = Colors.orange;
      } else if (upper == "REFRÃO") {
        corAtual = Colors.lightBlueAccent;
      } else if (upper == "VERSO") {
        corAtual = Colors.white;
      } else if (upper == "PONTE") {
        corAtual = Colors.purpleAccent;
      } else if (upper == "FINAL") {
        corAtual = Colors.redAccent;
      } else if (upper == "SOLO") {
        corAtual = Colors.yellow;
      }

      spans.add(
        TextSpan(
          text: linha + "\n",
          style: TextStyle(color: corAtual),
        ),
      );
    }

    return spans;
  }

  String processarCifra(String cifra) {
    List<String> linhas = cifra.split("\n");
    List<String> resultado = [];

    for (int i = 0; i < linhas.length; i++) {
      final linhaAtual = linhas[i];
      final proximaLinha = i + 1 < linhas.length ? linhas[i + 1] : "";

      // Verso / Refrão / Ponte etc: linha de acorde + linha de letra
      if (linhaAtual.contains("?") && proximaLinha.contains("|")) {
        resultado.add(alinharLinha(linhaAtual, proximaLinha));
        i++; // pula a linha da letra
      }
      // Intro / Solo: só linha de acorde
      else if (linhaAtual.contains("?")) {
        resultado.add(linhaAtual.replaceAll("?", ""));
      }
      // Demais linhas
      else {
        resultado.add(linhaAtual);
      }
    }

    return resultado.join("\n");
  }

  String alinharLinha(String linhaAcorde, String linhaLetra) {

    RegExp regexAcorde =
        RegExp(r'\?([A-G][#b]?(?:m|maj7|7|sus4|dim|aug)?)');

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
        List.filled(letraLimpa.length + 20, " ");

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

  void editarMusica() {
    // (mantido igual)
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.musica.nome),
        actions: [
          IconButton(
            icon: const Icon(Icons.fullscreen),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ModoCultoPage(
                    setlist: [
                      MusicaEscala(
                        musica: widget.musica,
                        tomAtual: tomAtual,
                      )
                    ],
                    indexInicial: 0,
                  ),
                ),
              );
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: "RobotoMono",
                    ),
                    children: colorirCifra(
                      processarCifra(cifraAtual),
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}