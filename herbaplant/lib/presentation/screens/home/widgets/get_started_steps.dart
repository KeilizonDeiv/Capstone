import 'package:flutter/material.dart';
import 'package:herbaplant/core/constants/app_colors.dart';

class GetStartedSteps extends StatelessWidget {
  const GetStartedSteps({super.key});

  @override
  Widget build(BuildContext context) {
    String step1 = 'Learn how to take a clear photo for identification.';
    String step2 = 'Understand how to analyze the results effectively.';
    String step3 = 'Discover additional information about herbs.';
    String step4 = 'Save your identification history for future reference.';
    String step5 = 'Explore expert tips on herbal plant usage.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
          child: Row(
            children: [
              Icon(Icons.touch_app, color: Color(0xFF0C553B)),
              SizedBox(width: 8),
              Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16.0),
            itemCount: 5,
            itemBuilder: (context, index) {
              String description = '';
              IconData icon = Icons.check_circle;

              switch (index) {
                case 0:
                  description = step1;
                  icon = Icons.photo_camera;
                  break;
                case 1:
                  description = step2;
                  icon = Icons.psychology_alt;
                  break;
                case 2:
                  description = step3;
                  icon = Icons.search;
                  break;
                case 3:
                  description = step4;
                  icon = Icons.history;
                  break;
                case 4:
                  description = step5;
                  icon = Icons.explore;
                  break;
              }

              return GestureDetector(
                onTap: () {},
                child: Container(
                  width: 250,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0C553B),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/image/Getstart${index + 1}.png',
                            width: 250,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(icon, color: Colors.white, size: 50),
                            const SizedBox(width: 6),
                            Container(
                              width: 1,
                              height: 40,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 6.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Step ${index + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      description,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
