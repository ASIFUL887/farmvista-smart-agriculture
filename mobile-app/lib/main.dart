import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginScreen.dart';
import 'SignupScreen.dart';
import 'HomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Tomar json file theke neya ashol tottho
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDsFcUXdzkQrXjEZlo5CuNUclvYYBOKkAk",
        appId: "1:366033648062:android:8c2927c9d74960bad661ef",
        messagingSenderId: "366033648062",
        projectId: "farmvista-b3554",
        storageBucket: "farmvista-b3554.firebasestorage.app",
      ),
    );

    // Local Data Check
    final prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    runApp(FarmVistaApp(startHome: isLoggedIn));

  } catch (e) {
    print("FIREBASE ERROR: $e");
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text("Error: $e", textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}

class FarmVistaApp extends StatelessWidget {
  final bool startHome;
  const FarmVistaApp({super.key, required this.startHome});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FarmVista',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.green,
        fontFamily: 'Poppins',
      ),
      home: startHome ? const HomeScreen() : const WelcomeScreen(),
    );
  }
}

// ==========================================
// WELCOME SCREEN (Login/Signup Page)
// ==========================================
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF0FDF4),
      body: Stack(
        children: [
          // Bottom Wave Design
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: height * 0.35,
              width: double.infinity,
              child: ClipPath(
                clipper: BottomWaveClipper(),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF81C784), // Light Green
                        Color(0xFF4CAF50), // Dark Green
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Logo
                  Image.asset(
                    'assets/FarmVista_logo.png',
                    width: width * 0.6,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 4),
                  const Text(
                    'Your Complete Agricultural Companion',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const Spacer(flex: 3),

                  // Log In Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF66A568),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Sign Up Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignupScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC8E6C9),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Wave Clipper Class
class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(0, size.height * 0.45);
    path.quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.65,
        size.width * 0.5,
        size.height * 0.55
    );
    path.quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.45,
        size.width,
        size.height * 0.6
    );
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}