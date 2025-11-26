import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeleteAllEntriesPage extends StatefulWidget {
  const DeleteAllEntriesPage({super.key});

  @override
  State<DeleteAllEntriesPage> createState() => _DeleteAllEntriesPageState();
}

class _DeleteAllEntriesPageState extends State<DeleteAllEntriesPage> {
  bool _isDeleting = false;

  void _handleDelete() async {
    // 1. Show final confirmation dialog
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => _buildConfirmationDialog(context),
    );

    if (shouldDelete == true) {
      setState(() => _isDeleting = true);

      // 2. Simulate API deletion
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      setState(() => _isDeleting = false);

      // 3. Success Feedback & Exit
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All entries have been permanently deleted.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      
      // Return to Settings (or Home)
      Navigator.of(context).pop();
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- Header ---
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ),
                      Text(
                        'Danger Zone',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // --- Warning Card ---
                  Container(
                    padding: const EdgeInsets.all(30.0),
                    decoration: BoxDecoration(
                      // Red tinted background for warning
                      gradient: LinearGradient(
                        colors: [
                          Colors.red.withValues(alpha: 0.15),
                          Colors.black.withValues(alpha: 0.6),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(24.0),
                      border: Border.all(
                        color: Colors.redAccent.withValues(alpha: 0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.redAccent,
                          child: Icon(Icons.delete_forever_rounded, size: 45, color: Colors.white),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Delete All Data?',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'This action cannot be undone. All your mood entries, notes, and history will be permanently erased from our servers.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white70,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // --- Delete Button ---
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isDeleting ? null : _handleDelete,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              elevation: 8,
                              shadowColor: Colors.red.withValues(alpha: 0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isDeleting
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : Text(
                                    'DELETE EVERYTHING',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white60),
                          ),
                        )
                      ],
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

  // --- Final Confirmation Dialog ---
  Widget _buildConfirmationDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1C1C1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Are you absolutely sure?', style: TextStyle(color: Colors.white)),
      content: const Text(
        'There is no going back. Please confirm you want to delete all data.',
        style: TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel', style: TextStyle(color: Colors.white60)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Yes, Delete', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}