// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataResponseAdapter extends TypeAdapter<DataResponse> {
  @override
  final int typeId = 1;

  @override
  DataResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataResponse(
      bank: fields[0] as String?,
      balance: fields[1] as String?,
      time: fields[2] as String?,
      content: fields[3] as String?,
      error: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DataResponse obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.bank)
      ..writeByte(1)
      ..write(obj.balance)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.error);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
