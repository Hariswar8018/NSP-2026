class ViewText {
  final String id;
  final String name;

  ViewText({
    required this.id,
    required this.name,
  });

  /// Save to Firestore / JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  /// Read from Firestore / JSON
  factory ViewText.fromJson(Map<String, dynamic> map) {
    return ViewText(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
    );
  }

  @override
  String toString() => name;
}
