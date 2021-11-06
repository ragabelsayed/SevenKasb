// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../models/extra_expenses.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExtraAdapter extends TypeAdapter<Extra> {
  @override
  final int typeId = 5;

  @override
  Extra read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Extra(
      id: fields[0] as int?,
      user: fields[1] as User,
      reason: fields[2] as String,
      cash: fields[3] as double,
      dataTime: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Extra obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.user)
      ..writeByte(2)
      ..write(obj.reason)
      ..writeByte(3)
      ..write(obj.cash)
      ..writeByte(4)
      ..write(obj.dataTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExtraAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
