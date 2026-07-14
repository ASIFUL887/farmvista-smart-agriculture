import 'package:flutter/material.dart';
import 'FarmDetailsScreen.dart';
import 'MedicineDetailsScreen.dart';

class AllFarmsScreen extends StatefulWidget {
  final bool openMedicineTab;

  const AllFarmsScreen({super.key, this.openMedicineTab = false});

  @override
  State<AllFarmsScreen> createState() => _AllFarmsScreenState();
}

class _AllFarmsScreenState extends State<AllFarmsScreen> {
  late bool _isFarmsTab;

  @override
  void initState() {
    super.initState();
    _isFarmsTab = !widget.openMedicineTab;
  }

  @override
  Widget build(BuildContext context) {
    // Check if we can go back
    final bool canGoBack = ModalRoute.of(context)?.canPop ?? false;

    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar baad diyechi, Body te custom design korbo
      body: Column(
        children: [
          // ==========================================
          // 1. TOP SPACING & CUSTOM HEADER
          // ==========================================
          const SizedBox(height: 50), // Status bar theke niche namano holo

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                // Back Button (Jodi dorkar hoy)
                if (canGoBack)
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  )
                else
                  const SizedBox(width: 48), // Placeholder to keep title centered

                // Centered Title
                const Expanded(
                  child: Text(
                    "Buy Farms & Medicine",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),

                // Right side balance (Back button er moto same width)
                if (canGoBack) const SizedBox(width: 48) else const SizedBox(width: 48),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ===========================
          // 2. TAB BUTTONS
          // ===========================
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFFDFF7E8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isFarmsTab = true),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _isFarmsTab ? const Color(0xFF55C759) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "All Farms",
                        style: TextStyle(
                          color: _isFarmsTab ? Colors.white : Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isFarmsTab = false),
                    child: Container(
                      decoration: BoxDecoration(
                        color: !_isFarmsTab ? const Color(0xFF55C759) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Medicine",
                        style: TextStyle(
                          color: !_isFarmsTab ? Colors.white : Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ===========================
          // 3. LIST VIEW
          // ===========================
          Expanded(
            child: _isFarmsTab ? _buildFarmsList() : _buildMedicineList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFarmsList() {
    final List<Map<String, String>> farms = [
      {'name': 'Cucumber Farm', 'price': '**** BDT'},
      {'name': 'Telapia Fish Farm', 'price': '**** BDT'},
      {'name': 'Tomato Farm', 'price': '**** BDT'},
      {'name': 'Potato Farm', 'price': '**** BDT'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: farms.length,
      itemBuilder: (context, index) {
        return _buildItemCard(
          title: farms[index]['name']!,
          price: farms[index]['price']!,
          buttonText: "Book",
          imageIcon: Icons.grass,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FarmDetailsScreen(
                  farmName: farms[index]['name']!,
                  imagePath: 'assets/home.jpeg',
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMedicineList() {
    final List<Map<String, String>> medicines = [
      {'name': 'Profit', 'price': '**** BDT'},
      {'name': 'Ciltigen', 'price': '**** BDT'},
      {'name': 'E-Korate', 'price': '**** BDT'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: medicines.length,
      itemBuilder: (context, index) {
        return _buildItemCard(
          title: medicines[index]['name']!,
          price: medicines[index]['price']!,
          buttonText: "Order",
          imageIcon: Icons.medication_liquid,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MedicineDetailsScreen(
                  medicineName: medicines[index]['name']!,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildItemCard({
    required String title,
    required String price,
    required String buttonText,
    required IconData imageIcon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(imageIcon, color: Colors.green, size: 40),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.green),
                      ),
                      const Icon(Icons.more_horiz, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Price : $price",
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: SizedBox(
                      height: 30,
                      width: 100,
                      child: ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6FAF6B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(buttonText, style: const TextStyle(fontSize: 12, color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}