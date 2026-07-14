import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Import
import 'package:shared_preferences/shared_preferences.dart'; // Local Storage Import
import '../main.dart'; // WelcomeScreen পাওয়ার জন্য main.dart ইমপোর্ট করুন
import 'MyAccountScreen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FCEF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ===========================
            // Header Section
            // ===========================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 30),
              decoration: const BoxDecoration(
                color: Color(0xFFDCF8C6),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // Profile Image
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.green.shade200,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: const Icon(Icons.person, size: 60, color: Colors.white),
                      ),
                      // Edit Icon
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MyAccountScreen()),
                          );
                        },
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.green),
                          ),
                          child: const Icon(Icons.edit, color: Colors.green, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Bishwajit Das",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "bishwajit@gmail.com",
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),

            // ===========================
            // Menu Options List
            // ===========================
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildMenuTile(context, Icons.info_outline, "About us"),
                  _buildMenuTile(context, Icons.article_outlined, "News"),
                  _buildMenuTile(context, Icons.rss_feed, "Blogs"),
                  _buildMenuTile(context, Icons.report_problem_outlined, "Report Problem"),
                  _buildMenuTile(context, Icons.help_outline, "FAQ"),
                  _buildMenuTile(context, Icons.call_outlined, "Contact Us"),
                  const SizedBox(height: 20),

                  // LOGOUT BUTTON
                  _buildMenuTile(context, Icons.logout, "Log Out", isLogout: true),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // UPDATED HELPER WIDGET
  // ==========================================
  Widget _buildMenuTile(BuildContext context, IconData icon, String title, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : Colors.black87),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.red : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () async {
        if (isLogout) {
          // 1. Firebase থেকে সাইন আউট করুন
          await FirebaseAuth.instance.signOut();

          // 2. লোকাল স্টোরেজ ক্লিয়ার করুন (isLoggedIn = false)
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', false);

          // 3. Welcome Screen-এ ফিরে যান (পেছনের সব হিস্ট্রি মুছে দিয়ে)
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                (route) => false,
          );
        } else {
          // অন্যান্য মেনুর কাজ এখানে করতে পারেন
        }
      },
    );
  }
}