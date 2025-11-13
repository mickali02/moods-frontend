import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class Mood {
  final String emoji;
  final String name;
  final Color color;

  Mood({required this.emoji, required this.name, required this.color});
}

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
    _titleController = TextEditingController(text: widget.initialTitle);
    _descriptionController = TextEditingController(text: widget.initialDescription);

    _selectedMood = _moods.firstWhere(
      (mood) => mood.emoji == widget.initialMood,
      orElse: () => _moods.first,
    );
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
    Color selectedColor = Colors.deepPurple;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF2C2C2E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            title: const Text(
              'Create New Emotion',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        labelText: 'Emotion Name',
                        labelStyle: const TextStyle(color: Colors.white70, fontSize: 13),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white30),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.deepPurple),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Pick an Emoji',
                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 180, // fixed height to enable scrolling
                      child: SingleChildScrollView(
                        child: _buildEmojiPicker(
                            (emoji) => setDialogState(() => selectedEmoji = emoji),
                            selectedEmoji),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Pick a Color',
                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    _buildColorPicker(
                        (color) => setDialogState(() => selectedColor = color),
                        selectedColor),
                  ],
                ),
              ),
            ),
            actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: const Text('Cancel', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (nameController.text.isNotEmpty && selectedEmoji != null) {
                        setState(() {
                          _moods.add(Mood(
                            emoji: selectedEmoji!,
                            name: nameController.text,
                            color: selectedColor,
                          ));
                        });
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Save', style: TextStyle(fontSize: 14)),
                  ),
                ],
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
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80.0),
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
                const SizedBox(height: 35),
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(140),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
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
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {
                              debugPrint("Note Updated!");
                              debugPrint("New Title: ${_titleController.text}");
                              debugPrint("New Mood: ${_selectedMood?.emoji}");
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
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        ..._moods.map((mood) {
          final isSelected = _selectedMood == mood;
          return GestureDetector(
            onTap: () => setState(() => _selectedMood = mood),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              decoration: BoxDecoration(
                color: isSelected ? mood.color.withAlpha(180) : Colors.black26,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? mood.color : Colors.white38,
                  width: 2,
                ),
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
        InkWell(
          onTap: _addNewEmotion,
          borderRadius: BorderRadius.circular(30),
          child: const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey,
            child: Icon(Icons.add, color: Colors.white, size: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildEmojiPicker(Function(String) onSelect, String? selectedEmoji) {
    final emojis = [
      '😀','😁','😂','🤣','😃','😄','😅','😆','😉','😊','😋','😎','😍','😘','😗',
      '😙','😚','🙂','🤗','🤩','🤔','😐','😑','😶','🙄','😏','😣','😥','😮','🤐',
      '😯','😪','😫','🥱','😴','😌','😛','😜','🤪','😝','🤑','🤗','🤭','🤫','🤔',
      '🤤','🤠','😓','😔','😕','🙁','☹️','😖','😞','😟','😤','😢','😭','😦','😧',
      '😨','😩','🤯','😬','😰','😱','🥵','🥶','😳','🤪','😵','🥴','😠','😡','🤬',
      '😷','🤒','🤕','🤢','🤮','🤧','🥳','🥺','🤠','😇','🤓'
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 1,
      ),
      itemCount: emojis.length,
      itemBuilder: (context, index) {
        final emoji = emojis[index];
        final isSelected = selectedEmoji == emoji;
        return GestureDetector(
          onTap: () => onSelect(emoji),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.deepPurple : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildColorPicker(Function(Color) onSelect, Color selectedColor) {
    final colors = [
      Colors.red, Colors.pink, Colors.purple, Colors.deepPurple,
      Colors.indigo, Colors.blue, Colors.lightBlue, Colors.cyan,
      Colors.teal, Colors.green, Colors.lightGreen, Colors.lime,
      Colors.yellow, Colors.amber, Colors.orange, Colors.deepOrange,
      Colors.brown, Colors.grey, Colors.blueGrey, Colors.black,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(4),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            childAspectRatio: 1,
          ),
          itemCount: colors.length,
          itemBuilder: (context, index) {
            final color = colors[index];
            final isSelected = selectedColor.value == color.value;
            return GestureDetector(
              onTap: () => onSelect(color),
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
            );
          },
        ),
        Center(
          child: TextButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: const Color(0xFF2C2C2E),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  title: const Text(
                    "Advanced Color Picker",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: selectedColor,
                        onColorChanged: onSelect,
                        pickerAreaHeightPercent: 0.8,
                        labelTypes: const [],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: const Text("Close",
                          style: TextStyle(color: Colors.white70)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.palette, color: Colors.white70, size: 18),
            label: const Text("More colors",
                style: TextStyle(color: Colors.white70, fontSize: 13)),
          ),
        ),
      ],
    );
  }
}
