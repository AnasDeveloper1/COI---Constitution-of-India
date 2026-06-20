import 'package:constitutionofindia/screen_articles/amendment_screen.dart';
import 'package:constitutionofindia/screen_articles/casestudy_screen.dart';
import 'package:constitutionofindia/screen_articles/news_screen.dart';
import 'package:constitutionofindia/screen_articles/parts_screen.dart';
import 'package:constitutionofindia/screen_articles/preamble_screen.dart';
import 'package:constitutionofindia/screen_articles/schedule_screen.dart';
import 'package:constitutionofindia/screens/bookmark_screen.dart';
import 'package:constitutionofindia/screens/notes_screen.dart';
import 'package:flutter/material.dart';

import 'home_card.dart';
import '../main.dart'; // IMPORTANT: Adjust this path to wherever your global themeManager is located

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                  // ListenableBuilder updates text color dynamically based on theme context
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
                // FIXED: Just close the drawer. Pushing HomeScreen again creates an infinite stack loop.
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

            // --- THE NEW DAY & NIGHT THEME TOGGLE SWITCH ---
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