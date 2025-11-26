import 'dart:async';
import '../models/note_model.dart';

// 1. ADD A USER MODEL (Backend needs this)
class User {
  final String id;
  final String username;
  final String email;
  final String token; // For authentication

  User({required this.id, required this.username, required this.email, required this.token});
}

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // --- MOCK DATA ---
  User? _currentUser; // Store logged in user here
  
  final List<Note> _mockNotes = [
    Note(
      id: '1',
      moodEmoji: '😊',
      title: 'Felt Great Today!',
      description: 'Had a really productive day...',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      updatedAt: DateTime.now(),
    ),
    // ... (keep your other mock notes)
  ];

  // --- AUTH METHODS (NEW!) ---

  Future<User?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    // Mock successful login
    if (email.isNotEmpty && password.length >= 6) {
      _currentUser = User(
        id: 'user_123', 
        username: 'Mickali', 
        email: email, 
        token: 'fake_jwt_token_xyz'
      );
      return _currentUser;
    }
    throw Exception('Invalid credentials');
  }

  Future<User?> signup(String username, String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    _currentUser = User(
      id: 'user_456', 
      username: username, 
      email: email, 
      token: 'fake_jwt_token_abc'
    );
    return _currentUser;
  }

  void logout() {
    _currentUser = null;
  }

  // --- NOTE METHODS ---

  Future<List<Note>> getNotes() async {
    await Future.delayed(const Duration(milliseconds: 800));
    // In real backend, you would send 'Authorization': 'Bearer ${_currentUser?.token}'
    return _mockNotes;
  }

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
    _mockNotes.insert(0, newNote);
    return true; 
  }

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

  Future<bool> deleteNote(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockNotes.removeWhere((n) => n.id == id);
    return true;
  }
  
  // --- STATS METHOD (Connects to Stats Page) ---
  Future<Map<String, dynamic>> getStats() async {
     await Future.delayed(const Duration(milliseconds: 500));
     
     // Calculate real stats from _mockNotes (UI updates dynamically!)
     int happyCount = _mockNotes.where((n) => n.moodEmoji == '😊').length;
     int sadCount = _mockNotes.where((n) => n.moodEmoji == '😢').length;
     
     return {
       'total_entries': _mockNotes.length,
       'frequent_mood': _mockNotes.isNotEmpty ? _mockNotes[0].moodEmoji : '😐',
       'mood_counts': {
         'Happy': happyCount,
         'Sad': sadCount,
         // ... others
       },
       'weekly_data': [5, 3, 7, 4, 6, 2, 1], // Backend usually calculates this
     };
  }
}