class FairyTale {
  final int id;
  final String title;
  final String story;
  final List<String> tags;

  FairyTale({
    required this.id,
    required this.title,
    required this.story,
    required this.tags,
  });

  // Factory metoda pro převod JSON do objektu FairyTale
  factory FairyTale.fromJson(Map<String, dynamic> json) {
    return FairyTale(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      title: json['title'],
      story: json['story'],
      tags: (json['tags'] is Map && json['tags']['tags'] != null)
          ? List<String>.from(json['tags']['tags'])
          : (json['tags'] is List)
              ? List<String>.from(json['tags'])
              : [],
    );
  }

  // Metoda pro převod objektu FairyTale zpět do JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'story': story,
      'tags': tags, // tady pošleme jen přímo seznam tagů
    };
  }
}
