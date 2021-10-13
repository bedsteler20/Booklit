import 'package:hive_flutter/adapters.dart';

part 'progress_item.g.dart';

/// Stores the progress of a audiobook
@HiveType(typeId: 6)
class ProgressItem {
  
  @HiveField(0)
  final String key;
  @HiveField(1)
  final int index;
  @HiveField(2)
  final int progress;

  @HiveField(3)

  ///Wether or not the progress of this item has been synced with PMS
  final bool synced;
  ProgressItem({required this.index, required this.progress, required this.synced,required this.key});
}
