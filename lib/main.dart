import 'package:flutter/material.dart';
import 'add_mood_page.dart';
import 'stats_page.dart';
import 'settings_page.dart';
import 'edit_note_page.dart';

// --- NEW IMPORT FOR LOGIN ---
import 'login_page.dart';

// --- IMPORTS FOR BACKEND CONNECTION ---
import 'models/note_model.dart';
import 'services/api_service.dart';

enum FilterOption { title, emotion }

void main() {
  runApp(const MyApp());
}

// Simple Mood class for UI colors/names (Front-end only helper)
class Mood {
  final String emoji;
  final String name;
  final Color color;

  Mood({required this.emoji, required this.name, required this.color});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moods Frontend',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      // --- UPDATE: App now starts at LoginPage ---
      home: const LoginPage(),
    );
  }
}

class HomePageController extends StatefulWidget {
  const HomePageController({super.key});

  @override
  State<HomePageController> createState() => _HomePageControllerState();
}

class _HomePageControllerState extends State<HomePageController> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    MyHomePage(),
    AddMoodPage(),
    StatsPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _pages.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFC5A8FF),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        // Note: If withAlpha gives you warnings, replace with .withValues(alpha: 0.7)
        backgroundColor: Colors.black.withAlpha(178),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FilterOption selectedOption = FilterOption.title;

  // --- SERVICE & DATA VARIABLES ---
  final ApiService _apiService = ApiService();
  late Future<List<Note>> _notesFuture;

  // Example mood list for UI Mapping (Colors/Names)
  final List<Mood> _availableMoods = [
    Mood(emoji: '😊', name: 'Happy', color: Colors.green),
    Mood(emoji: '😢', name: 'Sad', color: Colors.blue),
    Mood(emoji: '😠', name: 'Angry', color: Colors.red),
    Mood(emoji: '😮', name: 'Surprised', color: Colors.orange),
    Mood(emoji: '😐', name: 'Neutral', color: Colors.grey),
  ];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  // Fetch data from the Service
  void _loadNotes() {
    setState(() {
      _notesFuture = _apiService.getNotes();
    });
  }

  void _openFilterPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2c2c2c),
          title: const Text('Filter by'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...FilterOption.values.map((option) {
                    final isSelected = selectedOption == option;
                    return ListTile(
                      title: Text(option.name[0].toUpperCase() +
                          option.name.substring(1)),
                      leading: Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: isSelected
                            ? const Color(0xFFC5A8FF)
                            : Colors.grey,
                      ),
                      onTap: () {
                        setDialogState(() {
                          selectedOption = option;
                        });
                      },
                    );
                  }),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel',
                            style: TextStyle(color: Colors.grey)),
                      ),
                      TextButton(
                        onPressed: () {
                          debugPrint('Applying filter: ${selectedOption.name}');
                          Navigator.of(context).pop();
                          // In a real app, pass filter to _apiService.getNotes(filter: ...)
                        },
                        child: const Text('Apply'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // Updated to take the full Note object
  void _showNotePopup(BuildContext context, Note note) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withAlpha(220),
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF1a1a1a),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 32, vertical: 160),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: const Color(0xFFC5A8FF).withAlpha(80), width: 1.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: const Icon(Icons.close,
                              color: Colors.grey, size: 22),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        note.moodEmoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          note.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(80),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(
                              'Created: ${_formatDateTime(note.createdAt)}',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.edit_outlined,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(
                              'Updated: ${_formatDateTime(note.updatedAt)}',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    note.description,
                    style: const TextStyle(
                        fontSize: 15, color: Colors.white, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit,
                            size: 22, color: Color(0xFFC5A8FF)),
                        onPressed: () async {
                          Navigator.pop(context);
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditNotePage(
                                initialTitle: note.title,
                                initialDescription: note.description,
                                initialMood: note.moodEmoji,
                              ),
                            ),
                          );
                          if (!context.mounted) return;
                          _loadNotes(); // Refresh list after edit returns
                        },
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete,
                            size: 22, color: Colors.redAccent),
                        onPressed: () async {
                          // Connect delete logic here
                          await _apiService.deleteNote(note.id);
                          
                          if (!context.mounted) return;
                          
                          Navigator.pop(context);
                          _loadNotes(); // Refresh list
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
      final period = dateTime.hour >= 12 ? 'PM' : 'AM';
      return 'Today at ${hour == 0 ? 12 : hour}:${dateTime.minute.toString().padLeft(2, '0')} $period';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/wallpaper.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(160),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFC5A8FF).withAlpha(60),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Welcome back, Mickali! ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFC5A8FF),
                            ),
                          ),
                          Text("🙂", style: TextStyle(fontSize: 20)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "How are you feeling today?",
                        style: TextStyle(
                            fontSize: 15, color: Colors.white.withAlpha(220)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search moods...',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          prefixIcon: Icon(Icons.search,
                              size: 22, color: Colors.grey.shade400),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 18.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: Colors.black.withAlpha(130),
                          filled: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(130),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.filter_list, size: 24),
                        onPressed: () => _openFilterPopup(context),
                        tooltip: 'Filter Options',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // --- FUTURE BUILDER REPLACES HARDCODED LIST ---
              Expanded(
                child: FutureBuilder<List<Note>>(
                  future: _notesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFFC5A8FF)));
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text("Error: ${snapshot.error}",
                              style: const TextStyle(color: Colors.white70)));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text("No moods yet. Tap + to add one!",
                              style: TextStyle(color: Colors.white70)));
                    }

                    final notes = snapshot.data!;

                    return RefreshIndicator(
                      onRefresh: () async => _loadNotes(),
                      color: const Color(0xFFC5A8FF),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 20.0),
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          final note = notes[index];

                          // Find the mood color based on the emoji from the backend
                          final Mood mood = _availableMoods.firstWhere(
                            (m) => m.emoji == note.moodEmoji,
                            orElse: () => _availableMoods.first,
                          );

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withAlpha(200),
                                  Colors.black.withAlpha(170),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(
                                color: mood.color.withAlpha(120),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: mood.color.withAlpha(100),
                                  blurRadius: 12,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16.0),
                                onTap: () => _showNotePopup(context, note),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    gradient: LinearGradient(
                                      colors: [
                                        mood.color.withAlpha(25),
                                        Colors.transparent,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: mood.color.withAlpha(80),
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            border: Border.all(
                                              color: mood.color.withAlpha(150),
                                              width: 2,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: mood.color.withAlpha(80),
                                                blurRadius: 8,
                                                spreadRadius: 1,
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            note.moodEmoji,
                                            style:
                                                const TextStyle(fontSize: 26),
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                note.title,
                                                style: const TextStyle(
                                                  fontSize: 16.5,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                note.description.length > 70
                                                    ? "${note.description.substring(0, 70)}..."
                                                    : note.description,
                                                style: TextStyle(
                                                  fontSize: 13.5,
                                                  color: Colors.grey.shade300,
                                                  height: 1.4,
                                                ),
                                              ),
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
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}