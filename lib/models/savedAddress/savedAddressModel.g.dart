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
      id: fields[0] as String?,
      type: fields[1] as AddressType?,
      placeId: fields[2] as String?,
      location: fields[3] as LnModel?,
      locationName: fields[4] as String?,
      addrComponent: (fields[6] as List?)?.cast<AddrComponent>(),
      detail: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SavedAddressModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.placeId)
      ..writeByte(3)
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.locationName)
      ..writeByte(5)
      ..write(obj.detail)
      ..writeByte(6)
      ..write(obj.addrComponent);
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

class LnModelAdapter extends TypeAdapter<LnModel> {
  @override
  final int typeId = 3;

  @override
  LnModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LnModel(
      lat: fields[0] as double,
      lng: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, LnModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.lat)
      ..writeByte(1)
      ..write(obj.lng);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LnModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AddrComponentAdapter extends TypeAdapter<AddrComponent> {
  @override
  final int typeId = 4;

  @override
  AddrComponent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddrComponent(
      (fields[0] as List).cast<String>(),
      fields[1] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AddrComponent obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.types)
      ..writeByte(1)
      ..write(obj.longName)
      ..writeByte(2)
      ..write(obj.shortName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddrComponentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
