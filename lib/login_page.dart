import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart'; // Needed to navigate to HomePageController
import 'services/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Toggle between Login and Sign Up
  bool _isLogin = true; 
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController(); // Only for Sign Up

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        if (_isLogin) {
          // --- 1. LOGIN FLOW ---
          await ApiService().login(
            _emailController.text,
            _passwordController.text,
          );

          if (!mounted) return;
          setState(() => _isLoading = false);

          // Success: Go to Home
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePageController()),
          );
        } else {
          // --- 2. SIGNUP FLOW ---
          await ApiService().signup(
            _usernameController.text,
            _emailController.text,
            _passwordController.text,
          );

          if (!mounted) return;
          setState(() => _isLoading = false);

          // Success: DO NOT GO TO HOME.
          // Show message to check email.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created! Please check your email to activate.'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 5),
              behavior: SnackBarBehavior.floating,
            ),
          );

          // Switch back to Login view automatically
          setState(() => _isLogin = true);
        }
      } catch (e) {
        // --- ERROR HANDLER ---
        if (!mounted) return;
        setState(() => _isLoading = false);
        
        // Clean up error message
        final errorMessage = e.toString().replaceAll('Exception: ', '');
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/wallpaper.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // --- CUSTOM LOGO ---
                  Image.asset(
                    'assets/logo.png',
                    height: 120, // Kept this at 120 so the gap looks good
                    fit: BoxFit.contain,
                  ),
                  
                  // --- GAP REDUCED ---
                  const SizedBox(height: 10),

                  // --- Glass Card ---
                  Container(
                    padding: const EdgeInsets.all(28.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(24.0),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            _isLogin ? 'Welcome Back' : 'Create Account',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 30),

                          // --- Username Field (Sign Up Only) ---
                          if (!_isLogin) ...[
                            TextFormField(
                              controller: _usernameController,
                              style: const TextStyle(color: Colors.white),
                              decoration: _buildInputDecoration('Username', Icons.person),
                              validator: (value) =>
                                  value!.isEmpty ? 'Enter a username' : null,
                            ),
                            const SizedBox(height: 16),
                          ],

                          // --- Email Field ---
                          TextFormField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: _buildInputDecoration('Email', Icons.email_outlined),
                            validator: (value) =>
                                !value!.contains('@') ? 'Enter a valid email' : null,
                          ),
                          const SizedBox(height: 16),

                          // --- Password Field ---
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            style: const TextStyle(color: Colors.white),
                            decoration: _buildInputDecoration('Password', Icons.lock_outline),
                            validator: (value) =>
                                value!.length < 6 ? 'Password too short' : null,
                          ),
                          const SizedBox(height: 30),

                          // --- Action Button ---
                          SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 5,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : Text(
                                      _isLogin ? 'Login' : 'Sign Up',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // --- Toggle Login/Signup ---
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _isLogin
                                    ? "Don't have an account? "
                                    : "Already have an account? ",
                                style: const TextStyle(color: Colors.white70),
                              ),
                              GestureDetector(
                                onTap: () => setState(() => _isLogin = !_isLogin),
                                child: Text(
                                  _isLogin ? 'Sign Up' : 'Login',
                                  style: const TextStyle(
                                    color: Color(0xFFC5A8FF), // Your light purple accent
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white60),
      filled: true,
      fillColor: Colors.black.withValues(alpha: 0.3),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }
}