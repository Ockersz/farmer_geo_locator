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
      farmerId: fields[0] as int,
      fieldCode: fields[1] as String,
      farmerName: fields[2] as String,
      fieldName: fields[3] as String,
      hectares: fields[4] as String,
      noOfTrees: fields[5] as String,
      latitude: fields[6] as double,
      longitude: fields[7] as double,
      groupName: fields[8] as String,
      supplierName: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FarmerDetails obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.farmerId)
      ..writeByte(1)
      ..write(obj.fieldCode)
      ..writeByte(2)
      ..write(obj.farmerName)
      ..writeByte(3)
      ..write(obj.fieldName)
      ..writeByte(4)
      ..write(obj.hectares)
      ..writeByte(5)
      ..write(obj.noOfTrees)
      ..writeByte(6)
      ..write(obj.latitude)
      ..writeByte(7)
      ..write(obj.longitude)
      ..writeByte(8)
      ..write(obj.groupName)
      ..writeByte(9)
      ..write(obj.supplierName);
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
