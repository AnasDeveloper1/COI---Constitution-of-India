import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'introduction_screen.dart';
import 'HomeScreen.dart'; // Make sure this path is correct for your project

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    // Keep the splash screen visible for 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    // Check SharedPreferences to see if the intro was already seen
    final prefs = await SharedPreferences.getInstance();
    final bool hasSeenIntro = prefs.getBool('has_seen_intro') ?? false;

    if (mounted) {
      if (hasSeenIntro) {
        // If they have seen it, go straight to HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
        );
      } else {
        // If it's their first time, show the IntroductionScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const IntroductionScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/splash.jpg",
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
