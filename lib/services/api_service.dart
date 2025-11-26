import 'dart:async';
import '../models/note_model.dart';

class ApiService {
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // --- MOCK DATABASE ---
  final List<Note> _mockNotes = [
    Note(
      id: '1',
      moodEmoji: '😊',
      title: 'Felt Great Today!',
      description: 'Had a really productive day at work and finished my big project. Feels good to have it done and ready to move on to new things!',
      createdAt: DateTime.now().subtract(const Duration(days: 0, hours: 2)),
      updatedAt: DateTime.now(),
    ),
    Note(
      id: '2',
      moodEmoji: '😢',
      title: 'Missing Home',
      description: 'Been away from family for a while now. Called mom today and it made me realize how much I miss everyone back home.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now(),
    ),
    Note(
      id: '3',
      moodEmoji: '😠',
      title: 'Frustrated',
      description: 'Traffic was terrible this morning and I was late to an important meeting. Need to find better ways to manage my commute.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now(),
    ),
    Note(
      id: '4',
      moodEmoji: '😮',
      title: 'Amazing News!',
      description: 'Just got accepted into the program I applied for! Can\'t believe it actually happened. This is going to change everything!',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now(),
    ),
    Note(
      id: '5',
      moodEmoji: '😐',
      title: 'Just Another Day',
      description: 'Nothing special happened today. Work was okay, came home, watched some TV. Sometimes boring days are good days too.',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      updatedAt: DateTime.now(),
    ),
    Note(
      id: '6',
      moodEmoji: '😊',
      title: 'Coffee with Friends',
      description: 'Met up with Sarah and Tom after so long. We laughed about old memories and made plans for a weekend trip!',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now(),
    ),
    Note(
      id: '7',
      moodEmoji: '😢',
      title: 'Tough Conversation',
      description: 'Had to have a difficult talk with someone today. It was necessary but that doesn\'t make it any easier to process.',
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
      updatedAt: DateTime.now(),
    ),
    Note(
      id: '8',
      moodEmoji: '😠',
      title: 'System Crashed',
      description: 'Lost hours of work because of a computer crash. Should have saved more frequently. Lesson learned the hard way.',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now(),
    ),
    Note(
      id: '9',
      moodEmoji: '😮',
      title: 'Unexpected Gift',
      description: 'Someone left a surprise gift at my door! Such a thoughtful gesture that completely made my day brighter.',
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
      updatedAt: DateTime.now(),
    ),
    Note(
      id: '10',
      moodEmoji: '😐',
      title: 'Rainy Evening',
      description: 'Spent the evening inside watching the rain. Sometimes it\'s nice to just exist without any particular plans or goals.',
      createdAt: DateTime.now().subtract(const Duration(days: 9)),
      updatedAt: DateTime.now(),
    ),
  ];

  // --- API METHODS ---

  // 1. GET ALL NOTES
  Future<List<Note>> getNotes() async {
    // Simulating network delay
    await Future.delayed(const Duration(milliseconds: 800));
    return _mockNotes;
  }

  // 2. CREATE NOTE
  Future<bool> createNote(String title, String description, String moodEmoji) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    
    final newNote = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      moodEmoji: moodEmoji,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    // Add to the top of the list
    _mockNotes.insert(0, newNote);
    return true; 
  }

  // 3. UPDATE NOTE
  Future<bool> updateNote(String id, String title, String description, String moodEmoji) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    
    final index = _mockNotes.indexWhere((n) => n.id == id);
    if (index != -1) {
      _mockNotes[index] = Note(
        id: id,
        title: title,
        description: description,
        moodEmoji: moodEmoji,
        createdAt: _mockNotes[index].createdAt,
        updatedAt: DateTime.now(),
      );
      return true;
    }
    return false;
  }

  // 4. DELETE NOTE
  Future<bool> deleteNote(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockNotes.removeWhere((n) => n.id == id);
    return true;
  }
  
  // 5. GET STATS
  Future<Map<String, dynamic>> getStats() async {
     await Future.delayed(const Duration(milliseconds: 500));
     return {
       'total_entries': _mockNotes.length,
       'frequent_mood': '😊',
       'weekly_entries': [5, 3, 7, 4, 6, 2, 1], // Mon-Sun (Mock data)
     };
  }
}