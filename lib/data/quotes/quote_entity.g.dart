// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuoteEntityAdapter extends TypeAdapter<QuoteEntity> {
  @override
  final typeId = 1;

  @override
  QuoteEntity read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuoteEntity()
      ..authorKey = fields[0] as int
      ..content = fields[1] as String;
  }

  @override
  void write(BinaryWriter writer, QuoteEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.authorKey)
      ..writeByte(1)
      ..write(obj.content);
  }
}
