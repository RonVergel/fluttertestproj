import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StudentIdInputDialog extends StatefulWidget {
  const StudentIdInputDialog({
    super.key,
    this.initialId = '',
  });

  final String initialId;

  static const Color umRed = Color(0xFF902E2B);
  static const Color umYellow = Color(0xFFECB843);

  @override
  State<StudentIdInputDialog> createState() => _StudentIdInputDialogState();
}

class _StudentIdInputDialogState extends State<StudentIdInputDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.length == 6) {
      Navigator.of(context).pop(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: StudentIdInputDialog.umRed, width: 2),
      ),
      backgroundColor: const Color(0xFF1E1E1E),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.shield_rounded,
                  color: StudentIdInputDialog.umYellow,
                  size: 26,
                ),
                SizedBox(width: 8),
                Text(
                  'UM Security Office',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Enter ID number',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Please enter the 6-digit student ID number.',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
              onSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                labelText: 'Enter ID number',
                labelStyle: const TextStyle(
                  color: StudentIdInputDialog.umYellow,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                ),
                hintText: '000000',
                hintStyle: const TextStyle(
                  color: Colors.white38,
                  fontSize: 18,
                  letterSpacing: 4,
                ),
                prefixIcon: const Icon(
                  Icons.badge_outlined,
                  color: StudentIdInputDialog.umYellow,
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
                    color: StudentIdInputDialog.umYellow,
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
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: StudentIdInputDialog.umRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _submit,
                    icon: const Icon(Icons.camera_alt_outlined, size: 18),
                    label: const Text(
                      'PROCEED TO CAMERA',
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

