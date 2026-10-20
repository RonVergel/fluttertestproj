import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SnapImageView extends StatelessWidget {
  const SnapImageView({
    super.key,
    required this.filePath,
    this.imageBytes,
    this.fit = BoxFit.cover,
  });

  final String filePath;
  final Uint8List? imageBytes;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (imageBytes != null && imageBytes!.isNotEmpty) {
      return Image.memory(
        imageBytes!,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(Icons.broken_image, color: Colors.white38),
        ),
      );
    }

    if (kIsWeb) {
      if (filePath.isEmpty) {
        return const Center(
          child: Icon(Icons.broken_image, color: Colors.white38),
        );
      }
      return Image.network(
        filePath,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(Icons.broken_image, color: Colors.white38),
        ),
      );
    }

    final file = File(filePath);
    if (filePath.isEmpty || !file.existsSync()) {
      return const Center(
        child: Icon(Icons.broken_image, color: Colors.white38),
      );
    }

    return Image.file(
      file,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => const Center(
        child: Icon(Icons.broken_image, color: Colors.white38),
      ),
    );
  }
}
