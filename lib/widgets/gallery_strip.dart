import 'package:flutter/material.dart';
import '../models/snap_note.dart';
import 'snap_image_view.dart';

class GalleryStrip extends StatelessWidget {
  const GalleryStrip({
    super.key,
    required this.notes,
    required this.onSelectNote,
  });

  final List<SnapNote> notes;
  final ValueChanged<SnapNote>? onSelectNote;

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 120,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: notes.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final note = notes[index];
          return GalleryItemCard(
            note: note,
            onTap: onSelectNote != null ? () => onSelectNote!(note) : null,
          );
        },
      ),
    );
  }
}

class GalleryEmptyState extends StatelessWidget {
  const GalleryEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.photo_library_outlined, size: 36, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              'No snapshots yet. Tap capture above!',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class GalleryItemCard extends StatelessWidget {
  const GalleryItemCard({
    super.key,
    required this.note,
    required this.onTap,
  });

  final SnapNote note;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24),
          color: Colors.black26,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            SnapImageView(
              filePath: note.filePath,
              imageBytes: note.imageBytes,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                color: Colors.black54,
                child: Text(
                  note.formattedTime,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

