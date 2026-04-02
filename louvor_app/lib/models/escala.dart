import 'package:hive/hive.dart';
import 'musico.dart';
import 'musica_escala.dart';

part 'escala.g.dart';

@HiveType(typeId: 2)
class Escala extends HiveObject {

  @HiveField(0)
  String data;

  @HiveField(1)
  String horario;

  @HiveField(2)
  List<Musico> musicos;

  @HiveField(3)
  List<MusicaEscala> setlist;

  Escala({
    required this.data,
    required this.horario,
    List<Musico>? musicos,
    List<MusicaEscala>? setlist,
  })  : musicos = musicos ?? [],
        setlist = setlist ?? [];
}