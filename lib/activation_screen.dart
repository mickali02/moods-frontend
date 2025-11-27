// lib/screens/activation_screen.dart

import 'package:flutter/material.dart';
import 'services/api_service.dart'; // Adjust path

class ActivationScreen extends StatefulWidget {
  final String token;
  const ActivationScreen({super.key, required this.token});

  @override
  State<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  final ApiService _apiService = ApiService();
  late Future<void> _activationFuture;

  @override
  void initState() {
    super.initState();
    // Start the activation process as soon as the screen loads
    _activationFuture = _apiService.activateUser(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<void>(
          future: _activationFuture,
          builder: (context, snapshot) {
            // State 1: Loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text("Activating your account..."),
                ],
              );
            }
            // State 2: Error
            if (snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 50),
                  const SizedBox(height: 20),
                  const Text("Activation Failed!"),
                  Text("The link may be invalid or expired."),
                  // Optional: Add a button to go back to the login page
                ],
              );
            }
            // State 3: Success
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 50),
                const SizedBox(height: 20),
                const Text("Account Activated!"),
                const Text("You can now log in with your credentials."),
                // Optional: Add a button to navigate to the login page
              ],
            );
          },
        ),
      ),
    );
  }
}