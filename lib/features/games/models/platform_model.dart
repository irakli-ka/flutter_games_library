class Platform {
  final int id;
  final String name;
  final String slug;

  Platform({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory Platform.fromJson(Map<String, dynamic> json) {
    final platformData = json['platform'] ?? json;
    return Platform(
      id: platformData['id'] ?? 0,
      name: platformData['name'] ?? '',
      slug: platformData['slug'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
    };
  }
}