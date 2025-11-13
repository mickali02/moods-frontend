import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddMoodPage extends StatefulWidget {
  const AddMoodPage({super.key});

  @override
  State<AddMoodPage> createState() => _AddMoodPageState();
}

class _AddMoodPageState extends State<AddMoodPage> {
  String? _selectedMood;

  void _addNewEmotion() {
    debugPrint("Add new emotion tapped!");
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80), // 👈 pushes content down
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 👇 Centered Title
                Text(
                  'Add New Mood',
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40), // space between title and form

                // 👇 The form container
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(140),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text('Pick Mood', style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 12),
                      _buildMoodSelector(),
                      const SizedBox(height: 20),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        maxLines: 4,
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              debugPrint("Cancel tapped!");
                            },
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {
                              debugPrint("Save tapped!");
                            },
                            child: const Text('Save'),
                          ),
                        ],
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

  Widget _buildMoodSelector() {
    final moods = ['😊', '😢', '😠', '😮', '😐'];

    return Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      children: [
        ...moods.map(
          (mood) => ChoiceChip(
            label: Text(mood, style: const TextStyle(fontSize: 24)),
            selected: _selectedMood == mood,
            onSelected: (isSelected) {
              setState(() {
                _selectedMood = isSelected ? mood : null;
              });
            },
            selectedColor: Colors.deepPurple.withAlpha(150),
          ),
        ),
        InkWell(
          onTap: _addNewEmotion,
          borderRadius: BorderRadius.circular(30),
          child: const CircleAvatar(
            backgroundColor: Colors.grey,
            child: Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
