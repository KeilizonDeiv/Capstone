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
  static const int _maxRetryAttempts = 5;
  static const Duration _focusDelay = Duration(milliseconds: 300);
  static const Duration _retryDelay = Duration(milliseconds: 100);
  static const double _appBarHeight = 80.0;
  static const double _captureButtonSize = 70.0;

  CameraController? _controller;
  List<CameraDescription>? _cameras;
  FlashMode _flashMode = FlashMode.auto;
  double _currentZoom = 1.0;
  double _minZoom = 1.0;
  double _maxZoom = 5.0;
  bool _isInitialized = false;
  int _currentCameraIndex = 0;

  double _baseScale = 1.0;
  double _currentScale = 1.0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      
      if (_cameras?.isEmpty ?? true) {
        _showErrorSnackBar('No cameras available');
        return;
      }

      _controller = CameraController(
        _cameras![_currentCameraIndex],
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();
      await _setupCameraSettings();
      
      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
      _showErrorSnackBar('Failed to initialize camera');
    }
  }

  Future<void> _setupCameraSettings() async {
    if (_controller == null) return;

    await _controller!.setFlashMode(_flashMode);
    _minZoom = await _controller!.getMinZoomLevel();
    _maxZoom = await _controller!.getMaxZoomLevel();
    _currentZoom = _minZoom;
  }

  Future<void> _switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;

    setState(() => _isInitialized = false);
    
    await _controller?.dispose();
    
    _currentCameraIndex = (_currentCameraIndex + 1) % _cameras!.length;
    
    _controller = CameraController(
      _cameras![_currentCameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _controller!.initialize();
      await _setupCameraSettings();
      
      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      debugPrint('Camera switch error: $e');
      _showErrorSnackBar('Failed to switch camera');
    }
  }

  void _toggleFlashMode() {
    if (_controller == null) return;

    setState(() {
      switch (_flashMode) {
        case FlashMode.auto:
          _flashMode = FlashMode.always;
          break;
        case FlashMode.always:
          _flashMode = FlashMode.off;
          break;
        case FlashMode.off:
          _flashMode = FlashMode.auto;
          break;
        default:
          _flashMode = FlashMode.auto;
      }
    });
    
    _controller!.setFlashMode(_flashMode);
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

  void _setFocusPoint(TapDownDetails details) {
    if (_controller?.value.isInitialized != true) return;

    final offset = Offset(
      details.localPosition.dx,
      details.localPosition.dy,
    );
    _controller!.setFocusPoint(offset);
  }

  void _onScaleStart(ScaleStartDetails details) {
    _baseScale = _currentZoom;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (_controller?.value.isInitialized != true) return;

    _currentScale = (_baseScale * details.scale).clamp(_minZoom, _maxZoom);
    
    if (_currentScale != _currentZoom) {
      setState(() => _currentZoom = _currentScale);
      _controller!.setZoomLevel(_currentZoom);
    }
  }

  Future<void> _takePictureAndNavigate() async {
    if (!_canTakePicture()) return;

    try {
      final imageFile = await _capturePicture();
      if (imageFile != null) {
        await _navigateToChatbot(imageFile);
      }
    } catch (e) {
      debugPrint('Camera capture error: $e');
      _showErrorSnackBar('Failed to capture image: $e');
    }
  }

  bool _canTakePicture() {
    return _controller?.value.isInitialized == true && 
           !(_controller?.value.isTakingPicture ?? true);
  }

  Future<File?> _capturePicture() async {
    await _controller!.setFocusMode(FocusMode.auto);
    await Future.delayed(_focusDelay);
    
    final XFile xfile = await _controller!.takePicture();
    final File imageFile = File(xfile.path);
    
    if (await _validateImageWithRetry(imageFile)) {
      return await _saveImageToTemp(imageFile, xfile.path);
    } else {
      _showErrorSnackBar('Captured image is not valid. Please try again.');
      return null;
    }
  }

  Future<bool> _validateImageWithRetry(File imageFile) async {
    for (int i = 0; i < _maxRetryAttempts; i++) {
      final exists = await imageFile.exists();
      final size = exists ? await imageFile.length() : 0;
      
      if (exists && size > 0) {
        return true;
      }
      
      await Future.delayed(_retryDelay);
    }
    return false;
  }

  Future<File> _saveImageToTemp(File imageFile, String originalPath) async {
    final tempDir = await getTemporaryDirectory();
    final savedPath = path.join(tempDir.path, path.basename(originalPath));
    return await imageFile.copy(savedPath);
  }

  Future<void> _pickFromGallery() async {
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      
      if (picked == null) return;

      final imageFile = File(picked.path);
      
      if (await _validateImage(imageFile)) {
        final savedImage = await _saveImageToTemp(imageFile, picked.path);
        await _navigateToChatbot(savedImage);
      } else {
        _showErrorSnackBar('Invalid image selected.');
      }
    } catch (e) {
      debugPrint('Gallery picker error: $e');
      _showErrorSnackBar('Failed to pick image from gallery');
    }
  }

  Future<bool> _validateImage(File imageFile) async {
    final exists = await imageFile.exists();
    final size = exists ? await imageFile.length() : 0;
    return exists && size > 0;
  }

  Future<void> _navigateToChatbot(File imageFile) async {
    if (!mounted) return;
    
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatbotScreen(imageFile: imageFile),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isInitialized ? _buildCameraView() : _buildLoadingView(),
    );
  }

  Widget _buildLoadingView() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text(
              'Initializing camera...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraView() {
    return GestureDetector(
      onTapDown: _setFocusPoint,
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      child: Stack(
        children: [
          _buildCameraPreview(),
          _buildTopAppBar(),
          _buildCaptureButton(),
          _buildZoomIndicator(),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: CameraPreview(_controller!),
    );
  }

  Widget _buildTopAppBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: _appBarHeight + MediaQuery.of(context).padding.top,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTopBarButton(
                  icon: Icons.photo_library,
                  onPressed: _pickFromGallery,
                  tooltip: 'Gallery',
                ),
                _buildTopBarButton(
                  icon: _getFlashIcon(),
                  onPressed: _toggleFlashMode,
                  tooltip: 'Flash',
                ),
                _buildTopBarButton(
                  icon: Icons.flip_camera_ios,
                  onPressed: _cameras != null && _cameras!.length > 1 
                      ? _switchCamera 
                      : null,
                  tooltip: 'Switch Camera',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBarButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required String tooltip,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(25),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 24),
        onPressed: onPressed,
        tooltip: tooltip,
        splashRadius: 25,
      ),
    );
  }

  Widget _buildCaptureButton() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          onTap: _takePictureAndNavigate,
          child: Container(
            width: _captureButtonSize,
            height: _captureButtonSize,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey.shade300,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.camera_alt,
              color: Colors.black,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildZoomIndicator() {
    if (_currentZoom <= _minZoom) return const SizedBox.shrink();
    
    return Positioned(
      bottom: 120,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            '${_currentZoom.toStringAsFixed(1)}x',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}