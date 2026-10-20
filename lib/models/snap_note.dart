import 'package:flutter/foundation.dart';

@immutable
class SnapNote {
  const SnapNote({
    required this.id,
    required this.timestamp,
    this.filePath = '',
    this.imageBytes,
    this.caption = '',
  });

  final String id;
  final String filePath;
  final Uint8List? imageBytes;
  final DateTime timestamp;
  final String caption;

  String get formattedTime {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final second = timestamp.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'filePath': filePath,
      'imageBytes': imageBytes,
      'timestamp': timestamp.toIso8601String(),
      'caption': caption,
    };
  }

  factory SnapNote.fromMap(Map<dynamic, dynamic> map) {
    final rawBytes = map['imageBytes'];
    Uint8List? bytes;
    if (rawBytes is Uint8List) {
      bytes = rawBytes;
    } else if (rawBytes is List) {
      bytes = Uint8List.fromList(List<int>.from(rawBytes));
    }

    return SnapNote(
      id: map['id'] as String? ?? '',
      filePath: map['filePath'] as String? ?? '',
      imageBytes: bytes,
      timestamp: DateTime.tryParse(map['timestamp'] as String? ?? '') ??
          DateTime.now(),
      caption: map['caption'] as String? ?? '',
    );
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
