import 'package:constitutionofindia/screen_articles/amendment_screen.dart';
import 'package:constitutionofindia/screen_articles/casestudy_screen.dart';
import 'package:constitutionofindia/screen_articles/news_screen.dart';
import 'package:constitutionofindia/screen_articles/parts_screen.dart';
import 'package:constitutionofindia/screen_articles/preamble_screen.dart';
import 'package:constitutionofindia/screen_articles/schedule_screen.dart';
import 'package:constitutionofindia/screens/bookmark_screen.dart';
import 'package:constitutionofindia/screens/notes_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for closing the app via SystemNavigator.pop

import 'home_card.dart';
import '../main.dart'; 
import 'bookmark_share_helper.dart'; // Required to communicate with your storage methods

// Clean constant string holding your required legal text text
const String constitutionAppTerms = """
Terms & Conditions for Constitution of India App

1. Acceptance of Terms
By accessing or using this app, you agree to be bound by these Terms and Conditions. If you do not agree, please do not use the app.

2. Informational & Educational Purpose Only
This app is designed solely for educational, reference, and informational purposes. While we strive to ensure the accuracy of the text of the Constitution of India, amendments, and schedules, the content provided in this app should not be treated as official legal text, legal advice, or an official government publication. 

3. No Government Affiliation
This app is an independent project. It is not affiliated with, authorized by, endorsed by, or in any way officially connected to the Government of India, the Ministry of Law and Justice, or any other government agency. For official purposes, users should consult the Gazette of India or official government portals.

4. Limitation of Liability
We do not guarantee that the app will be completely error-free or up-to-date with the absolute latest amendments in real-time. Under no circumstances shall the developers be held liable for any inaccuracies, errors, omissions, or any damages resulting from the use of or reliance on the information provided herein.

5. User Conduct
You agree to use this app responsibly and legally. You may not use this app to distribute hate speech, political misinformation, or engage in any behavior that violates the laws of India.

6. Changes to Terms
We reserve the right to update these terms at any time. Your continued use of the app after changes are posted constitutes your acceptance of the new terms.
""";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    // Ensures context tree is painted on screen before pushing dialog layout blocks
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkTermsRequirement();
    });
  }

  // Evaluation logic checking preference flags from storage
  void _checkTermsRequirement() async {
    bool hasAccepted = await BookmarkShareHelper.hasAcceptedTerms();
    if (!hasAccepted && mounted) {
      _showConstitutionTermsDialog(context);
    }
  }

  // Renders the un-dismissible dialog wrapper component
  void _showConstitutionTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Disables background cancel taps
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(
            "Terms and Conditions",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Text(
                constitutionAppTerms,
                style: TextStyle(fontSize: 14, height: 1.4),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Decline", style: TextStyle(color: Colors.red)),
              onPressed: () {
                SystemNavigator.pop(); // Gracefully exit the app context
              },
            ),
            ElevatedButton(
              child: const Text("Accept & Continue"),
              onPressed: () async {
                await BookmarkShareHelper.acceptTerms();
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/drawer_image.jpeg",
                    fit: BoxFit.fill,
                    height: 99,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Constitution of India",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark),
              title: const Text("Bookmarks"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BookmarkScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.note),
              title: const Text("Notes"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotesScreen()),
                );
              },
            ),
            
            const Divider(),

            ListenableBuilder(
              listenable: themeManager,
              builder: (context, _) {
                return SwitchListTile(
                  secondary: Icon(
                    themeManager.isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                    color: themeManager.isDarkMode ? Colors.purpleAccent : Colors.orange,
                  ),
                  title: const Text("Night Mode"),
                  value: themeManager.isDarkMode,
                  onChanged: (bool value) {
                    themeManager.toggleTheme();
                  },
                );
              },
            ),

            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                "Version 1.0.0",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff0F172A), Color(0xff1E3A8A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Builder(
                        builder: (context) {
                          return IconButton(
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                            icon: const Icon(
                              Icons.menu_rounded,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                      const Expanded(
                        child: Text(
                          "The Constitution of India",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.15),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.menu_book_rounded, color: Colors.white),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Know Your Rights & Duties",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: width > 700 ? 3 : 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.1,
                  ),
                  children: [
                    HomeCard(
                      title: "Preamble",
                      icon: Icons.account_balance,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PreambleScreen(),
                        ),
                      ),
                    ),
                    HomeCard(
                      title: "Parts",
                      icon: Icons.article,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PartsScreen()),
                      ),
                    ),
                    HomeCard(
                      title: "Case Studies",
                      icon: Icons.gavel,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CaseStudyScreen(),
                        ),
                      ),
                    ),
                    HomeCard(
                      title: "News",
                      icon: Icons.newspaper,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const NewsScreen()),
                      ),
                    ),
                    HomeCard(
                      title: "Schedule",
                      icon: Icons.calendar_month,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ScheduleScreen(),
                        ),
                      ),
                    ),
                    HomeCard(
                      title: "Amendments",
                      icon: Icons.edit_note,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AmendmentScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
