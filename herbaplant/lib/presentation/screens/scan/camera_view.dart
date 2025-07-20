// camera_view.dart
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  FlashMode _flashMode = FlashMode.auto;
  double _zoomLevel = 1.0;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras!.isNotEmpty) {
      _controller = CameraController(
        _cameras![0],
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();
      await _controller!.setFlashMode(_flashMode);

      if (mounted) {
        setState(() {});
      }
    }
  }

  void _toggleFlashMode() {
    setState(() {
      if (_flashMode == FlashMode.auto) {
        _flashMode = FlashMode.always;
      } else if (_flashMode == FlashMode.always) {
        _flashMode = FlashMode.off;
      } else {
        _flashMode = FlashMode.auto;
      }
      _controller?.setFlashMode(_flashMode);
    });
  }

  IconData _getFlashIcon() {
    switch (_flashMode) {
      case FlashMode.auto:
        return Icons.flash_auto;
      case FlashMode.always:
        return Icons.flash_on;
      case FlashMode.off:
        return Icons.flash_off;
      default:
        return Icons.flash_auto;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CameraPreview(_controller!),
        ),

        // Flash button top right
        Positioned(
          top: 16,
          right: 16,
          child: IconButton(
            icon: Icon(_getFlashIcon(), color: Colors.white),
            onPressed: _toggleFlashMode,
          ),
        ),

        // Zoom slider bottom
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.maingreen,
              thumbColor: AppColors.maingreen,
            ),
            child: Slider(
              value: _zoomLevel,
              min: 1.0,
              max: 8.0,
              divisions: 14,
              label: 'Zoom: ${_zoomLevel.toStringAsFixed(1)}x',
              onChanged: (value) async {
                setState(() {
                  _zoomLevel = value;
                });
                await _controller!.setZoomLevel(value);
              },
            ),
          ),
        ),
      ],
    );
  }
}
