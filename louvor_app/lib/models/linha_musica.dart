import 'package:hive/hive.dart';

part 'linha_musica.g.dart';

@HiveType(typeId: 4)
class LinhaMusica extends HiveObject {

  @HiveField(0)
  String tipo;

  @HiveField(1)
  String acordes;

  @HiveField(2)
  String letra;

  LinhaMusica({
    required this.tipo,
    required this.acordes,
    required this.letra,
  });
}