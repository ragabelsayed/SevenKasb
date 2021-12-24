// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../models/bill_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BillItemsAdapter extends TypeAdapter<BillItems> {
  @override
  final int typeId = 1;

  @override
  BillItems read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BillItems(
      price: fields[0] as double,
      quentity: fields[1] as double,
      item: fields[2] as Item,
    );
  }

  @override
  void write(BinaryWriter writer, BillItems obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.price)
      ..writeByte(1)
      ..write(obj.quentity)
      ..writeByte(2)
      ..write(obj.item);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BillItemsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
