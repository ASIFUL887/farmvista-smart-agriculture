import 'package:flutter/material.dart';

class MyFarmsScreen extends StatefulWidget {
  const MyFarmsScreen({super.key});

  @override
  State<MyFarmsScreen> createState() => _MyFarmsScreenState();
}

class _MyFarmsScreenState extends State<MyFarmsScreen> {
  // Dropdown value
  String? _selectedFarmType;
  final List<String> _farmTypes = ['Vegetable', 'Fruit', 'Grain', 'Flower'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC8F5C4), // Main light green background
      // AppBar baad diyechi jate nijera niche namate pari
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // 1. TOP SPACING & TITLE
            // ==========================================
            const SizedBox(height: 60), // EIKHANE CHANGE: Upore faka jayga deya holo

            const Center(
              child: Text(
                "My Farms",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 30), // Title er niche faka jayga

            // ===========================
            // 2. RUNNING FARMS SECTION
            // ===========================
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black87),
                children: [
                  TextSpan(
                      text: "Running ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: "Farms"),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Two Boxes: Pending & Active
            Row(
              children: [
                Expanded(
                  child: _buildStatusBox("Pending Farms"),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatusBox("Active Farms"),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Divider(color: Colors.black54, thickness: 1),
            const SizedBox(height: 20),

            // ===========================
            // 3. ADD FARMS SECTION
            // ===========================
            const Text(
              "Add Farms",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // White/Light Container for Form
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FFF0), // Very light mint inside
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black54, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dropdown Row
                  Row(
                    children: [
                      const Text(
                        "Farms : ",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 35,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.black45),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedFarmType,
                            hint: const Text("Select Item", style: TextStyle(fontSize: 12)),
                            icon: const Icon(Icons.arrow_drop_down),
                            items: _farmTypes.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: const TextStyle(fontSize: 13)),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedFarmType = newValue;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Name & Weights Row
                  Row(
                    children: [
                      // Farm Name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Farm Name :", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            SizedBox(
                              height: 35,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Ex. Cucumber Farm",
                                  hintStyle: const TextStyle(fontSize: 11, color: Colors.grey),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Farm Weights
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Farm Weights :", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            SizedBox(
                              height: 35,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Ex. 50kgs",
                                  hintStyle: const TextStyle(fontSize: 11, color: Colors.grey),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Photo & Description Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Photo Upload Box
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Farm Photo :", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.black45),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.add_circle_outline, size: 24),
                                    SizedBox(height: 4),
                                    Text("Add Farm Photo", style: TextStyle(fontSize: 10)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Note : Use Clearly Real Photo",
                              style: TextStyle(fontSize: 8, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Description Box
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Farm Description : (if you need)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.black45),
                              ),
                              child: const TextField(
                                maxLines: 5,
                                decoration: InputDecoration(
                                  hintText: "Type Here ...",
                                  hintStyle: TextStyle(fontSize: 10, color: Colors.grey),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Upload Button
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          // Upload Logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF55C759), // Bright Green
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Upload Your Farm",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Helper for Status Boxes
  Widget _buildStatusBox(String title) {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FFF0), // Light mint
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black54, width: 0.5),
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}