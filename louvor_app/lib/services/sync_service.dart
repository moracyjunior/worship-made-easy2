import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/musica.dart';

class SyncService {

  final supabase = Supabase.instance.client;

  Future sincronizar(String bandaId) async {

    final response = await supabase
        .from('musicas')
        .select()
        .eq('banda_id', bandaId);

    final box = Hive.box('musicas');

    await box.clear();

    for (var item in response) {
      box.add(
        Musica(
          nome: item['nome'],
          tom: item['tom'],
          cifra: item['cifra'],
        ),
      );
    }
  }
}