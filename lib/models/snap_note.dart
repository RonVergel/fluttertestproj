import 'package:flutter/foundation.dart';

@immutable
class SnapNote {
  const SnapNote({
    required this.id,
    required this.filePath,
    required this.timestamp,
    this.caption = '',
  });

  final String id;
  final String filePath;
  final DateTime timestamp;
  final String caption;

  String get formattedTime {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final second = timestamp.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SnapNote &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          filePath == other.filePath &&
          timestamp == other.timestamp &&
          caption == other.caption;

  @override
  int get hashCode => Object.hash(id, filePath, timestamp, caption);
}

