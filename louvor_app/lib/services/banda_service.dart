import 'package:supabase_flutter/supabase_flutter.dart';

class BandaService {

  final supabase = Supabase.instance.client;

  /// Criar banda (líder)
  Future<Map> criarBanda(String nome) async {

    final codigo = DateTime.now().millisecondsSinceEpoch
        .toString()
        .substring(7); // simples

    final response = await supabase
        .from('bandas')
        .insert({
          'nome': nome,
          'codigo': codigo,
        })
        .select()
        .single();

    return response;
  }

  /// Entrar na banda pelo código
  Future<Map?> buscarPorCodigo(String codigo) async {

    final response = await supabase
        .from('bandas')
        .select()
        .eq('codigo', codigo)
        .maybeSingle();

    return response;
  }

  /// Criar usuário
  Future criarUsuario({
    required String userId,
    required String nome,
    required String bandaId,
    required String funcao,
  }) async {

    final existente = await supabase
        .from('usuarios')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (existente != null) {

      /// 🔥 NÃO REBAIXA LÍDER
      final funcaoAtual = existente['funcao'];

      await supabase
          .from('usuarios')
          .update({
            'nome': nome,
            'banda_id': bandaId,
            'funcao': funcaoAtual == 'lider' ? 'lider' : funcao,
          })
          .eq('id', userId);

    } else {

      await supabase.from('usuarios').insert({
        'id': userId,
        'nome': nome,
        'funcao': funcao,
        'banda_id': bandaId,
      });

    }
  }

  /// Buscar banda do usuário
  Future<Map?> getUsuario(String userId) async {
    return await supabase
        .from('usuarios')
        .select()
        .eq('id', userId)
        .maybeSingle();
  }
}