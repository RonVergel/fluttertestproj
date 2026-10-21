import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
      backgroundColor: StudentIdEntryScreen.umRed,
      appBar: AppBar(
        backgroundColor: StudentIdEntryScreen.umRed,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.shield_rounded,
              color: StudentIdEntryScreen.umYellow,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'UM Security Office',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                letterSpacing: 0.5,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withValues(alpha: 0.18),
                            border: Border.all(
                              color: StudentIdEntryScreen.umYellow,
                              width: 2.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.badge_rounded,
                            color: StudentIdEntryScreen.umYellow,
                            size: 44,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Dress Code Inspection',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'CAMPUS SECURITY CHECKPOINT',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: StudentIdEntryScreen.umYellow,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 36),
                      Text(
                        'Enter ID number',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '6-digit student ID number',
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _idController,
                        focusNode: _focusNode,
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 8,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        onSubmitted: (_) => _proceedToCamera(),
                        decoration: InputDecoration(
                          labelText: 'Enter ID number',
                          labelStyle: GoogleFonts.montserrat(
                            color: StudentIdEntryScreen.umYellow,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0,
                          ),
                          hintText: '000000',
                          hintStyle: GoogleFonts.montserrat(
                            color: Colors.white38,
                            fontSize: 28,
                            letterSpacing: 8,
                          ),
                          counterText: '${_idController.text.length}/6 digits',
                          counterStyle: GoogleFonts.montserrat(
                            color: isComplete
                                ? StudentIdEntryScreen.umYellow
                                : Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          errorText: _errorMessage,
                          errorStyle: GoogleFonts.montserrat(
                            color: StudentIdEntryScreen.umYellow,
                            fontWeight: FontWeight.w600,
                          ),
                          prefixIcon: const Icon(
                            Icons.pin_rounded,
                            color: StudentIdEntryScreen.umYellow,
                          ),
                          suffixIcon: hasInput
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.clear_rounded,
                                    color: Colors.white70,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    _idController.clear();
                                    _focusNode.requestFocus();
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: Colors.black.withValues(alpha: 0.22),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Colors.white.withValues(alpha: 0.35),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: StudentIdEntryScreen.umYellow,
                              width: 2.5,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: StudentIdEntryScreen.umYellow,
                              width: 2,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: StudentIdEntryScreen.umYellow,
                              width: 2.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: StudentIdEntryScreen.umYellow,
                          foregroundColor: const Color(0xFF1E1E1E),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: _proceedToCamera,
                        icon: const Icon(
                          Icons.camera_alt_rounded,
                          color: Color(0xFF1E1E1E),
                          size: 22,
                        ),
                        label: Text(
                          'PROCEED TO CAMERA',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            letterSpacing: 0.6,
                            color: const Color(0xFF1E1E1E),
                          ),
                        ),
                      ),
                      if (widget.repository.notes.isNotEmpty) ...[
                        const SizedBox(height: 36),
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
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
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
