import 'package:flutter/material.dart';
import 'GoogleLoadingScreen.dart'; // Nicher file ta import koro

class GoogleSignInScreen extends StatelessWidget {
  const GoogleSignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5), // Semi-transparent overlay effect like dialog
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Sign in with Google", style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(width: 8),
                  Image.asset('assets/google.png', width: 18, height: 18), // Google Logo
                ],
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),

              // App Logo & Title
              Image.asset('assets/FarmVista_logo.png', width: 40, height: 40),
              const SizedBox(height: 8),
              const Text(
                "Choose an account",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                "to continue to FarmVista",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),

              const SizedBox(height: 30),

              // Account 1
              _buildAccountTile(
                context,
                "Bishwajit Das",
                "bishwajit@gmail.com",
                Colors.purple,
                "B",
              ),

              const Divider(height: 1),

              // Account 2
              _buildAccountTile(
                context,
                "Farm Admin",
                "admin@farmvista.com",
                Colors.purple,
                "F",
              ),

              const Divider(height: 1),

              // Add another account
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(Icons.person_add_alt, color: Colors.black54),
                ),
                title: const Text(
                  "Use another account",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                onTap: () {},
              ),

              const SizedBox(height: 20),

              // Footer Text
              const Text(
                "To continue, Google will share your name, email address, language preference, and profile picture with FarmVista. Before using this app, you can review FarmVista's privacy policy and terms of service.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountTile(BuildContext context, String name, String email, Color color, String initial) {
    return ListTile(
      onTap: () {
        // ACCOUNT SELECT KORLE LOADING SCREEN E JABE
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GoogleLoadingScreen()),
        );
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: CircleAvatar(
        backgroundColor: color,
        child: Text(initial, style: const TextStyle(color: Colors.white)),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(email, style: const TextStyle(fontSize: 12)),
    );
  }
}