// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contato_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContatoAdapter extends TypeAdapter<Contato> {
  @override
  final int typeId = 0;

  @override
  Contato read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Contato(
      nome: fields[0] as String,
      telefone: fields[1] as String,
      imgPath: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Contato obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.nome)
      ..writeByte(1)
      ..write(obj.telefone)
      ..writeByte(2)
      ..write(obj.imgPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContatoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
