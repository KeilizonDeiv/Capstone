import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ScanLoadingScreen extends StatefulWidget {
  final File imageFile;
  final VoidCallback onScanComplete;

  const ScanLoadingScreen({
    required this.imageFile,
    required this.onScanComplete,
  });

  @override
  State<ScanLoadingScreen> createState() => _ScanLoadingScreenState();
}

class _ScanLoadingScreenState extends State<ScanLoadingScreen> {
  @override
  void initState() {
    super.initState();
    _simulateScan();
  }

  Future<void> _simulateScan() async {
    await Future.delayed(const Duration(seconds: 3));
    widget.onScanComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(widget.imageFile, height: 150),
            const SizedBox(height: 24),
            const Text(
              'Scanning...',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
