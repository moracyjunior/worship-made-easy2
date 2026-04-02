import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/musica.dart';

class MusicaService {

  final supabase = Supabase.instance.client;

  Future salvarMusica(Musica musica, String bandaId) async {
    await supabase.from('musicas').insert({
      'nome': musica.nome,
      'tom': musica.tom,
      'cifra': musica.cifra,
      'banda_id': bandaId,
    });
  }

  Future<List> buscarMusicas(String bandaId) async {
    final response = await supabase
        .from('musicas')
        .select()
        .eq('banda_id', bandaId);

    return response;
  }
}