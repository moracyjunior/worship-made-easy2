import 'package:hive/hive.dart';
import 'musica.dart';

part 'musica_escala.g.dart';

@HiveType(typeId: 3)
class MusicaEscala extends HiveObject {

  @HiveField(0)
  Musica musica;

  @HiveField(1)
  String tomAtual;

  MusicaEscala({
    required this.musica,
    required this.tomAtual,
  });
}