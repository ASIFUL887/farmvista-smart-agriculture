import 'package:flutter/material.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  // Current selected tab index
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FCEF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("My Account", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ===========================
          // Custom Tab Bar Section
          // ===========================
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildTabButton(0, "Personal"),
                const SizedBox(width: 10),
                _buildTabButton(1, "Banking"),
                const SizedBox(width: 10),
                _buildTabButton(2, "Nominee"),
                const SizedBox(width: 10),
                _buildTabButton(3, "Add TIN"),
              ],
            ),
          ),

          // ===========================
          // Tab Content Body
          // ===========================
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _getSelectedForm(_selectedIndex),
            ),
          ),
        ],
      ),
    );
  }

  // Helper to build tab buttons like chips
  Widget _buildTabButton(int index, String text) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4CAF50) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.green,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Switcher to show correct form based on index
  Widget _getSelectedForm(int index) {
    switch (index) {
      case 0: return const _PersonalForm();
      case 1: return const _BankingForm();
      case 2: return const _NomineeForm();
      case 3: return const _AddTINForm();
      default: return const _PersonalForm();
    }
  }
}
// ==================================================================
// 1. PERSONAL FORM WIDGET (UPDATED)
// ==================================================================
class _PersonalForm extends StatefulWidget {
  const _PersonalForm();
  @override
  State<_PersonalForm> createState() => _PersonalFormState();
}

class _PersonalFormState extends State<_PersonalForm> {
  String _selectedGender = 'Male'; // State for radio button

  @override
  Widget build(BuildContext context) {
    return Column(
      // Ei line ta add korle sob lekha Left side e thakbe
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),

        // Profile Pic Placeholder
        // Eita jate Left e na jay, tai Container diye width full kore Center kora holo
        Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue.shade100,
                child: const Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const CircleAvatar(
                radius: 15,
                backgroundColor: Colors.white,
                child: Icon(Icons.edit, size: 16, color: Colors.green),
              )
            ],
          ),
        ),
        const SizedBox(height: 30),

        _buildLabel("Name"),
        _buildTextField(hint: "Ex. Bishwajit"),

        _buildLabel("NID Number"),
        _buildTextField(hint: "Ex. 1992377485958"),

        _buildLabel("Gender"),
        Row(
          children: [
            Radio(
              value: 'Male',
              groupValue: _selectedGender,
              activeColor: Colors.green,
              onChanged: (val) => setState(() => _selectedGender = val.toString()),
            ),
            const Text('Male'),
            const SizedBox(width: 20),
            Radio(
              value: 'Female',
              groupValue: _selectedGender,
              activeColor: Colors.green,
              onChanged: (val) => setState(() => _selectedGender = val.toString()),
            ),
            const Text('Female'),
          ],
        ),

        _buildLabel("Date Of Birth"),
        _buildTextField(hint: "Ex. 01-01-1990"),

        _buildLabel("Email*"),
        _buildTextField(hint: "Ex. bishwajit@gmail.com"),

        _buildLabel("Contact Number*"),
        _buildTextField(hint: "Ex. 017xxxxxxxx"),

        _buildLabel("Full Address*"),
        _buildTextField(hint: "Ex. Savar, Dhaka"),

        const SizedBox(height: 30),
        _buildDoneButton(),
        const SizedBox(height: 50),
      ],
    );
  }
}

// ==================================================================
// 2. BANKING FORM WIDGET
// ==================================================================
class _BankingForm extends StatelessWidget {
  const _BankingForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        _buildLabel("Name of the Bank"),
        _buildTextField(hint: "Ex. DBBL"),

        _buildLabel("Name of the Branch"),
        _buildTextField(hint: "Ex. Savar"),

        _buildLabel("Name of the Account Holder"),
        _buildTextField(hint: "Ex. Bishwajit"),

        _buildLabel("Account Number"),
        _buildTextField(hint: "Ex. 125359345725"),

        const SizedBox(height: 180), // Spacer
        _buildDoneButton(),
        const SizedBox(height: 50),
      ],
    );
  }
}

// ==================================================================
// 3. NOMINEE FORM WIDGET
// ==================================================================
class _NomineeForm extends StatelessWidget {
  const _NomineeForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        _buildLabel("Nominee Name"),
        _buildTextField(hint: "Ex. Bishwajit"),

        _buildLabel("Date of Birth"),
        _buildTextField(hint: "Ex. 01-01-2000"),

        _buildLabel("Relationship"),
        _buildTextField(hint: "Ex. Brother"),

        _buildLabel("Contact Number"),
        _buildTextField(hint: "Ex. 017xxxxxxxx"),

        _buildLabel("NID Number"),
        _buildTextField(hint: "Ex. 1992377485958"),

        _buildLabel("NID Image"),
        const SizedBox(height: 10),
        // NID Image Upload Placeholders
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.green.shade200),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.attach_file, color: Colors.green), SizedBox(width: 8), Text("Front Side", style: TextStyle(color: Colors.green))]),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.green.shade200),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.attach_file, color: Colors.green), SizedBox(width: 8), Text("Back Side", style: TextStyle(color: Colors.green))]),
          ),
        ),

        const SizedBox(height: 30),
        _buildDoneButton(),
        const SizedBox(height: 50),
      ],
    );
  }
}

// ==================================================================
// 4. ADD TIN FORM WIDGET
// ==================================================================
class _AddTINForm extends StatelessWidget {
  const _AddTINForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        // Important Note Box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("IMPORTANT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
              SizedBox(height: 8),
              Text("• TIN Certificate Change can be requested only once."),
              Text("• Please make sure to provide correct information as it is connected to the TIN certificate."),
              Text("• Please email us at bishwajit@farmvista.com for any further queries."),
            ],
          ),
        ),
        const SizedBox(height: 30),

        _buildLabel("TIN Number"),
        _buildTextField(hint: "Ex. 592375834904"),

        _buildLabel("TIN Image"),
        const SizedBox(height: 10),
        // Dotted Upload Box
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green, style: BorderStyle.solid), // Flutter doesn't have simple dotted border cleanly, using solid for now matching image look
          ),
          child: const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cloud_upload_outlined, color: Colors.green),
                SizedBox(width: 8),
                Text("Upload Attachment", style: TextStyle(color: Colors.green)),
              ],
            ),
          ),
        ),

        const SizedBox(height: 150), // Spacer
        _buildDoneButton(),
        const SizedBox(height: 50),
      ],
    );
  }
}

// ===========================
// Shared Helper Widgets
// ===========================

// Helper for Labels
Widget _buildLabel(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87),
    ),
  );
}

// Helper for TextFields
Widget _buildTextField({required String hint}) {
  return TextField(
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
    ),
  );
}

// Helper for Done Button
Widget _buildDoneButton() {
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: () {
        // TODO: Save data action
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4CAF50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text("Done", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
    ),
  );
}