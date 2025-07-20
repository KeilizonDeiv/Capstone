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
        title: const Text('Scan Plant'),
        backgroundColor: AppColors.maingreen,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Camera container
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 520,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.maingreen,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const CameraView(),
            ),

            const SizedBox(height: 24), // <- Spacing added

            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.photo_library, color: Colors.black),
                      onPressed: () {
                        // TODO: Open gallery
                      },
                    ),
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.black),
                      onPressed: () {
                        // TODO: Take photo logic
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
