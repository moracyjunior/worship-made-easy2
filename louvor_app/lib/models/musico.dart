import 'package:hive/hive.dart';

part 'musico.g.dart';

@HiveType(typeId: 1)
class Musico extends HiveObject {

  @HiveField(0)
  String nome;

  @HiveField(1)
  String instrumento;

  Musico({
    required this.nome,
    required this.instrumento,
  });
}