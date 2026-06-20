import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const HomeCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Get the active theme context colors
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // FIXED: Uses surfaceContainerLow in Dark Mode (sleek slate) and White in Light Mode
          color: isDark ? theme.colorScheme.surfaceContainerLow : Colors.white,
          boxShadow: [
            BoxShadow(
              // Softer shadow adjustment for dark mode surfaces
              color: isDark ? Colors.black.withValues() : Colors.grey.withValues(),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 38,
                // FIXED: Uses your original primary dark blue color in Light Mode, 
                // but changes to an accessible lighter blue in Dark Mode so it pops!
                color: isDark ? theme.colorScheme.primary : const Color(0xff1E3A8A),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  // FIXED: Automatically flips to White in dark mode and Black/Charcoal in light mode
                  color: theme.colorScheme.onSurface, 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}