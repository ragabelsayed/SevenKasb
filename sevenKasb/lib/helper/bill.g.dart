// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../models/bill.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BillAdapter extends TypeAdapter<Bill> {
  @override
  final int typeId = 0;

  @override
  Bill read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bill(
      id: fields[0] as int?,
      type: fields[7] as int,
      user: fields[1] as User,
      total: fields[2] as double,
      paid: fields[3] as double,
      clientName: fields[4] as String,
      dateTime: fields[5] as DateTime,
      billItems: (fields[6] as List).cast<BillItems>(),
      offlineBillItems: (fields[8] as HiveList?)?.castHiveList(),
    );
  }

  @override
  void write(BinaryWriter writer, Bill obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.user)
      ..writeByte(2)
      ..write(obj.total)
      ..writeByte(3)
      ..write(obj.paid)
      ..writeByte(4)
      ..write(obj.clientName)
      ..writeByte(5)
      ..write(obj.dateTime)
      ..writeByte(6)
      ..write(obj.billItems)
      ..writeByte(7)
      ..write(obj.type)
      ..writeByte(8)
      ..write(obj.offlineBillItems);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BillAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
