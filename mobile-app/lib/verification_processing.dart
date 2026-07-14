// lib/screens/verification_processing.dart

import 'package:flutter/material.dart';
import 'HomeScreen.dart';

///
/// =============================================================
/// VERIFICATION SCREEN  (OTP INPUT)
/// =============================================================
///

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<TextEditingController> controllers =
  List.generate(6, (_) => TextEditingController());

  @override
  void dispose() {
    for (var c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            const _Background(),

            // Main Content
            Column(
              children: [
                const SizedBox(height: 70),
                const Text(
                  "Verification",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Enter the 6-digit code sent to your number",
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),

                const SizedBox(height: 40),

                // OTP boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    6,
                        (i) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: 40,
                      height: 50,
                      child: TextField(
                        controller: controllers[i],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        decoration: const InputDecoration(
                          counterText: "",
                          filled: true,
                          fillColor: Color(0xFFF6F7F6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && i < 5) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // VERIFY BUTTON
                SizedBox(
                  width: width * 0.7,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6FAF6B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProcessingScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Verify",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

///
/// =============================================================
/// PROCESSING SCREEN (LOADING SPINNER)
/// =============================================================
///

class ProcessingScreen extends StatefulWidget {
  const ProcessingScreen({super.key});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  @override
  void initState() {
    super.initState();

    // After 2 seconds → go to success screen
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const VerifiedScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFDFF7E8),
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFF6FAF6B),
        ),
      ),
    );
  }
}

///
/// =============================================================
/// VERIFIED SCREEN (SUCCESS MESSAGE)
/// =============================================================
///

class VerifiedScreen extends StatelessWidget {
  const VerifiedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // match layout in your mock: small title, subtitle, and a prominent "Continue!" action
    return Scaffold(
      backgroundColor: const Color(0xFFDFF7E8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            children: [
              const SizedBox(height: 120),
              const Text(
                "Success!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Congratulations! You have been\nsuccessfully authenticated",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),

              // spacer to push continue button near bottom like mock
              const Spacer(),

              // Continue button as big tappable text
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // route to the next screen (replace with your actual target)
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Continue!",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

///
/// =============================================================
/// CONTINUE SCREEN (TARGET AFTER VERIFIED)
/// Replace contents with your real Home / Dashboard.
/// =============================================================
///



///
/// =============================================================
/// BACKGROUND + BOTTOM WAVE (SHARED FOR ALL SCREENS)
/// =============================================================
///

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient Background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFDFF7E8),
                Color(0xFFF4FCEF),
              ],
            ),
          ),
        ),

        // Bottom Wave
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 220,
            width: double.infinity,
            child: ClipPath(
              clipper: BottomWaveClipper(),
              child: Container(
                color: const Color(0xFF66B76A),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.4);
    path.quadraticBezierTo(
        size.width * 0.25, size.height * 0.6, size.width * 0.5, size.height * 0.5);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.4, size.width, size.height * 0.6);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
