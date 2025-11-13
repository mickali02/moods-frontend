import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Mood {
  final String emoji;
  final String name;
  final Color color;

  Mood({required this.emoji, required this.name, required this.color});
}

class AddMoodPage extends StatefulWidget {
  const AddMoodPage({super.key});

  @override
  State<AddMoodPage> createState() => _AddMoodPageState();
}

class _AddMoodPageState extends State<AddMoodPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  final List<Mood> _moods = [
    Mood(emoji: '😊', name: 'Happy', color: Colors.green),
    Mood(emoji: '😢', name: 'Sad', color: Colors.blue),
    Mood(emoji: '😠', name: 'Angry', color: Colors.red),
    Mood(emoji: '😮', name: 'Surprised', color: Colors.orange),
    Mood(emoji: '😐', name: 'Neutral', color: Colors.grey),
  ];

  Mood? _selectedMood;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addNewEmotion() {
    TextEditingController nameController = TextEditingController();
    String? selectedEmoji;
    Color? selectedColor;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF2c2c2e),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Create New Emotion'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Emotion Name',
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Pick an Emoji'),
                  const SizedBox(height: 8),
                  _buildEmojiPicker((emoji) {
                    setDialogState(() => selectedEmoji = emoji);
                  }, selectedEmoji),
                  const SizedBox(height: 12),
                  const Text('Pick a Color'),
                  const SizedBox(height: 8),
                  _buildColorPicker((color) {
                    setDialogState(() => selectedColor = color);
                  }, selectedColor),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty &&
                      selectedEmoji != null &&
                      selectedColor != null) {
                    setState(() {
                      _moods.add(Mood(
                          emoji: selectedEmoji!,
                          name: nameController.text,
                          color: selectedColor!));
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Add New Mood',
                  style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // --- Form Card ---
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(140),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(90),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: const TextStyle(fontSize: 14),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Text('Pick Mood',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      _buildMoodSelector(),
                      const SizedBox(height: 16),

                      TextField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: const TextStyle(fontSize: 14),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _titleController.clear();
                                _descriptionController.clear();
                                _selectedMood = null;
                              });
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                            ),
                            onPressed: () {
                              // Save logic here
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      )
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
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        ..._moods.map((mood) {
          final isSelected = _selectedMood == mood;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedMood = mood;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              decoration: BoxDecoration(
                color: isSelected ? mood.color.withAlpha(180) : Colors.black26,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: isSelected ? mood.color : Colors.white38, width: 2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(mood.emoji, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Text(mood.name, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          );
        }),
        // Add button
        InkWell(
          onTap: _addNewEmotion,
          borderRadius: BorderRadius.circular(30),
          child: const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey,
            child: Icon(Icons.add, color: Colors.white, size: 18),
          ),
        )
      ],
    );
  }

  Widget _buildEmojiPicker(Function(String) onSelect, String? selectedEmoji) {
    final emojis = ['😄', '😍', '🥳', '🤯', '😴', '😇', '😎', '🤣'];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: emojis.map((emoji) {
        final isSelected = selectedEmoji == emoji;
        return GestureDetector(
          onTap: () => onSelect(emoji),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isSelected ? Colors.deepPurple : Colors.black26,
              shape: BoxShape.circle,
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 20)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildColorPicker(Function(Color) onSelect, Color? selectedColor) {
    final colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
      Colors.pink
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: colors.map((color) {
        final isSelected = selectedColor == color;
        return GestureDetector(
          onTap: () => onSelect(color),
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border:
                  isSelected ? Border.all(color: Colors.white, width: 2) : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}
