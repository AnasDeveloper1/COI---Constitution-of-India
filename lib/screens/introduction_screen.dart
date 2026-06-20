import 'package:constitutionofindia/screens/HomeScreen.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../widgets/primary_colors.dart';

import 'package:flutter/material.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final PageController pageController = PageController();

  int currentIndex = 0;

  final List<Map<String, String>> pages = [
    {
      "image": "assets/justice.png",
      "description":
          "Explore the Constitution of India with easy access to articles, schedules and amendments.",
    },
    {
      "image": "assets/order.png",
      "description":
          "Learn landmark constitutional cases and important legal decisions.",
    },
    {
      "image": "assets/law.png",
      "description":
          "Get constitutional news, notifications and updates anytime.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: pages.length,
                  onPageChanged: (value) {
                    setState(() {
                      currentIndex = value;
                    });
                  },
                  itemBuilder: (context, index) {
                    final item = pages[index];

                    return Center(
                      child: Hero(
                        tag: item["image"]!,
                        child: Image.asset(
                          item["image"]!,
                          height: double.infinity,
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.all(4),
                    width: currentIndex == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: currentIndex == index
                          ? AppColors.secondary
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              PrimaryButton(
                text: currentIndex == pages.length - 1 ? "Get Started" : "Next",
                onTap: () {
                  if (currentIndex == pages.length - 1) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HomeScreen(),
                      ),
                    );
                  } else {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  }
                },
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
