import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../../core/constants/app_colors.dart';
import '../../../presentation/screens/chatbot/chatbot_screen.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  FlashMode _flashMode = FlashMode.auto;
  double _currentZoom = 1.0;
  double _minZoom = 1.0;
  double _maxZoom = 5.0;

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
      _minZoom = await _controller!.getMinZoomLevel();
      _maxZoom = await _controller!.getMaxZoomLevel();

      if (mounted) setState(() {});
    }
  }

  void _toggleFlashMode() {
    setState(() {
      _flashMode = _flashMode == FlashMode.auto ? FlashMode.off : FlashMode.auto;
      _controller?.setFlashMode(_flashMode);
    });
  }

  IconData _getFlashIcon() {
    return _flashMode == FlashMode.auto ? Icons.flash_auto : Icons.flash_off;
  }

  Future<void> _takePictureAndNavigate() async {
  if (!(_controller?.value.isInitialized ?? false) || _controller!.value.isTakingPicture) return;

    try {
      await _controller!.setFocusMode(FocusMode.auto);
      await Future.delayed(const Duration(milliseconds: 300));

      final XFile xfile = await _controller!.takePicture();
      final File imageFile = File(xfile.path);

      // Add retry logic if image isn't immediately available
      bool isValid = false;
      int retryCount = 0;
      while (retryCount < 5) {
        isValid = await imageFile.exists() && (await imageFile.length()) > 0;
        if (isValid) break;
        await Future.delayed(const Duration(milliseconds: 100));
        retryCount++;
      }

      if (!isValid) {
        debugPrint("❌ Image capture failed: ${xfile.path}, size: ${await imageFile.length()}");
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Captured image is not valid. Please try again.")),
        );
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final savedPath = path.join(tempDir.path, path.basename(xfile.path));
      final savedImage = await imageFile.copy(savedPath);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatbotScreen(imageFile: savedImage),
        ),
      );
    } catch (e) {
      debugPrint("📷 Camera error: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Camera error: $e")),
      );
    }
  }


  Future<void> _pickFromGallery() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final imageFile = File(picked.path);
    final isValid = await imageFile.exists() && (await imageFile.length()) > 0;

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid image selected.")),
      );
      return;
    }

    final tempDir = await getTemporaryDirectory();
    final savedPath = path.join(tempDir.path, path.basename(picked.path));
    final savedImage = await imageFile.copy(savedPath);

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatbotScreen(imageFile: savedImage),
      ),
    );
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

    return GestureDetector(
      onTapDown: (details) {
        final offset = Offset(
          details.localPosition.dx,
          details.localPosition.dy,
        );
        _controller!.setFocusPoint(offset);
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 610,
              width: double.infinity,
              child: CameraPreview(_controller!),
            ),
          ),

          // Flash icon
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: Icon(_getFlashIcon(), color: Colors.white),
              onPressed: _toggleFlashMode,
            ),
          ),

          // Zoom slider
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            right: 8,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.20,
              child: RotatedBox(
                quarterTurns: 3,
                child: Slider(
                  activeColor: AppColors.primary,
                  inactiveColor: Colors.white54,
                  value: _currentZoom,
                  min: _minZoom,
                  max: _maxZoom,
                  onChanged: (value) async {
                    setState(() => _currentZoom = value);
                    await _controller!.setZoomLevel(_currentZoom);
                  },
                ),
              ),
            ),
          ),

          // Capture button
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: _takePictureAndNavigate,
              child: const Icon(Icons.camera_alt, color: Colors.black),
            ),
          ),

          // Gallery button
          Positioned(
            bottom: 16,
            left: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: _pickFromGallery,
              child: const Icon(Icons.photo_library, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
