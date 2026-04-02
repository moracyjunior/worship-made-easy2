// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'musica.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MusicaAdapter extends TypeAdapter<Musica> {
  @override
  final int typeId = 0;

  @override
  Musica read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Musica(
      nome: fields[0] as String,
      tom: fields[1] as String,
      cifra: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Musica obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.nome)
      ..writeByte(1)
      ..write(obj.tom)
      ..writeByte(2)
      ..write(obj.cifra);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MusicaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
