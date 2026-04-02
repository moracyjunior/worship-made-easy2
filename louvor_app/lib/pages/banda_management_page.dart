import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/services.dart';

class BandaManagementPage extends StatefulWidget {
  const BandaManagementPage({super.key});

  @override
  State<BandaManagementPage> createState() => _BandaManagementPageState();
}

class _BandaManagementPageState extends State<BandaManagementPage> {

  final supabase = Supabase.instance.client;

  List usuarios = [];
  bool isLider = false;
  String codigoBanda = "";

  @override
  void initState() {
    super.initState();
    carregarUsuarios();
  }

  Future<void> carregarUsuarios() async {

    final user = supabase.auth.currentUser;
    if (user == null) return;

    final usuario = await supabase
        .from('usuarios')
        .select()
        .eq('id', user.id)
        .single();

    final bandaId = usuario['banda_id'];

    isLider = usuario['funcao'] == "lider";

    final banda = await supabase
        .from('bandas')
        .select()
        .eq('id', bandaId)
        .single();

    codigoBanda = banda['codigo'] ?? "";

    final response = await supabase
        .from('usuarios')
        .select()
        .eq('banda_id', bandaId);

    setState(() {
      usuarios = response;
    });
  }

  void removerUsuario(String id) async {
    await supabase.from('usuarios').delete().eq('id', id);
    carregarUsuarios();
  }

  void atualizarFuncao(String id, String funcao) async {

    if (funcao == "lider") {
      await supabase
          .from('usuarios')
          .update({'funcao': 'membro'})
          .neq('id', id);
    }

    await supabase
        .from('usuarios')
        .update({'funcao': funcao})
        .eq('id', id);

    carregarUsuarios();
  }

  void atualizarInstrumento(String id, String instrumento) async {

    await supabase
        .from('usuarios')
        .update({'instrumento': instrumento})
        .eq('id', id);

    carregarUsuarios();
  }

  void _dialogInstrumento(String id) {

    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Instrumento"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: "Ex: Guitarra"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              atualizarInstrumento(id, controller.text);
              Navigator.pop(context);
            },
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if (!isLider) {
      return Scaffold(
        appBar: AppBar(title: const Text("Gerenciar Banda")),
        body: const Center(
          child: Text("Apenas o líder pode acessar"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Gerenciar Banda")),
      body: Column(
        children: [

          /// CÓDIGO DA BANDA
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [

                const Text(
                  "Código da Banda",
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 8),

                Text(
                  codigoBanda,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: codigoBanda));

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Código copiado")),
                    );
                  },
                  child: const Text("Copiar"),
                ),

              ],
            ),
          ),

          /// LISTA DE USUÁRIOS
          Expanded(
            child: ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, index) {

                final user = usuarios[index];

                return Card(
                  child: ListTile(
                    title: Text(user['nome'] ?? ''),
                    subtitle: Text(
                      "Função: ${user['funcao'] ?? ''} | ${user['instrumento'] ?? ''}",
                    ),

                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {

                        if (value == "remover") {
                          removerUsuario(user['id']);
                        } else if (value == "lider") {
                          atualizarFuncao(user['id'], "lider");
                        } else if (value == "membro") {
                          atualizarFuncao(user['id'], "membro");
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: "lider", child: Text("Tornar líder")),
                        const PopupMenuItem(value: "membro", child: Text("Tornar membro")),
                        const PopupMenuItem(value: "remover", child: Text("Remover")),
                      ],
                    ),

                    onTap: () {
                      _dialogInstrumento(user['id']);
                    },
                  ),
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}