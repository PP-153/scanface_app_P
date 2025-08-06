import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool showPassword = false;
  bool showConfirmPassword = false;

  String? confirmPasswordError;

  Future<void> registerUser() async {
    setState(() {
      confirmPasswordError = null;
    });

    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        confirmPasswordError = 'Passwords do not match';
      });
      return; // หยุดทำงานถ้ารหัสไม่ตรงกัน
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Register failed: ${e.message}')),
      );
    }
  }

  InputDecoration customInputDecoration(String label, [String? errorText]) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black),
      errorText: errorText,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: errorText == null ? Colors.grey : Colors.red),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: errorText == null ? Colors.green.shade800 : Colors.red),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6EC),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 180,
              ),
              const SizedBox(height: 30),
              TextField(
                controller: emailController,
                decoration: customInputDecoration('Email'),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: !showPassword,
                decoration: customInputDecoration('Password').copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
                    color: Colors.black,
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: confirmPasswordController,
                obscureText: !showConfirmPassword,
                decoration: customInputDecoration('Confirm Password', confirmPasswordError).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(showConfirmPassword ? Icons.visibility : Icons.visibility_off),
                    color: Colors.black,
                    onPressed: () {
                      setState(() {
                        showConfirmPassword = !showConfirmPassword;
                      });
                    },
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: registerUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}