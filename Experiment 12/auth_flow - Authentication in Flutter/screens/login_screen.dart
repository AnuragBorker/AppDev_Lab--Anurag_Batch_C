import 'package:flutter/material.dart';
import 'package:auth_flow/screens/signup_screen.dart';
import 'package:auth_flow/screens/home_screen.dart';
import 'package:auth_flow/services/auth_service.dart';
import 'package:auth_flow/widgets/input_field.dart';
import 'package:auth_flow/widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                const Text('Welcome Back!', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                InputField(controller: emailController, hint: 'Email'),
                const SizedBox(height: 15),
                InputField(controller: passwordController, hint: 'Password', obscure: true),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Login',
                  onPressed: () async {
                    await _auth.login(emailController.text, passwordController.text);
                    if (mounted) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
                    }
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Sign in with Google',
                  icon: Icons.g_mobiledata,
                  color: Colors.redAccent,
                  onPressed: () async {
                    await _auth.signInWithGoogle();
                    if (mounted) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen()));
                  },
                  child: const Text("Don't have an account? Sign up"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
