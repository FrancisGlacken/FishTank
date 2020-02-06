// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fish-data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FishDataAdapter extends TypeAdapter<FishData> {
  @override
  final typeId = 0;

  @override
  FishData read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FishData(
      id: fields[0] as int,
      name: fields[1] as String,
      hp: fields[2] as int,
      exp: fields[3] as int,
      type: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FishData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.hp)
      ..writeByte(3)
      ..write(obj.exp)
      ..writeByte(4)
      ..write(obj.type);
  }
}
