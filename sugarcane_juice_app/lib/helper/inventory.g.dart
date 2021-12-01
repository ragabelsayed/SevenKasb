// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../models/inventory.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InventoryAdapter extends TypeAdapter<Inventory> {
  @override
  final int typeId = 6;

  @override
  Inventory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Inventory(
      item: fields[0] as Item,
      cashItemHistory: (fields[2] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      inventoryType: fields[1] as InventoryType,
    );
  }

  @override
  void write(BinaryWriter writer, Inventory obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.item)
      ..writeByte(1)
      ..write(obj.inventoryType)
      ..writeByte(2)
      ..write(obj.cashItemHistory);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InventoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
