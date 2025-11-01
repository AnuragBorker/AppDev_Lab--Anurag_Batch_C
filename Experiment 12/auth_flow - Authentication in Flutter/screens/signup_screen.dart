import 'package:flutter/material.dart';
import 'package:auth_flow/screens/login_screen.dart';
import 'package:auth_flow/services/auth_service.dart';
import 'package:auth_flow/widgets/input_field.dart';
import 'package:auth_flow/widgets/custom_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthService _auth = AuthService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text('Create Account', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                InputField(controller: emailController, hint: 'Email'),
                const SizedBox(height: 15),
                InputField(controller: passwordController, hint: 'Password', obscure: true),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Sign Up',
                  onPressed: () async {
                    await _auth.signUp(emailController.text, passwordController.text);
                    if (mounted) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                  },
                  child: const Text("Already have an account? Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
