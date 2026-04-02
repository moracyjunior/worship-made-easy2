// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'escala.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EscalaAdapter extends TypeAdapter<Escala> {
  @override
  final int typeId = 2;

  @override
  Escala read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Escala(
      data: fields[0] as String,
      horario: fields[1] as String,
      musicos: (fields[2] as List?)?.cast<Musico>(),
      setlist: (fields[3] as List?)?.cast<MusicaEscala>(),
    );
  }

  @override
  void write(BinaryWriter writer, Escala obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.data)
      ..writeByte(1)
      ..write(obj.horario)
      ..writeByte(2)
      ..write(obj.musicos)
      ..writeByte(3)
      ..write(obj.setlist);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EscalaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
