import 'package:flutter/material.dart';

class FarmDetailsScreen extends StatefulWidget {
  final String farmName;
  final String imagePath; // Asset path ba Network url logic pore change kora jabe

  const FarmDetailsScreen({
    super.key,
    required this.farmName,
    required this.imagePath,
  });

  @override
  State<FarmDetailsScreen> createState() => _FarmDetailsScreenState();
}

class _FarmDetailsScreenState extends State<FarmDetailsScreen> {
  int _quantity = 0;
  final double _pricePerUnit = 400.0; // Example price

  void _increment() {
    setState(() {
      _quantity++;
    });
  }

  void _decrement() {
    if (_quantity > 0) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDFF7E8), // Light green bg
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Farm Details",
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
                  const Text(
                    "Hemayetpur, Savar, Dhaka",
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.farmName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "**** BDT / unit",
                    style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  // Farm Image
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: AssetImage('assets/home.jpeg'), // Placeholder image
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Jodi real image pass koro tobe nicher line uncomment koro:
                    // child: Image.asset(widget.imagePath, fit: BoxFit.cover),
                  ),

                  const SizedBox(height: 10),

                  // Info Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Minimum : 50 unit(s)", style: TextStyle(fontSize: 11, color: Colors.black87)),
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
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Minus Button
                            InkWell(
                              onTap: _decrement,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.green),
                                ),
                                child: const Icon(Icons.remove, color: Colors.green),
                              ),
                            ),

                            // Quantity
                            Text(
                              "$_quantity",
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),

                            // Plus Button
                            InkWell(
                              onTap: _increment,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.green),
                                ),
                                child: const Icon(Icons.add, color: Colors.green),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text("for 20 kg", style: TextStyle(fontSize: 10, color: Colors.grey)),

                        const Divider(height: 30),

                        // Total Price Calculation Display
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

                  // Tabs (Overview / FAQ)
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

          // Bottom Button
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Next action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Next",
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}