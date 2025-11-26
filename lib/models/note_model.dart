
class Note {
  final String id; // Backend will generate this
  final String title;
  final String description;
  final String moodEmoji; // storing the emoji is easier for now
  final DateTime createdAt;
  final DateTime updatedAt;

  Note({
    required this.id,
    required this.title,
    required this.description,
    required this.moodEmoji,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory to create a Note from JSON (Backend response)
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      moodEmoji: json['moodEmoji'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Method to convert Note to JSON (Sending to Backend)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'moodEmoji': moodEmoji,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}