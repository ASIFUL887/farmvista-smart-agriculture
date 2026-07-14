import 'package:flutter/material.dart';
import 'CallScreen.dart'; // Nicher notun file ta import koro

class ChatScreen extends StatelessWidget {
  final String doctorName;

  const ChatScreen({super.key, required this.doctorName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          doctorName,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          // VIDEO CALL ICON
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.black87, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CallScreen(doctorName: doctorName)),
              );
            },
          ),
          // PHONE CALL ICON
          IconButton(
            icon: const Icon(Icons.call, color: Colors.black87, size: 24),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CallScreen(doctorName: doctorName)),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // CONSULTATION START CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Column(
                      children: const [
                        Text(
                          "Consultation Start",
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "You can consult your problem to the doctor",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // DOCTOR MESSAGE
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey.shade300,
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      // Message Bubble
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctorName, // "Dr. Asiful Islam" in image
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(12).copyWith(topLeft: Radius.zero),
                              ),
                              child: const Text(
                                "Hello, How can i help you?",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // USER REPLY (Example Placeholder)
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(12).copyWith(bottomRight: Radius.zero),
                      ),
                      child: const SizedBox(width: 100, height: 10), // Empty green box as shown in design
                    ),
                  ),
                ],
              ),
            ),
          ),

          // BOTTOM INPUT FIELD
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            color: const Color(0xFFF1F8E9),
            child: Row(
              children: [
                // Input Box
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
                      ],
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.chat_bubble_outline, color: Colors.green, size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Type message ...",
                              border: InputBorder.none,
                              hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ),
                        ),
                        Icon(Icons.attach_file, color: Colors.grey, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Send Button
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 25,
                  child: const Icon(Icons.send, color: Colors.black87, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}