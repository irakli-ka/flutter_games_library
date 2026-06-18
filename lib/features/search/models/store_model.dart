class Store {
  final int id;
  final String name;
  final String slug;

  Store({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }
}