import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../models/snap_note.dart';
import '../services/snap_repository.dart';
import '../widgets/camera_viewfinder.dart';
import '../widgets/gallery_strip.dart';
import '../widgets/note_detail_dialog.dart';

class CameraHomeScreen extends StatefulWidget {
  const CameraHomeScreen({
    super.key,
    required this.repository,
  });

  final SnapRepository repository;

  @override
  State<CameraHomeScreen> createState() => _CameraHomeScreenState();
}

class _CameraHomeScreenState extends State<CameraHomeScreen>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription> _availableCameras = [];
  int _selectedCameraIndex = 0;
  bool _isInitialized = false;
  bool _isCapturing = false;
  bool _isFlashSupported = false;
  FlashMode _flashMode = FlashMode.auto;
  DateTime? _lastCaptureTime;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initSelectedCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (!mounted) return;

      if (cameras.isEmpty) {
        setState(() {
          _errorMessage = 'No camera hardware found on this device.';
        });
        return;
      }

      setState(() {
        _availableCameras = cameras;
      });

      await _initSelectedCamera();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Camera initialization failed: $e';
      });
    }
  }

  Future<void> _initSelectedCamera() async {
    if (_availableCameras.isEmpty) return;

    final previousController = _cameraController;
    final camera = _availableCameras[_selectedCameraIndex];

    final newController = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await previousController?.dispose();

    if (!mounted) {
      await newController.dispose();
      return;
    }

    try {
      await newController.initialize();
      bool flashSupported = false;
      try {
        await newController.setFlashMode(_flashMode);
        flashSupported = true;
      } catch (_) {
        flashSupported = false;
        try {
          await newController.setFlashMode(FlashMode.off);
        } catch (_) {}
      }

      if (!mounted) {
        await newController.dispose();
        return;
      }

      setState(() {
        _cameraController = newController;
        _isInitialized = true;
        _isFlashSupported = flashSupported;
        if (!flashSupported) {
          _flashMode = FlashMode.off;
        }
        _errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isInitialized = false;
        _errorMessage = 'Failed to activate camera: $e';
      });
    }
  }

  Future<void> _capturePhoto() async {
    final controller = _cameraController;
    final now = DateTime.now();

    if (controller == null ||
        !controller.value.isInitialized ||
        _isCapturing ||
        controller.value.isTakingPicture) {
      return;
    }

    if (_lastCaptureTime != null &&
        now.difference(_lastCaptureTime!) < const Duration(milliseconds: 700)) {
      return;
    }

    _lastCaptureTime = now;
    _isCapturing = true;
    setState(() {});

    try {
      final file = await controller.takePicture();
      if (!mounted) return;

      final bytes = await file.readAsBytes();
      if (!mounted) return;

      final newNote = SnapNote(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        filePath: file.path,
        imageBytes: bytes,
        timestamp: DateTime.now(),
      );

      await widget.repository.addNote(newNote);
      if (!mounted) return;

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Snap captured and saved to database!'),
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      if (e is CameraException &&
          (e.code == 'Previous capture has not returned yet.' ||
              e.description?.contains('takePicture was called before') == true)) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Capture failed: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
      }
    }
  }

  Future<void> _switchCamera() async {
    if (_availableCameras.length < 2) return;

    setState(() {
      _selectedCameraIndex =
          (_selectedCameraIndex + 1) % _availableCameras.length;
    });

    await _initSelectedCamera();
  }

  Future<void> _toggleFlash() async {
    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) return;

    final nextMode = switch (_flashMode) {
      FlashMode.off => FlashMode.auto,
      FlashMode.auto => FlashMode.always,
      FlashMode.always => FlashMode.off,
      FlashMode.torch => FlashMode.off,
    };

    try {
      await controller.setFlashMode(nextMode);
      if (!mounted) return;
      setState(() {
        _flashMode = nextMode;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Flash is not supported on this camera.'),
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Snap & Gallery Note',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reinitialize Camera',
            onPressed: _initializeCamera,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: CameraViewfinder(
                  controller: _cameraController,
                  isInitialized: _isInitialized,
                  isCapturing: _isCapturing,
                  isFlashSupported: _isFlashSupported,
                  canSwitchCamera: _availableCameras.length > 1,
                  onCapture: _capturePhoto,
                  onSwitchCamera: _switchCamera,
                  onToggleFlash: _toggleFlash,
                  currentFlashMode: _flashMode,
                  errorMessage: _errorMessage,
                ),
              ),
            ),
            const Divider(height: 1),
            GalleryStrip(
              notes: widget.repository.notes,
              onSelectNote: _showNoteDetails,
            ),
          ],
        ),
      ),
    );
  }
}

