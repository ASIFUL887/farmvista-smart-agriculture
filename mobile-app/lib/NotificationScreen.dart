import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar remove kore 'body' er vitorei header banalam
      body: Column(
        children: [
          // ===============================
          // 1. CUSTOM HEADER (Icon + Text)
          // ===============================
          Container(
            // EIKHANE 'top: 60' DIYE BESHI KORE NICHE NAMANO HOYECHE
            padding: const EdgeInsets.only(top: 60.0, left: 10, right: 10, bottom: 10),
            color: Colors.white,
            child: Row(
              children: [
                // Back Icon
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),

                // Title (Notification)
                // Expanded use korsi jate text ta majhkhane thake
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 40.0), // Icon er width baad diye center adjust kora
                    child: Text(
                      "Notification",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ===============================
          // 2. GREEN BOX BODY (Full Screen)
          // ===============================
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFD0F8D2), // Light green full width
              ),
              child: const Center(
                child: Text(
                  "No Data Found",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}