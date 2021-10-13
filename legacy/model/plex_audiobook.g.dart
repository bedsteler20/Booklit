// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plex_audiobook.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AudioBookAdapter extends TypeAdapter<AudioBook> {
  @override
  final int typeId = 5;

  @override
  AudioBook read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AudioBook(
      userRating: fields[0] as double,
      key: fields[7] as int,
      title: fields[1] as String,
      year: fields[2] as int,
      author: fields[5] as String,
      summary: fields[4] as String,
      thumb: fields[3] as String,
      hasEnbededChapters: fields[6] as bool,
      chapters: (fields[8] as List).cast<PlexChapter>(),
    );
  }

  @override
  void write(BinaryWriter writer, AudioBook obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.userRating)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.year)
      ..writeByte(3)
      ..write(obj.thumb)
      ..writeByte(4)
      ..write(obj.summary)
      ..writeByte(5)
      ..write(obj.author)
      ..writeByte(6)
      ..write(obj.hasEnbededChapters)
      ..writeByte(7)
      ..write(obj.key)
      ..writeByte(8)
      ..write(obj.chapters);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioBookAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
