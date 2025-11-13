import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('SettingsPage');

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
        // We remove the AppBar to have more control over the title's position.
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start, // Align children to the left
              children: [
                // --- Custom Header ---
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
                const SizedBox(height: 50), // This pushes the content below down

                // --- Section 1: Account ---
                _buildSectionHeader('Account'),
                _modernCard(
                  child: Column(
                    children: [
                      _buildSettingsTile(
                        icon: Icons.person_outline,
                        title: 'Change Username & Email',
                        onTap: () {
                          _logger.info('Navigate to change user info page');
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // --- Section 2: Security ---
                _buildSectionHeader('Security'),
                _modernCard(
                  child: Column(
                    children: [
                      _buildSettingsTile(
                        icon: Icons.lock_outline,
                        title: 'Update Password',
                        onTap: () {
                          _logger.info('Navigate to update password page');
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // --- Section 3: Danger Zone ---
                _buildSectionHeader('Danger Zone'),
                _modernCard(
                  gradientColors: [
                    Colors.red.withOpacity(0.2),
                    Colors.red.withOpacity(0.05)
                  ],
                  child: Column(
                    children: [
                      _buildSettingsTile(
                        icon: Icons.delete_sweep_outlined,
                        title: 'Delete All Entries',
                        textColor: Colors.red.shade300,
                        onTap: () {
                          _logger.warning('Delete All Entries tapped');
                        },
                      ),
                      const Divider(height: 1, color: Colors.white24),
                      _buildSettingsTile(
                        icon: Icons.no_accounts_outlined,
                        title: 'Delete Account',
                        textColor: Colors.red.shade300,
                        onTap: () {
                          _logger.warning('Delete Account tapped');
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
                Colors.deepPurple.withOpacity(0.6),
                Colors.black.withOpacity(0.4)
              ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
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