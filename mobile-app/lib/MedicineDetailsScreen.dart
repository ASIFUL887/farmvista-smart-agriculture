import 'package:flutter/material.dart';

class MedicineDetailsScreen extends StatefulWidget {
  final String medicineName;

  const MedicineDetailsScreen({
    super.key,
    required this.medicineName,
  });

  @override
  State<MedicineDetailsScreen> createState() => _MedicineDetailsScreenState();
}

class _MedicineDetailsScreenState extends State<MedicineDetailsScreen> {
  int _quantity = 0;
  final double _pricePerUnit = 120.0; // Example price per medicine

  void _increment() => setState(() => _quantity++);
  void _decrement() {
    if (_quantity > 0) setState(() => _quantity--);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDFF7E8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Medicine Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text("Hemayetpur, Savar, Dhaka", style: TextStyle(fontSize: 12, color: Colors.black54)),
                  const SizedBox(height: 4),
                  Text(widget.medicineName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text("**** BDT / pcs", style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 20),

                  // Medicine Image (Gray Background as per design)
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/medicine_bottle.png', // Ensure this asset exists
                        height: 120,
                        fit: BoxFit.contain,
                        errorBuilder: (c, o, s) => const Icon(Icons.medication, size: 80, color: Colors.green),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Minimum : 100 pcs", style: TextStyle(fontSize: 11, color: Colors.black87)),
                      Text("Remaining : 20", style: TextStyle(fontSize: 11, color: Colors.green)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Counter Card
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: _decrement,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.green)),
                                child: const Icon(Icons.remove, color: Colors.green),
                              ),
                            ),
                            Text("$_quantity", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            InkWell(
                              onTap: _increment,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.green)),
                                child: const Icon(Icons.add, color: Colors.green),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text("no of Pcs", style: TextStyle(fontSize: 10, color: Colors.grey)),

                        const Divider(height: 30),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${(_quantity * _pricePerUnit).toStringAsFixed(2)} BDT",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Total payable amount", style: TextStyle(fontSize: 10, color: Colors.grey)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Tabs
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text("Overview", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                          const SizedBox(height: 4),
                          Container(height: 2, width: 60, color: Colors.green),
                        ],
                      ),
                      const Text("FAQ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Next", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}