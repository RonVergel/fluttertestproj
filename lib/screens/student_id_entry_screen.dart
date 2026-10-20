import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/snap_note.dart';
import '../services/snap_repository.dart';
import '../widgets/gallery_strip.dart';
import '../widgets/note_detail_dialog.dart';
import 'camera_home_screen.dart';

class StudentIdEntryScreen extends StatefulWidget {
  const StudentIdEntryScreen({
    super.key,
    required this.repository,
  });

  final SnapRepository repository;

  static const Color umRed = Color(0xFF902E2B);
  static const Color umYellow = Color(0xFFECB843);

  @override
  State<StudentIdEntryScreen> createState() => _StudentIdEntryScreenState();
}

class _StudentIdEntryScreenState extends State<StudentIdEntryScreen> {
  final TextEditingController _idController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _idController.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    _idController.removeListener(_handleTextChange);
    _idController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleTextChange() {
    if (_errorMessage != null && _idController.text.length == 6) {
      setState(() {
        _errorMessage = null;
      });
    } else {
      setState(() {});
    }
  }

  Future<void> _proceedToCamera() async {
    final id = _idController.text.trim();
    if (id.length != 6) {
      setState(() {
        _errorMessage = 'Please enter a 6-digit ID number';
      });
      _focusNode.requestFocus();
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => CameraHomeScreen(
          repository: widget.repository,
          studentId: id,
        ),
      ),
    );

    if (mounted) {
      _idController.clear();
      _focusNode.requestFocus();
      setState(() {});
    }
  }

  void _showNoteDetails(SnapNote note) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return NoteDetailDialog(
          note: note,
          onDelete: () async {
            await widget.repository.deleteNote(note.id);
            if (mounted) {
              setState(() {});
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasInput = _idController.text.isNotEmpty;
    final isComplete = _idController.text.length == 6;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: StudentIdEntryScreen.umRed,
        elevation: 2,
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shield_rounded,
              color: StudentIdEntryScreen.umYellow,
              size: 22,
            ),
            SizedBox(width: 8),
            Text(
              'UM Security Office',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),
                      Center(
                        child: Container(
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: StudentIdEntryScreen.umRed.withValues(alpha: 0.2),
                            border: Border.all(
                              color: StudentIdEntryScreen.umYellow,
                              width: 2.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.badge_rounded,
                            color: StudentIdEntryScreen.umYellow,
                            size: 46,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Dress Code Inspection',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Security Office Violation Logger',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: StudentIdEntryScreen.umYellow,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isComplete
                                ? StudentIdEntryScreen.umYellow
                                : StudentIdEntryScreen.umRed.withValues(alpha: 0.6),
                            width: 1.8,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black45,
                              blurRadius: 16,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Enter ID number',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Please input the 6-digit student ID before taking a picture.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white60,
                              ),
                            ),
                            const SizedBox(height: 18),
                            TextField(
                              controller: _idController,
                              focusNode: _focusNode,
                              autofocus: true,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 6,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(6),
                              ],
                              onSubmitted: (_) => _proceedToCamera(),
                              decoration: InputDecoration(
                                labelText: 'Enter ID number',
                                labelStyle: const TextStyle(
                                  color: StudentIdEntryScreen.umYellow,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0,
                                ),
                                hintText: '000000',
                                hintStyle: const TextStyle(
                                  color: Colors.white24,
                                  fontSize: 24,
                                  letterSpacing: 6,
                                ),
                                counterText: '${_idController.text.length}/6 digits',
                                counterStyle: TextStyle(
                                  color: isComplete
                                      ? StudentIdEntryScreen.umYellow
                                      : Colors.white38,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                                errorText: _errorMessage,
                                prefixIcon: const Icon(
                                  Icons.pin_rounded,
                                  color: StudentIdEntryScreen.umYellow,
                                ),
                                suffixIcon: hasInput
                                    ? IconButton(
                                        icon: const Icon(
                                          Icons.clear_rounded,
                                          color: Colors.white60,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          _idController.clear();
                                          _focusNode.requestFocus();
                                        },
                                      )
                                    : null,
                                filled: true,
                                fillColor: Colors.black26,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: Colors.white24,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: StudentIdEntryScreen.umYellow,
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.error,
                                    width: 1.5,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.error,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 22),
                            FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: StudentIdEntryScreen.umRed,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  side: isComplete
                                      ? const BorderSide(
                                          color: StudentIdEntryScreen.umYellow,
                                          width: 1.5,
                                        )
                                      : BorderSide.none,
                                ),
                              ),
                              onPressed: _proceedToCamera,
                              icon: const Icon(
                                Icons.camera_alt_rounded,
                                color: StudentIdEntryScreen.umYellow,
                                size: 22,
                              ),
                              label: const Text(
                                'PROCEED TO CAMERA',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.repository.notes.isNotEmpty) ...[
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            const Icon(
                              Icons.history_rounded,
                              color: StudentIdEntryScreen.umYellow,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Recent Shift Reports (${widget.repository.notes.length})',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        GalleryStrip(
                          notes: widget.repository.notes,
                          onSelectNote: _showNoteDetails,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
