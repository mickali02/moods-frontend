import 'package:flutter/material.dart';
import 'add_mood_page.dart';
import 'stats_page.dart';
import 'settings_page.dart';
import 'edit_note_page.dart';

enum FilterOption { title, emotion }

void main() {
  runApp(const MyApp());
}

// Simple Mood class
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
      home: const HomePageController(),
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

  // Example mood list
  final List<Mood> _availableMoods = [
    Mood(emoji: '😊', name: 'Happy', color: Colors.green),
    Mood(emoji: '😢', name: 'Sad', color: Colors.blue),
    Mood(emoji: '😠', name: 'Angry', color: Colors.red),
    Mood(emoji: '😮', name: 'Surprised', color: Colors.orange),
    Mood(emoji: '😐', name: 'Neutral', color: Colors.grey),
  ];

  // Diverse dummy data with different moods
  final List<Map<String, String>> _dummyNotes = [
    {
      'emoji': '😊',
      'title': 'Felt Great Today!',
      'description': 'Had a really productive day at work and finished my big project. Feels good to have it done and ready to move on to new things!'
    },
    {
      'emoji': '😢',
      'title': 'Missing Home',
      'description': 'Been away from family for a while now. Called mom today and it made me realize how much I miss everyone back home.'
    },
    {
      'emoji': '😠',
      'title': 'Frustrated',
      'description': 'Traffic was terrible this morning and I was late to an important meeting. Need to find better ways to manage my commute.'
    },
    {
      'emoji': '😮',
      'title': 'Amazing News!',
      'description': 'Just got accepted into the program I applied for! Can\'t believe it actually happened. This is going to change everything!'
    },
    {
      'emoji': '😐',
      'title': 'Just Another Day',
      'description': 'Nothing special happened today. Work was okay, came home, watched some TV. Sometimes boring days are good days too.'
    },
    {
      'emoji': '😊',
      'title': 'Coffee with Friends',
      'description': 'Met up with Sarah and Tom after so long. We laughed about old memories and made plans for a weekend trip!'
    },
    {
      'emoji': '😢',
      'title': 'Tough Conversation',
      'description': 'Had to have a difficult talk with someone today. It was necessary but that doesn\'t make it any easier to process.'
    },
    {
      'emoji': '😠',
      'title': 'System Crashed',
      'description': 'Lost hours of work because of a computer crash. Should have saved more frequently. Lesson learned the hard way.'
    },
    {
      'emoji': '😮',
      'title': 'Unexpected Gift',
      'description': 'Someone left a surprise gift at my door! Such a thoughtful gesture that completely made my day brighter.'
    },
    {
      'emoji': '😐',
      'title': 'Rainy Evening',
      'description': 'Spent the evening inside watching the rain. Sometimes it\'s nice to just exist without any particular plans or goals.'
    },
  ];

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
                    return RadioListTile<FilterOption>(
                      title: Text(option.name[0].toUpperCase() + option.name.substring(1)),
                      value: option,
                      groupValue: selectedOption,
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedOption = value;
                          });
                        }
                      },
                    );
                  }).toList(),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                      ),
                      TextButton(
                        onPressed: () {
                          debugPrint('Applying filter: ${selectedOption.name}');
                          Navigator.of(context).pop();
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

  void _showNotePopup(BuildContext context, String mood, String title, String description) {
    // Mock timestamps
    final createdDate = DateTime.now().subtract(const Duration(days: 2, hours: 3));
    final updatedDate = DateTime.now().subtract(const Duration(hours: 5));

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withAlpha(220),
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF1a1a1a),
          insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 160),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFC5A8FF).withAlpha(80), width: 1.5),
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
                          child: const Icon(Icons.close, color: Colors.grey, size: 22),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        mood,
                        style: const TextStyle(fontSize: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          title,
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
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(80),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 14, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(
                              'Created: ${_formatDateTime(createdDate)}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.edit_outlined, size: 14, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(
                              'Updated: ${_formatDateTime(updatedDate)}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 15, color: Colors.white, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 22, color: Color(0xFFC5A8FF)),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditNotePage(
                                initialTitle: title,
                                initialDescription: description,
                                initialMood: mood,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 22, color: Colors.redAccent),
                        onPressed: () {},
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
                        style: TextStyle(fontSize: 15, color: Colors.white.withAlpha(220)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search moods...',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          prefixIcon: Icon(Icons.search, size: 22, color: Colors.grey.shade400),
                          contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
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
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                  itemCount: _dummyNotes.length,
                  itemBuilder: (context, index) {
                    final note = _dummyNotes[index];
                    final noteMood = note['emoji']!;
                    final noteTitle = note['title']!;
                    final noteDescription = note['description']!;

                    // Find the mood color for this note
                    final Mood mood = _availableMoods.firstWhere(
                      (m) => m.emoji == noteMood,
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
                          onTap: () => _showNotePopup(context, noteMood, noteTitle, noteDescription),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: mood.color.withAlpha(80),
                                      borderRadius: BorderRadius.circular(14),
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
                                      noteMood,
                                      style: const TextStyle(fontSize: 26),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          noteTitle,
                                          style: const TextStyle(
                                            fontSize: 16.5,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          noteDescription.length > 70
                                              ? "${noteDescription.substring(0, 70)}..."
                                              : noteDescription,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}