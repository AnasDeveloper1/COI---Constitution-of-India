import 'package:constitutionofindia/screens/notes_screen.dart';
import 'package:constitutionofindia/screens/splash_screen.dart';
import 'package:constitutionofindia/theme-manager/theme_manager.dart';
import 'package:flutter/material.dart';

// 1. CRITICAL: One single global instance that everything in your app shares
final ThemeManager themeManager = ThemeManager();

// 2. CRITICAL: The mandatory framework entrypoint method
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      // 3. FIXED: Listen to the shared global instance variable
      listenable: themeManager, 
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          title: 'Constitution App',
          debugShowCheckedModeBanner: false,
          
          // Day Theme configuration
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.light,
            ),
          ),
          
          // Night Theme configuration
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            ),
          ),
          
          // 4. FIXED: Read values dynamically from the same global variable instance
          themeMode: themeManager.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          
          home: const SplashScreen(), 
        );
      },
    );
  }
}