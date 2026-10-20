import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraViewfinder extends StatelessWidget {
  const CameraViewfinder({
    super.key,
    required this.controller,
    required this.isInitialized,
    required this.isCapturing,
    required this.onCapture,
    required this.onSwitchCamera,
    required this.onToggleFlash,
    required this.currentFlashMode,
    this.isFlashSupported = false,
    this.canSwitchCamera = false,
    this.onRefresh,
    this.activeStudentId = '',
    this.onTapStudentId,
    this.errorMessage,
  });

  final CameraController? controller;
  final bool isInitialized;
  final bool isCapturing;
  final VoidCallback onCapture;
  final VoidCallback onSwitchCamera;
  final VoidCallback onToggleFlash;
  final VoidCallback? onRefresh;
  final String activeStudentId;
  final VoidCallback? onTapStudentId;
  final FlashMode currentFlashMode;
  final bool isFlashSupported;
  final bool canSwitchCamera;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (isInitialized && controller != null)
            FullBleedCameraPreview(controller: controller!)
          else
            CameraPlaceholderView(message: errorMessage),
          if (onRefresh != null)
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white, size: 20),
                  onPressed: onRefresh,
                  tooltip: 'Reinitialize Camera',
                ),
              ),
            ),
          Positioned(
            top: 16,
            left: onRefresh != null ? 68 : 16,
            right: isFlashSupported ? 68 : 16,
            child: ActiveStudentIdBadge(
              studentId: activeStudentId,
              onTap: onTapStudentId,
            ),
          ),
          if (isFlashSupported)
            Positioned(
              top: 16,
              right: 16,
              child: FlashModeButton(
                flashMode: currentFlashMode,
                onPressed: isInitialized ? onToggleFlash : null,
              ),
            ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: CameraControlsBar(
              isCapturing: isCapturing,
              isEnabled: isInitialized,
              canSwitchCamera: canSwitchCamera,
              onCapture: onCapture,
              onSwitchCamera: onSwitchCamera,
            ),
          ),
        ],
      ),
    );
  }
}

class FullBleedCameraPreview extends StatelessWidget {
  const FullBleedCameraPreview({
    super.key,
    required this.controller,
  });

  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final aspectRatio = controller.value.aspectRatio;

        if (aspectRatio <= 0) {
          return const Center(child: CircularProgressIndicator());
        }

        final double previewWidth = size.width;
        final double previewHeight = size.width / aspectRatio;

        final double scaleX = size.width / previewWidth;
        final double scaleY = size.height / previewHeight;
        final double scale = scaleX > scaleY ? scaleX : scaleY;

        return ClipRect(
          child: Transform.scale(
            scale: scale,
            child: Center(
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: CameraPreview(controller),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CameraPlaceholderView extends StatelessWidget {
  const CameraPlaceholderView({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.camera_alt_outlined,
              size: 56,
              color: Colors.white38,
            ),
            const SizedBox(height: 12),
            Text(
              message ?? 'Initializing camera hardware...',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class FlashModeButton extends StatelessWidget {
  const FlashModeButton({
    super.key,
    required this.flashMode,
    required this.onPressed,
  });

  final FlashMode flashMode;
  final VoidCallback? onPressed;

  IconData _iconForMode(FlashMode mode) {
    switch (mode) {
      case FlashMode.off:
        return Icons.flash_off;
      case FlashMode.auto:
        return Icons.flash_auto;
      case FlashMode.always:
      case FlashMode.torch:
        return Icons.flash_on;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black45,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(_iconForMode(flashMode), color: Colors.white, size: 20),
        onPressed: onPressed,
        tooltip: 'Flash Mode',
      ),
    );
  }
}

class CameraControlsBar extends StatelessWidget {
  const CameraControlsBar({
    super.key,
    required this.isCapturing,
    required this.isEnabled,
    required this.canSwitchCamera,
    required this.onCapture,
    required this.onSwitchCamera,
  });

  final bool isCapturing;
  final bool isEnabled;
  final bool canSwitchCamera;
  final VoidCallback onCapture;
  final VoidCallback onSwitchCamera;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: canSwitchCamera
          ? MainAxisAlignment.spaceEvenly
          : MainAxisAlignment.center,
      children: [
        if (canSwitchCamera) const SizedBox(width: 48),
        ShutterButton(
          isCapturing: isCapturing,
          isEnabled: isEnabled,
          onPressed: onCapture,
        ),
        if (canSwitchCamera)
          Container(
            decoration: const BoxDecoration(
              color: Colors.black45,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.flip_camera_ios, color: Colors.white, size: 22),
              onPressed: isEnabled ? onSwitchCamera : null,
              tooltip: 'Switch Lens',
            ),
          ),
      ],
    );
  }
}

class ShutterButton extends StatelessWidget {
  const ShutterButton({
    super.key,
    required this.isCapturing,
    required this.isEnabled,
    required this.onPressed,
  });

  final bool isCapturing;
  final bool isEnabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (isEnabled && !isCapturing) ? onPressed : null,
      child: Container(
        height: 72,
        width: 72,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isEnabled ? const Color(0xFFECB843) : Colors.white38,
            width: 4,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCapturing
                ? const Color(0xFF902E2B)
                : (isEnabled ? Colors.white : Colors.white24),
          ),
          child: isCapturing
              ? const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

class ActiveStudentIdBadge extends StatelessWidget {
  const ActiveStudentIdBadge({
    super.key,
    required this.studentId,
    required this.onTap,
  });

  final String studentId;
  final VoidCallback? onTap;

  static const Color umRed = Color(0xFF902E2B);
  static const Color umYellow = Color(0xFFECB843);

  @override
  Widget build(BuildContext context) {
    final hasId = studentId.isNotEmpty;

    return Center(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: hasId ? umRed.withValues(alpha: 0.85) : Colors.black54,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: umYellow,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                hasId ? Icons.badge_outlined : Icons.add_circle_outline,
                color: umYellow,
                size: 18,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  hasId ? 'ID: $studentId' : 'Tap to enter Student ID',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (hasId) ...[
                const SizedBox(width: 6),
                const Icon(Icons.edit, color: Colors.white70, size: 14),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

