import 'package:flutter/material.dart';
import 'add_mood_page.dart';
import 'stats_page.dart';
import 'settings_page.dart';
import 'edit_note_page.dart'; // ✨ NEW: Import the edit page

enum FilterOption { title, emotion }

void main() {
  runApp(const MyApp());
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

  // ✨ NEW: Added EditNotePage to this list for completeness, though it's not used by the nav bar.
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
                  // This part for the filter popup remains the same.
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
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search moods...',
                          prefixIcon: const Icon(Icons.search, size: 22),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: Colors.black.withAlpha(102),
                          filled: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.filter_list, size: 26),
                      onPressed: () => _openFilterPopup(context),
                      tooltip: 'Filter Options',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    // ✨ NEW: Define dummy data for the note. In a real app, this would
                    // come from a list of note objects, like `myNotes[index]`.
                    const String noteMood = '😊';
                    const String noteTitle = 'Felt Great Today!';
                    const String noteDescription = 'Had a really productive day at work and finished my big project. Feels good to have it done!';

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 8.0),
                      child: Card(
                        color: Colors.black.withAlpha(140),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$noteMood $noteTitle', // Display mood and title
                                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              // ✨ NEW: Added a description to the card to show what will be edited.
                              Text(
                                noteDescription,
                                style: TextStyle(fontSize: 14, color: Colors.grey.shade300),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Created: 2025-11-12 | Edited: 2025-11-12',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // ✨ NEW: This is the main change. The onPressed callback is updated.
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 22),
                                    onPressed: () {
                                      // This is where the magic happens!
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditNotePage(
                                            // We pass the note's data to the edit page.
                                            initialTitle: noteTitle,
                                            initialDescription: noteDescription,
                                            initialMood: noteMood,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(icon: const Icon(Icons.delete, size: 22), onPressed: () {}),
                                ],
                              )
                            ],
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