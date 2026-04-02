import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:louvor_app/models/musica.dart';
import 'visualizar_musica_page.dart';
import 'nova_musica_page.dart';
import 'editor_musica_page.dart';
import '../services/sync_service.dart';
import '../services/auth_service.dart';
import '../services/banda_service.dart';

class RepertorioPage extends StatefulWidget {
  const RepertorioPage({super.key});

  @override
  State<RepertorioPage> createState() => _RepertorioPageState();
}

class _RepertorioPageState extends State<RepertorioPage> {

  String? bandaId;

  List<Musica> musicas = [];


  @override
  void initState() {
    super.initState();
    carregarBanda();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    carregarMusicas();
  }

  Future<void> carregarMusicas() async {

    final sync = SyncService();

    if (bandaId == null) return;

    await sync.sincronizar(bandaId!);
    
    final box = Hive.box('musicas');
    final dados = box.values.toList();

    setState(() {
      musicas = dados.cast<Musica>();
    });
  }

  void carregarBanda() async {

    final auth = AuthService();
    final bandaService = BandaService();

    final user = auth.user;

    if (user == null) return;

    final usuario = await bandaService.getUsuario(user.id);

    setState(() {
      bandaId = usuario?['banda_id'];
    });

    carregarMusicas();
  }

  void adicionarMusica() async {
    final novaMusica = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const NovaMusicaPage(),
      ),
    );

    if (novaMusica != null && novaMusica is Musica) {
      final box = Hive.box('musicas');

      await box.add(novaMusica);

      carregarMusicas();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Repertório"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditorMusicaPage(),
                ),
              );

              carregarMusicas(); // 🔥 recarrega quando volta
            },
          ),
        ],
      ),

      body: musicas.isEmpty
          ? const Center(
              child: Text("Nenhuma música cadastrada"),
            )
          : ListView.builder(
              itemCount: musicas.length,
              itemBuilder: (context, index) {
                final musica = musicas[index];
                return ListTile(
                  leading: const Icon(Icons.music_note),
                  title: Text(musica.nome),
                  subtitle: Text("Tom: ${musica.tom}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            VisualizarMusicaPage(musica: musica),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}