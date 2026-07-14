import 'package:flutter/material.dart';
import 'HomeScreen.dart'; // Tomar HomeScreen import koro

class GoogleLoadingScreen extends StatefulWidget {
  const GoogleLoadingScreen({super.key});

  @override
  State<GoogleLoadingScreen> createState() => _GoogleLoadingScreenState();
}

class _GoogleLoadingScreenState extends State<GoogleLoadingScreen> {

  @override
  void initState() {
    super.initState();
    // 3 Second Wait korbe, tarpor Home Screen e jabe
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false, // Remove back history
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0FBE2), // Light Green background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            // Circular Loader
            SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                color: Color(0xFF66BB6A), // Green loader
                strokeWidth: 5,
              ),
            ),
            SizedBox(height: 24),
            Text(
              "Please! Wait a minutes.",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}