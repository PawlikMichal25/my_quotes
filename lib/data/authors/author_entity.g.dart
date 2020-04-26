// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AuthorEntityAdapter extends TypeAdapter<AuthorEntity> {
  @override
  final typeId = 0;

  @override
  AuthorEntity read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuthorEntity()
      ..firstName = fields[0] as String
      ..lastName = fields[1] as String;
  }

  @override
  void write(BinaryWriter writer, AuthorEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.firstName)
      ..writeByte(1)
      ..write(obj.lastName);
  }
}
