import 'package:flutter/material.dart';
import 'ChatScreen.dart'; // Nicher notun file ta import koro

class DoctorDetailScreen extends StatelessWidget {
  final String name;
  final String specialty;
  final String rating;

  const DoctorDetailScreen({
    super.key,
    required this.name,
    required this.specialty,
    this.rating = "4.7",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Doctor Detail",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      // ==========================================
      // FAB: CLICK KORLE CHAT SCREEN E JABE
      // ==========================================
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(doctorName: name),
            ),
          );
        },
        backgroundColor: const Color(0xFF4CAF50),
        child: const Icon(Icons.chat_bubble_outline),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                      Text(specialty, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(6)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, size: 14, color: Colors.green),
                            const SizedBox(width: 4),
                            Text(rating, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // About
            const Text("About", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 8),
            const Text(
              "Would you like to learn which way to grow your crops on a small or a big farm? I can help with plant diseases, soil health, and more...",
              style: TextStyle(color: Colors.black54, fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 24),
            // Contact
            Column(
              children: [
                _buildContactRow(Icons.email_outlined, "bishwajit@gmail.com"),
                const SizedBox(height: 12),
                _buildContactRow(Icons.phone_in_talk_outlined, "+880153472543"),
              ],
            ),
            const SizedBox(height: 30),
            // Available
            const Text("Available", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDayChip("Sun", true), _buildDayChip("Mon", true), _buildDayChip("Tue", true),
                _buildDayChip("Wed", false), _buildDayChip("Thu", false),
              ],
            ),
            const SizedBox(height: 16),
            const Text("Time : 10:00 AM - 04:00 PM", style: TextStyle(fontSize: 13, color: Colors.black87)),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: Colors.green, size: 20)),
        const SizedBox(width: 14),
        Text(text, style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildDayChip(String day, bool isAvailable) {
    return Container(
      width: 50, height: 35, alignment: Alignment.center,
      decoration: BoxDecoration(color: isAvailable ? const Color(0xFF4CAF50) : Colors.grey.shade300, borderRadius: BorderRadius.circular(8)),
      child: Text(day, style: TextStyle(color: isAvailable ? Colors.white : Colors.black45, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}