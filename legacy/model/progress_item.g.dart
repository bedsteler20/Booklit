// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProgressItemAdapter extends TypeAdapter<ProgressItem> {
  @override
  final int typeId = 6;

  @override
  ProgressItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProgressItem(
      index: fields[1] as int,
      progress: fields[2] as int,
      synced: fields[3] as bool,
      key: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ProgressItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.index)
      ..writeByte(2)
      ..write(obj.progress)
      ..writeByte(3)
      ..write(obj.synced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgressItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
