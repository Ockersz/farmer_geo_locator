// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmer_details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FarmerDetailsAdapter extends TypeAdapter<FarmerDetails> {
  @override
  final int typeId = 0;

  @override
  FarmerDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FarmerDetails(
      name: fields[0] as String,
      id: fields[1] as String,
      nic: fields[2] as String,
      csCode: fields[3] as String,
      latitude: fields[4] as double,
      longitude: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, FarmerDetails obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.nic)
      ..writeByte(3)
      ..write(obj.csCode)
      ..writeByte(4)
      ..write(obj.latitude)
      ..writeByte(5)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FarmerDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
