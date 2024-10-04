// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CountryCodeDBAdapter extends TypeAdapter<CountryCodeDB> {
  @override
  final int typeId = 1;

  @override
  CountryCodeDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CountryCodeDB(
      questionBank: (fields[0] as List).cast<CountryHive>(),
    );
  }

  @override
  void write(BinaryWriter writer, CountryCodeDB obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.questionBank);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CountryCodeDBAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CountryHiveAdapter extends TypeAdapter<CountryHive> {
  @override
  final int typeId = 2;

  @override
  CountryHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CountryHive(
      commonName: fields[1] as String,
      officialName: fields[2] as String,
      currency: fields[3] as String,
      flag: fields[4] as String,
      region: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CountryHive obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.commonName)
      ..writeByte(2)
      ..write(obj.officialName)
      ..writeByte(3)
      ..write(obj.currency)
      ..writeByte(4)
      ..write(obj.flag)
      ..writeByte(5)
      ..write(obj.region);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CountryHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
