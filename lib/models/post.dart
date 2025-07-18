class Post {
  final String id;
  final String title;
  final String description;
  final String categoryId;
  final DateTime createdAt;
  final String author;
  final String? imageUrl;

  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.createdAt,
    required this.author,
    this.imageUrl,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      categoryId: json['category'],
      createdAt: DateTime.parse(json['createdAt']),
      author: json['author'] ?? 'Unknown Author',
      imageUrl: json['image'] != null ? json['image']['url'] : null,
    );
  }
}
