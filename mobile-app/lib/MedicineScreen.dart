import 'package:flutter/material.dart';

class MedicineScreen extends StatelessWidget {
  const MedicineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Clean white background
      appBar: AppBar(
        title: const Text(
          "All Medicines",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87), // Back button color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          // 3 ta item pashapashi thakbe
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.75, // Lomba card
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
          ),
          itemCount: 15, // Mone koro 15 ta medicine ache
          itemBuilder: (context, index) {
            return _buildMedicineCard(index);
          },
        ),
      ),
    );
  }

  // Medicine Item Card Design
  Widget _buildMedicineCard(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Medicine Image / Icon Placeholder
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.medication_outlined, color: Colors.green.shade700, size: 30),
            // Image use korle nicher line ta uncomment koro:
            // child: ClipOval(child: Image.asset('assets/medicine_bottle.png', fit: BoxFit.cover)),
          ),
          const SizedBox(height: 12),

          // Medicine Name
          Text(
            "Medicine ${index + 1}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 4),

          // Price or Category
          Text(
            "৳ ${(index + 1) * 120}", // Fake price logic
            style: const TextStyle(
              color: Colors.green,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}