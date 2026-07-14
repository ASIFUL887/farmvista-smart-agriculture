import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'verification_processing.dart'; // আপনার ভেরিফিকেশন ফাইলের সঠিক নাম

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  // Default Role (যেটা সিলেক্ট থাকবে সেটাই ডাটাবেসে যাবে)
  String _role = 'Farmer';

  @override
  void dispose() {
    _nameController.dispose();
    _emailPhoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // ==========================
  // ROLE SELECTION WIDGET
  // ==========================
  Widget _buildRoleChips() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ChoiceChip(
          label: const Text('Farmer'),
          selected: _role == 'Farmer',
          onSelected: (v) => setState(() => _role = 'Farmer'),
          selectedColor: const Color(0xFF6FAF6B),
          backgroundColor: Colors.white,
          side: BorderSide(color: _role == 'Farmer' ? Colors.transparent : Colors.grey.shade300),
        ),
        const SizedBox(width: 12),
        ChoiceChip(
          label: const Text('Agronomist'),
          selected: _role == 'Agronomist',
          onSelected: (v) => setState(() => _role = 'Agronomist'),
          selectedColor: const Color(0xFF6FAF6B),
          backgroundColor: Colors.white,
          side: BorderSide(color: _role == 'Agronomist' ? Colors.transparent : Colors.grey.shade300),
        ),
      ],
    );
  }

  // ==========================
  // SIGN UP LOGIC
  // ==========================
  void _handleSignUp() async {
    final name = _nameController.text.trim();
    final email = _emailPhoneController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();

    // 1. Validation
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields'), backgroundColor: Colors.red));
      return;
    }

    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match'), backgroundColor: Colors.red));
      return;
    }

    try {
      // Loading Show
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.green)),
      );

      // 2. Create User in Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 3. Save User Data + ROLE in Firestore
      // (এই রোলটাই পরে লগিন পেজ চেক করবে)
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'role': _role, // গুরুত্ত্বপূর্ণ: এই _role ভ্যারিয়েবলটি ডাটাবেসে সেভ হচ্ছে
        'uid': userCredential.user!.uid,
        'createdAt': DateTime.now(),
      });

      // 4. Send Verification Email
      await userCredential.user!.sendEmailVerification();

      // Loading Hide
      if (mounted) Navigator.pop(context);

      // 5. Success Message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account Created! Check email for verification.'), backgroundColor: Colors.green),
      );

      // 6. Navigate to Verification Screen
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VerificationScreen()),
        );
      }

    } on FirebaseAuthException catch (e) {
      if (mounted) Navigator.pop(context); // Remove loading

      String message = "Registration Failed";
      if (e.code == 'email-already-in-use') {
        // যদি ইমেইল আগে থেকেই থাকে, তাহলে সে অন্য রোল দিয়েও খুলতে পারবে না
        message = "This email is already registered. Please Login.";
      } else if (e.code == 'weak-password') {
        message = "Password should be at least 6 characters.";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email address format.";
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
    } catch (e) {
      if (mounted) Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            // Background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFDFF7E8), Color(0xFFF4FCEF)],
                ),
              ),
            ),
            // Bottom Wave
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 220, width: double.infinity,
                child: ClipPath(clipper: BottomWaveClipper(), child: Container(color: const Color(0xFF66B76A))),
              ),
            ),
            // Form Content
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: const Text('Sign Up', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    ),
                    const SizedBox(height: 18),

                    // ROLE SELECTION (Farmer / Agronomist)
                    _buildRoleChips(),

                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(controller: _nameController, decoration: InputDecoration(prefixIcon: const Icon(Icons.person_outline), hintText: 'Full name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), filled: true, fillColor: const Color(0xFFF6F7F6), contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12))),
                          const SizedBox(height: 10),
                          TextField(controller: _emailPhoneController, keyboardType: TextInputType.emailAddress, decoration: InputDecoration(prefixIcon: const Icon(Icons.email_outlined), hintText: 'Email address', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), filled: true, fillColor: const Color(0xFFF6F7F6), contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12))),
                          const SizedBox(height: 10),
                          TextField(controller: _passwordController, obscureText: _obscurePassword, decoration: InputDecoration(prefixIcon: const Icon(Icons.lock_outline), hintText: 'Password', suffixIcon: IconButton(icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscurePassword = !_obscurePassword)), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), filled: true, fillColor: const Color(0xFFF6F7F6), contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12))),
                          const SizedBox(height: 10),
                          TextField(controller: _confirmController, obscureText: _obscureConfirm, decoration: InputDecoration(prefixIcon: const Icon(Icons.lock_outline), hintText: 'Confirm password', suffixIcon: IconButton(icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm)), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), filled: true, fillColor: const Color(0xFFF6F7F6), contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12))),
                          const SizedBox(height: 14),

                          // SIGN UP BUTTON
                          SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                  onPressed: _handleSignUp,
                                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6FAF6B), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
                                  child: const Text('Sign Up', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87))
                              )
                          ),

                          const SizedBox(height: 10),
                          Center(child: GestureDetector(onTap: () => Navigator.pop(context), child: const Text.rich(TextSpan(text: "Already have an account? ", children: [TextSpan(text: 'Login', style: TextStyle(fontWeight: FontWeight.w700))])))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Wave Clipper
class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.moveTo(0, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.6, size.width * 0.5, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.4, size.width, size.height * 0.6);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    return path;
  }
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}