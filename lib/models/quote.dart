// lib/models/quote.dart

// This class defines the structure of a Quote object.
// It matches the JSON keys your Go backend sends.
class Quote {
  final String text;
  final String author;

  // Constructor for the class.
  Quote({required this.text, required this.author});

  // A special 'factory' constructor that creates a Quote
  // instance from a JSON map. This is how we will parse the
  // data from the API response.
  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      text: json['q'] as String,    // Maps the 'q' key from JSON to the 'text' field
      author: json['a'] as String, // Maps the 'a' key from JSON to the 'author' field
    );
  }
}