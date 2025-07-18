
import 'package:craftworks_app/models/post.dart';

class PostService {
  Future<List<Post>> getPostsByCategory(String categoryId) async {
    await Future.delayed(const Duration(seconds: 1));

    return List.generate(10, (index) {
      return Post(
        id: '$categoryId-$index',
        title: 'Post ${index + 1} in Category $categoryId',
        description:
            'This is a detailed description of post ${index + 1} in this category. '
            'It contains interesting content about the topic.',
        categoryId: categoryId,
        createdAt: DateTime.now().subtract(Duration(days: index)),
        author: 'Author ${index % 3 + 1}',
        imageUrl: index % 3 == 0
            ? 'https://picsum.photos/500/300?random=$index'
            : null,
      );
    });
  }
}
