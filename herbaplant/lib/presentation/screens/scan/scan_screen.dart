import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'camera_view.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Scan Plant'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.maingreen,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const CameraView(),
          ),
        ),
      ),
    );
  }
}
