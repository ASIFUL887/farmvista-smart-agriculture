import 'package:flutter/material.dart';
import 'DoctorDetailScreen.dart';
import 'HomeScreen.dart'; // EITA ADD KORO (Jate Home e jawa jay)

class AgronomistScreen extends StatefulWidget {
  const AgronomistScreen({super.key});

  @override
  State<AgronomistScreen> createState() => _AgronomistScreenState();
}

class _AgronomistScreenState extends State<AgronomistScreen> {
  // Initial selected division
  String _selectedDivision = 'All';

  // Division List
  final List<String> _divisions = [
    'All',
    'Dhaka',
    'Barishal',
    'Chittagong',
    'Khulna',
    'Sylhet'
  ];

  // Dummy Data
  final List<Map<String, dynamic>> doctors = [
    {
      'name': 'Dr. Bishwajit',
      'specialty': 'Fish Doctor',
      'status': 'Online',
      'rating': '4.7',
      'location': 'Dhaka',
      'isOnline': true
    },
    {
      'name': 'Dr. Imran Saimun',
      'specialty': 'Crop Specialist',
      'status': 'Offline',
      'rating': '4.4',
      'location': 'Barisal',
      'isOnline': false
    },
    {
      'name': 'Dr. Asiful Islam',
      'specialty': 'Soil Scientist',
      'status': 'Online',
      'rating': '4.9',
      'location': 'Chittagong',
      'isOnline': true
    },
    {
      'name': 'Dr. Nazmul',
      'specialty': 'Veterinary',
      'status': 'Online',
      'rating': '4.7',
      'location': 'Khulna',
      'isOnline': true
    },
    {
      'name': 'Dr. Polash',
      'specialty': 'Plant Pathologist',
      'status': 'Offline',
      'rating': '4.9',
      'location': 'Sylhet',
      'isOnline': false
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter logic
    final filteredDoctors = _selectedDivision == 'All'
        ? doctors
        : doctors.where((doc) => doc['location'] == _selectedDivision || (doc['location'] == 'Barisal' && _selectedDivision == 'Barishal')).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      body: Column(
        children: [
          // ===========================
          // 1. HEADER (Cover Pic + Text)
          // ===========================
          Stack(
            children: [
              // Cover Image
              Container(
                height: 160,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/home.jpeg'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
              ),
              // Dark Overlay
              Container(
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
              ),
              // "Agronomist" Text Centered
              const Positioned.fill(
                child: Center(
                  child: Text(
                    "Agronomist",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),

              // ==========================================
              // BACK BUTTON (UPDATED LOGIC)
              // ==========================================
              Positioned(
                top: 40,
                left: 10,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () {
                    // EITA PREVIOUS HISTORY CLEAR KORE HOME E NIYE JABE
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                          (route) => false, // Sob purano route delete kore dibe
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ===========================
          // 2. DIVISION SELECTOR (Dropdown)
          // ===========================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Filter by Division:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedDivision,
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.green),
                      style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedDivision = newValue!;
                        });
                      },
                      items: _divisions.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ===========================
          // 3. DOCTOR LIST
          // ===========================
          Expanded(
            child: filteredDoctors.isEmpty
                ? const Center(child: Text("No doctors found in this area."))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: filteredDoctors.length,
              itemBuilder: (context, index) {
                return _buildDoctorCard(context, filteredDoctors[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, Map<String, dynamic> doctor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Picture
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: const Icon(Icons.person, size: 50, color: Colors.white),
          ),

          const SizedBox(width: 14),

          // Info Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  doctor['specialty'],
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      doctor['location'],
                      style: const TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.green, size: 10),
                          const SizedBox(width: 2),
                          Text(doctor['rating'], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      doctor['isOnline'] ? "Online" : "Offline",
                      style: TextStyle(
                        fontSize: 11,
                        color: doctor['isOnline'] ? Colors.green : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Buttons Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height: 26,
                width: 90,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.green),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text("Follow", style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 26,
                width: 90,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoctorDetailScreen(
                          name: doctor['name'],
                          specialty: doctor['specialty'],
                          rating: doctor['rating'],
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    padding: EdgeInsets.zero,
                    elevation: 0,
                  ),
                  child: const Text("More Details", style: TextStyle(fontSize: 10, color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}