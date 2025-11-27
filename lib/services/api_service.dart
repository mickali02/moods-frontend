import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note_model.dart';

class User {
  final String token;
  final String email;
  final String name;

  User({required this.token, required this.email, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['authentication_token']?['token'] ?? '',
      email: json['user']?['email'] ?? '',
      name: json['user']?['name'] ?? '',
    );
  }
}

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // --- 1. BASE URL ---
  // Use 10.0.2.2 for Android Emulator, or your IP for physical device
  static const String baseUrl = 'http://10.0.2.2:4000/v1'; 

  User? _currentUser;

  String get currentUserName {
    if (_currentUser == null) return "Friend";
    if (_currentUser!.name.isNotEmpty) return _currentUser!.name;
    if (_currentUser!.email.isNotEmpty) return _currentUser!.email.split('@')[0];
    return "Friend";
  }

  // --- 2. CHECK LOGIN STATUS ---
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('auth_token')) return false;

    final token = prefs.getString('auth_token') ?? '';
    final email = prefs.getString('auth_email') ?? '';
    final name = prefs.getString('auth_name') ?? '';

    _currentUser = User(token: token, email: email, name: name);
    return true;
  }

  // --- AUTH ---
  Future<void> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/tokens/authentication');
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      String token = data['authentication_token']['token'];
      
      _currentUser = User(
        token: token,
        email: email,
        name: '', 
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('auth_email', email);
      
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'Login failed.');
    }
  }

  Future<void> signup(String username, String email, String password) async {
    final url = Uri.parse('$baseUrl/users');
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': username, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201 || response.statusCode == 202) {
      return; 
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'Signup failed');
    }
  }

  // --- 4. LOGOUT METHOD ---
  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); 
  }

  // --- DATA ---
  Future<List<Note>> getNotes() async {
    if (_currentUser == null) {
      bool loggedIn = await tryAutoLogin();
      if (!loggedIn) return [];
    }
    
    final url = Uri.parse('$baseUrl/moods');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${_currentUser!.token}'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> moodsJson = data['moods'] ?? [];
      
      return moodsJson.map((json) {
        return Note(
          id: json['id'].toString(),
          title: json['title'] ?? '',
          description: json['content'] ?? '',
          moodEmoji: json['emoji'] ?? '😐',
          createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }).toList();
    }
    return [];
  }

  Future<void> createNote(String title, String description, String moodEmoji) async {
    if (_currentUser == null) return;

    final url = Uri.parse('$baseUrl/moods');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_currentUser!.token}',
      },
      body: jsonEncode({
        'title': title,
        'content': description,
        'emoji': moodEmoji,
        'emotion': 'Neutral',
        'color': '#000000',
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to save mood');
    }
  }

  Future<void> deleteNote(String id) async {
    if (_currentUser == null) return;
    final url = Uri.parse('$baseUrl/moods/$id');
    await http.delete(
      url, 
      headers: {'Authorization': 'Bearer ${_currentUser!.token}'}
    );
  }

  // --- QUOTES ---
  Future<String> getDailyQuote() async {
    try {
      final url = Uri.parse('https://api.quotable.io/random?maxLength=50');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return '"${data['content']}"';
      }
    } catch (e) {
      // Silently fail
    }
    return '"Believe you can and you\'re halfway there."';
  }

  // --- STATS (This is now correctly inside the class) ---
  Future<Map<String, dynamic>> getStats() async {
    // 1. Simulate a network delay
    await Future.delayed(const Duration(seconds: 1));

    // 2. Return DUMMY DATA for now
    return {
      'total_entries': 12,
      'frequent_mood': 'Happy',
      // Data for Mon, Tue, Wed, Thu, Fri, Sat, Sun
      'weekly_entries': [3, 5, 2, 0, 4, 1, 2], 
    };
  }

} // <--- The class closes HERE