import 'package:flutter/material.dart';
import 'package:auth_flow/services/auth_service.dart';
import 'package:auth_flow/screens/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().signOut();
              if (context.mounted) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
              }
            },
          )
        ],
      ),
      body: const Center(
        child: Text('Welcome to AuthFlow 🚀', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
