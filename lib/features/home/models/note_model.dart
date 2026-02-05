class NoteModel {
  final String? id;
  final String? userId;
  final String title;
  final String text;
  final DateTime? createdAt;

  NoteModel({
    this.id,
    this.userId,
    required this.title,
    required this.text,
    this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'title': title,
    'text': text,
    'createdAt': createdAt?.toIso8601String(),
  };

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      title: json['title'] as String,
      text: json['text'] as String,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }
}
