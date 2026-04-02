import 'package:hive/hive.dart';

part 'musica.g.dart';

@HiveType(typeId: 0)
class Musica extends HiveObject {

  @HiveField(0)
  String nome;

  @HiveField(1)
  String tom;

  @HiveField(2)
  String cifra;

  Musica({
    required this.nome,
    required this.tom,
    required this.cifra,
  });
}