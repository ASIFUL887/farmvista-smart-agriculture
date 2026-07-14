import 'package:flutter/material.dart';
import 'AllFarmsScreen.dart';
import 'AgronomistScreen.dart';
import 'FarmDetailsScreen.dart';
import 'MyFarmsScreen.dart';
import 'ProfileScreen.dart';
import 'MedicineDetailsScreen.dart';
import 'MedicineDetailsScreen.dart';
import 'NotificationScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // ==========================================
  // PAGE LIST UPDATE KORA HOYECHE
  // ==========================================
  late final List<Widget> _pages = <Widget>[
    const HomeTab(),                        // 0: Home
    const AllFarmsScreen(openMedicineTab: false), // 1: All Farms (Notun Page Link kora holo)
    const AgronomistScreen(),               // 2: Agronomist
    const MyFarmsScreen(),                  // 3: My Farms
    const ProfileScreen(),                  // 4: Profile
  ];

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCF8C6).withOpacity(0.3),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.black12, width: 0.5)),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.black87,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.eco_outlined),
              activeIcon: Icon(Icons.eco),
              label: 'All farms',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.medical_services_outlined),
              activeIcon: Icon(Icons.medical_services),
              label: 'Agronomist',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.spa_outlined),
              activeIcon: Icon(Icons.spa),
              label: 'My farms',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// HomeTab Class (Same as before)
// ---------------------------------------------------------
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header Area
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 240,
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 50),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/home.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60.0, left: 16.0, right: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Weather
                            Row(
                              children: const [
                                Icon(Icons.wb_sunny, color: Colors.yellow, size: 28),
                                Icon(Icons.cloud, color: Colors.white, size: 28),
                                SizedBox(width: 8),
                                Text(
                                  '28°',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      shadows: [Shadow(blurRadius: 2, color: Colors.black26, offset: Offset(1,1))]
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                // CLICK KORLE NOTIFICATION SCREEN E JABE
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const NotificationScreen()),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.notifications, color: Colors.black),
                              ),
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Floating Stats Card
              Positioned(
                bottom: -40,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(Icons.attach_money, "BDT 2.23B", "Finance Facilitated"),
                      _buildVerticalDivider(),
                      _buildStatItem(Icons.people, "99999+", "Farmers"),
                      _buildVerticalDivider(),
                      _buildStatItem(Icons.inventory_2, "200K Ton", "Produce Sold"),
                      _buildVerticalDivider(),
                      _buildStatItem(Icons.local_hospital, "100+", "Doctors"),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 60),

          // 2. Agronomist Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildSectionHeader(
                "Agronomist",
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AgronomistScreen()),
                  );
                }
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildAgronomistItem("Dr.Bishwajit Das", Colors.grey[300]),
                _buildAgronomistItem("Dr.Bishwajit Das", Colors.grey[300]),
                _buildAgronomistItem("Dr.Bishwajit Das", Colors.grey[300]),
                _buildAgronomistItem("Dr.Bishwajit Das", Colors.grey[300]),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 3. Medicine Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildSectionHeader(
                "Medicine",
                    () {
                  // View All e click korle Medicine Tab Open hobe
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AllFarmsScreen(openMedicineTab: true)
                      )
                  );
                }
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Ekhane 'context' add kora hoyeche
                _buildMedicineItem(context, "Profit", "assets/medicine_bottle.png"),
                _buildMedicineItem(context, "Profit", "assets/medicine_bottle.png"),
                _buildMedicineItem(context, "Profit", null),
                _buildMedicineItem(context, "Profit", null),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 4. Active Farms Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildSectionHeader(
                "Active farms",
                    () {
                  // View All e click korle Farms Tab Open hobe
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AllFarmsScreen(openMedicineTab: false)
                      )
                  );
                }
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Ekhane 'context' pass kora hoyeche
                _buildActiveFarmItem(context, "Cucumber", "assets/cucumber.png"),
                _buildActiveFarmItem(context, "Unknown", null),
                _buildActiveFarmItem(context, "Unknown", null),
                _buildActiveFarmItem(context, "Unknown", null),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // --- Helpers ---
  Widget _buildVerticalDivider() => Container(height: 30, width: 1, color: Colors.grey[300]);

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: Colors.green),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.green)),
        Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 8, color: Colors.grey)),
      ],
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onViewAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
        InkWell(
          onTap: onViewAll,
          child: const Text("View All", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green)),
        )
      ],
    );
  }

  Widget _buildAgronomistItem(String name, Color? bgColor) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          CircleAvatar(radius: 32, backgroundColor: bgColor ?? Colors.grey[300], child: const Icon(Icons.person, size: 32, color: Colors.white)),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // HomeScreen.dart er vitore nicher widget gula khuje ber kore update koro

  // Ekhane 'BuildContext context' parameter add kora hoyeche
  Widget _buildMedicineItem(BuildContext context, String name, String? assetPath) {
    return GestureDetector(
      onTap: () {
        // Ekhon MedicineDetailsScreen e jabe
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MedicineDetailsScreen(medicineName: name),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Column(
          children: [
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey[200]),
              child: assetPath != null
                  ? ClipOval(child: Image.asset(assetPath, fit: BoxFit.cover, errorBuilder: (_,__,___)=> const Icon(Icons.medication)))
                  : const Icon(Icons.circle, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFarmItem(BuildContext context, String name, String? assetPath) {
    return GestureDetector( // Clickable banano holo
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FarmDetailsScreen(farmName: name, imagePath: "assets/home.jpeg"),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: Column(
          children: [
            Container(
              width: 80, height: 60,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
              child: assetPath != null ? const Icon(Icons.grass, color: Colors.green) : null,
            ),
            const SizedBox(height: 8),
            Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}