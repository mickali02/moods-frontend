import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import your page files (ensure these match your renamed files)
import 'change_user_info_page.dart';
import 'update_password_page.dart';
import 'delete_all_entries_page.dart';
import 'delete_account_page.dart';
import 'sign_out_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Center(
                  child: Text(
                    'Settings',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                // --- Account Section ---
                _buildSectionHeader('Account'),
                _modernCard(
                  child: Column(
                    children: [
                      _buildSettingsTile(
                        icon: Icons.person_outline,
                        title: 'Change Username & Email',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChangeUserInfoPage(),
                            ),
                          );
                        },
                      ),

                      // --- ADDED DIVIDER + SIGN OUT TILE ---
                      const Divider(height: 1, color: Colors.white24),

                      _buildSettingsTile(
                        icon: Icons.logout,
                        title: 'Sign Out',
                        textColor: Colors.amberAccent, // soft highlight
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignOutPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // --- Security Section ---
                _buildSectionHeader('Security'),
                _modernCard(
                  child: Column(
                    children: [
                      _buildSettingsTile(
                        icon: Icons.lock_outline,
                        title: 'Update Password',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UpdatePasswordPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // --- Danger Zone Section ---
                _buildSectionHeader('Danger Zone'),
                _modernCard(
                  gradientColors: [
                    Colors.red.withValues(alpha: 0.2),
                    Colors.red.withValues(alpha: 0.05),
                  ],
                  child: Column(
                    children: [
                      _buildSettingsTile(
                        icon: Icons.delete_sweep_outlined,
                        title: 'Delete All Entries',
                        textColor: Colors.red.shade300,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DeleteAllEntriesPage(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1, color: Colors.white24),
                      _buildSettingsTile(
                        icon: Icons.no_accounts_outlined,
                        title: 'Delete Account',
                        textColor: Colors.red.shade300,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DeleteAccountPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.grey.shade400,
          fontWeight: FontWeight.bold,
          fontSize: 13,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Icon(icon, color: textColor ?? Colors.white),
      title: Text(title, style: TextStyle(color: textColor ?? Colors.white)),
      trailing: Icon(Icons.chevron_right, size: 20, color: Colors.grey.shade400),
      onTap: onTap,
    );
  }

  Widget _modernCard({
    required Widget child,
    List<Color>? gradientColors,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors ??
              [
                Colors.deepPurple.withValues(alpha: 0.6),
                Colors.black.withValues(alpha: 0.4)
              ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: child,
      ),
    );
  }
}
