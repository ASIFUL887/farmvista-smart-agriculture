import 'package:flutter/material.dart';

class CallScreen extends StatelessWidget {
  final String doctorName;

  const CallScreen({super.key, required this.doctorName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9), // Light green full bg
      body: SafeArea(
        child: Column(
          children: [
            // Top Right Self View (Small Box)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: const EdgeInsets.all(20),
                width: 100,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.person, size: 60, color: Colors.white),
              ),
            ),

            const Spacer(),

            // Main Caller Info (Center)
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.2),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: const Icon(Icons.person, size: 80, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Text(
              doctorName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 10),

            // Timer Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "00:05:23",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),

            const Spacer(),

            // Bottom Controls (Mute, End, Video)
            Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Video Toggle
                  _buildControlButton(Icons.videocam_off, Colors.grey.shade300, Colors.black87),

                  // End Call
                  GestureDetector(
                    onTap: () => Navigator.pop(context), // End call and go back
                    child: Container(
                      width: 60, height: 60,
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.call_end, color: Colors.white, size: 30),
                    ),
                  ),

                  // Mute Toggle
                  _buildControlButton(Icons.mic_off, Colors.grey.shade300, Colors.black87),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(IconData icon, Color bg, Color iconColor) {
    return Container(
      width: 50, height: 50,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: iconColor, size: 24),
    );
  }
}