class Category {
  final String id;
  final String name;
  final String icon;
  final String description;
  final List<String> subcategories;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.subcategories,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? json['_id'], 
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      description: json['description'] ?? '',
      subcategories: List<String>.from(json['subcategories'] ?? []),
    );
  }
}
