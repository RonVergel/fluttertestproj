import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'snap_image_view.dart';

class SendToSecurityDialog extends StatefulWidget {
  const SendToSecurityDialog({
    super.key,
    required this.imageBytes,
    required this.filePath,
  });

  final Uint8List? imageBytes;
  final String filePath;

  static const Color umRed = Color(0xFF902E2B);
  static const Color umYellow = Color(0xFFECB843);

  @override
  State<SendToSecurityDialog> createState() => _SendToSecurityDialogState();
}

class _SendToSecurityDialogState extends State<SendToSecurityDialog> {
  late final TextEditingController _idController;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
  }

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: SendToSecurityDialog.umRed, width: 2),
      ),
      backgroundColor: const Color(0xFF1E1E1E),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.shield_rounded,
                  color: SendToSecurityDialog.umYellow,
                  size: 26,
                ),
                SizedBox(width: 8),
                Text(
                  'UM Security Office',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Dress Code Violation Review',
              style: TextStyle(
                color: SendToSecurityDialog.umYellow,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * 0.38,
                ),
                child: SnapImageView(
                  filePath: widget.filePath,
                  imageBytes: widget.imageBytes,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _idController,
              autofocus: true,
              keyboardType: TextInputType.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                labelText: 'Student ID Number',
                labelStyle: const TextStyle(
                  color: SendToSecurityDialog.umYellow,
                  fontWeight: FontWeight.w500,
                ),
                hintText: 'Type ID number (e.g. 2024-12345)',
                hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                prefixIcon: const Icon(
                  Icons.badge_outlined,
                  color: SendToSecurityDialog.umYellow,
                ),
                filled: true,
                fillColor: Colors.black26,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: SendToSecurityDialog.umYellow,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white70,
                      side: const BorderSide(color: Colors.white24),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(null),
                    child: const Text('Retake'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: SendToSecurityDialog.umRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      final text = _idController.text.trim();
                      Navigator.of(context).pop(
                        text.isNotEmpty ? text : 'Unspecified ID',
                      );
                    },
                    icon: const Icon(Icons.send_rounded, size: 18),
                    label: const Text(
                      'SEND TO SECURITY OFFICE',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
