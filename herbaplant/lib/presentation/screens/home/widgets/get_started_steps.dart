import 'package:flutter/material.dart';
import 'package:herbaplant/core/constants/app_colors.dart';

class GetStartedSteps extends StatelessWidget {
  const GetStartedSteps({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> descriptions = [
      'Learn how to take a clear photo for identification.',
      'Understand how to analyze the results effectively.',
      'Discover additional information about herbs.',
      'Save your identification history for future reference.',
      'Explore expert tips on herbal plant usage.',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Get Started',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16.0),
            itemCount: 5,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {},
                child: Container(
                  width: 250,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: AppColors.maingreen,
                    borderRadius: BorderRadius.circular(10),
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
                      Text(
                        'Step ${index + 1}',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          descriptions[index],
                          textAlign: TextAlign.center,
                          style:
                              const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 12),
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
