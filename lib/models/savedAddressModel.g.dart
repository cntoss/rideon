// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savedAddressModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedAddressModelAdapter extends TypeAdapter<SavedAddressModel> {
  @override
  final int typeId = 1;

  @override
  SavedAddressModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedAddressModel(
      type: fields[1] as String,
      location: fields[2] as dynamic,
      locationName: fields[3] as String,
    )..id = fields[0] as int;
  }

  @override
  void write(BinaryWriter writer, SavedAddressModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.location)
      ..writeByte(3)
      ..write(obj.locationName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedAddressModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
