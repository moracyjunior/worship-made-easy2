import 'package:flutter/material.dart';
import 'package:louvor_app/models/escala.dart';
import 'package:louvor_app/models/musico.dart';
import 'package:hive/hive.dart';
import 'package:louvor_app/models/musica.dart';
import 'visualizar_musica_page.dart';
import 'package:louvor_app/models/musica_escala.dart';

class DetalheEscalaPage extends StatefulWidget {
  final Escala escala;
  const DetalheEscalaPage({super.key, required this.escala});

  @override
  State<DetalheEscalaPage> createState() => _DetalheEscalaPageState();
}

class _DetalheEscalaPageState extends State<DetalheEscalaPage> {

   List<Musico> musicosDisponiveis = [];
   List<Musica> musicasDisponiveis = [];

   @override
   void initState() {
     super.initState();
     carregarMusicos();
     carregarMusicas();
   }

   void carregarMusicos() {
     final box = Hive.box('musicos');
     setState(() {
       musicosDisponiveis = box.values.cast<Musico>().toList();
     });
  }
    void carregarMusicas() {
      final box = Hive.box('musicas');
      setState(() {
        musicasDisponiveis = box.values.cast<Musica>().toList();
      });
    }

  void adicionarMusico() {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Selecionar Músico"),
      content: SizedBox(
        width: double.maxFinite,
        child: musicosDisponiveis.isEmpty
            ? const Text("Nenhum músico cadastrado")
            : ListView.builder(
                shrinkWrap: true,
                itemCount: musicosDisponiveis.length,
                itemBuilder: (context, index) {
                  final musico = musicosDisponiveis[index];

                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(musico.nome),
                    subtitle: Text(musico.instrumento),
                    onTap: () async {

                      // evita duplicar músico na escala
                      if (!widget.escala.musicos.contains(musico)) {

                        widget.escala.musicos.add(musico);

                        await widget.escala.save();

                        setState(() {});
                      }

                      Navigator.pop(context);
                    },
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Fechar"),
        ),
      ],
    ),
  );
}

  void adicionarMusica() {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Selecionar Música"),
      content: SizedBox(
        width: double.maxFinite,
        child: musicasDisponiveis.isEmpty
            ? const Text("Nenhuma música cadastrada")
            : ListView.builder(
                shrinkWrap: true,
                itemCount: musicasDisponiveis.length,
                itemBuilder: (context, index) {
                  final musica = musicasDisponiveis[index];

                  return ListTile(
                    leading: const Icon(Icons.music_note),
                    title: Text(musica.nome),
                    subtitle: Text("Tom original: ${musica.tom}"),
                    onTap: () async {

                      final jaExiste = widget.escala.setlist
                          .any((m) => m.musica == musica);

                      if (!jaExiste) {

                        widget.escala.setlist.add(
                          MusicaEscala(
                            musica: musica,
                            tomAtual: musica.tom,
                          ),
                        );

                        await widget.escala.save();
                        setState(() {});
                      }

                      Navigator.pop(context);
                    },
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Fechar"),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final escala = widget.escala;
    return Scaffold(
      appBar: AppBar(
        title: Text("${escala.data} - ${escala.horario}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: "Adicionar Músico",
            onPressed: adicionarMusico,
          ),
          IconButton(
            icon: const Icon(Icons.queue_music),
            tooltip: "Adicionar Música",
            onPressed: adicionarMusica,
          ),
       ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          const Text(
            "Músicos",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          if (escala.musicos.isEmpty)
            const Text("Nenhum músico adicionado")
          else
            ...escala.musicos.map((musico) => Dismissible(
                  key: ValueKey(musico),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) async {
                    widget.escala.musicos.remove(musico);
                    await widget.escala.save();
                    setState(() {});
                  },
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(musico.nome),
                    subtitle: Text(musico.instrumento),
                  ),
             )),

          const SizedBox(height: 24),

          const Text(
            "Setlist",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

           const SizedBox(height: 8),

          if (escala.setlist.isEmpty)
            const Text("Nenhuma música adicionada")
          else
            ReorderableListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              onReorder: (oldIndex, newIndex) async {

                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }

                final musica = escala.setlist.removeAt(oldIndex);
                escala.setlist.insert(newIndex, musica);

                await escala.save();

                setState(() {});
              },
              children: [
                for (int index = 0; index < escala.setlist.length; index++)
                  Dismissible(
                    key: ValueKey(escala.setlist[index]),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) async {
                      escala.setlist.removeAt(index);
                      await escala.save();
                      setState(() {});
                    },
                    child: ListTile(
                      leading: const Icon(Icons.drag_handle),
                      title: Text(escala.setlist[index].musica.nome),
                      subtitle: Text(
                        "${escala.setlist[index].musica.tom} → ${escala.setlist[index].tomAtual}"
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VisualizarMusicaPage(
                              musica: escala.setlist[index].musica,
                              musicaEscala: escala.setlist[index],
                            ),
                          ),
                        );

                         // 🔥 Força atualizar tela ao voltar
                        setState(() {});
                      },
                    ),
                  ),
             ],
           ),
        ],
      ),
    );
  }
}