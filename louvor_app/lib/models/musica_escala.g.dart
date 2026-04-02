// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'musica_escala.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MusicaEscalaAdapter extends TypeAdapter<MusicaEscala> {
  @override
  final int typeId = 3;

  @override
  MusicaEscala read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MusicaEscala(
      musica: fields[0] as Musica,
      tomAtual: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MusicaEscala obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.musica)
      ..writeByte(1)
      ..write(obj.tomAtual);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MusicaEscalaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
