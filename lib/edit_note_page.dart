import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditNotePage extends StatefulWidget {
  final String initialTitle;
  final String initialDescription;
  final String initialMood;

  const EditNotePage({
    super.key,
    required this.initialTitle,
    required this.initialDescription,
    required this.initialMood,
  });

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  String? _selectedMood;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _descriptionController = TextEditingController(text: widget.initialDescription);
    _selectedMood = widget.initialMood;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- Back Button + Title Centered ---
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Back Button on the left
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ),
                    // Centered Title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80.0), // space for arrow
                      child: Text(
                        'Edit Mood',
                        style: GoogleFonts.poppins(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 35), // ↑ increased from 40 → 50 to nudge title down

                // --- Form Container ---
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
                        controller: _titleController,
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
                        controller: _descriptionController,
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
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {
                              debugPrint("Note Updated!");
                              debugPrint("New Title: ${_titleController.text}");
                              debugPrint("New Mood: $_selectedMood");
                              debugPrint("New Description: ${_descriptionController.text}");
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                            ),
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
      ],
    );
  }
}
