import 'package:craftworks_app/l10n/app_localizations.dart';
import 'package:craftworks_app/models/category.dart';
import 'package:craftworks_app/models/post.dart';
import 'package:craftworks_app/services/post_service.dart';
import 'package:flutter/material.dart';

class CategoryPostsView extends StatefulWidget {
  const CategoryPostsView({super.key, required Category category});

  @override
  State<CategoryPostsView> createState() => _CategoryPostsViewState();
}

class _CategoryPostsViewState extends State<CategoryPostsView> {
  late Future<List<Post>> _futurePosts;
  late Category _category;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _category = ModalRoute.of(context)!.settings.arguments as Category;
    _futurePosts = PostService().getPostsByCategory(_category.id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(_category.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearch(context),
          ),
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: _futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState(theme, localizations);
          }

          if (snapshot.hasError) {
            return _buildErrorState(
              theme,
              localizations,
              snapshot.error.toString(),
            );
          }

          final posts = snapshot.data!;
          if (posts.isEmpty) {
            return _buildEmptyState(theme, localizations);
          }

          return _buildPostsList(theme, posts, isDarkMode);
        },
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme, AppLocalizations localizations) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
          ),
          const SizedBox(height: 16),
          Text(localizations.loadingPosts, style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }

  Widget _buildErrorState(
    ThemeData theme,
    AppLocalizations localizations,
    String error,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              localizations.errorLoadingPosts,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => setState(() {
                _futurePosts = PostService().getPostsByCategory(_category.id);
              }),
              child: Text(localizations.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, AppLocalizations localizations) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hourglass_empty, size: 48, color: theme.disabledColor),
          const SizedBox(height: 16),
          Text(localizations.noPostsFound, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            localizations.noPostsInCategory,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPostsList(ThemeData theme, List<Post> posts, bool isDarkMode) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: posts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final post = posts[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _navigateToPostDetail(context, post),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 
                  if (post.imageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        post.imageUrl!,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 180,
                          color: theme.colorScheme.surfaceVariant,
                          child: Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 48,
                              color: theme.disabledColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
              
                  Text(
                    post.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                
                  Text(
                    post.description,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                 
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 16,
                        color: theme.disabledColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        post.author ?? 'Unknown Author',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: theme.disabledColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(post.createdAt),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _navigateToPostDetail(BuildContext context, Post post) {
    Navigator.pushNamed(context, '/post-detail', arguments: post);
  }

  void _showSearch(BuildContext context) {
    showSearch(context: context, delegate: _PostsSearchDelegate(_futurePosts));
  }
}

class _PostsSearchDelegate extends SearchDelegate {
  final Future<List<Post>> futurePosts;

  _PostsSearchDelegate(this.futurePosts);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: futurePosts,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

        final results = snapshot.data!
            .where(
              (post) =>
                  post.title.toLowerCase().contains(query.toLowerCase()) ||
                  post.description.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

        return _buildResultsList(context, results);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: futurePosts,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

        final results = snapshot.data!
            .where(
              (post) =>
                  post.title.toLowerCase().contains(query.toLowerCase()) ||
                  post.description.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

        return _buildResultsList(context, results);
      },
    );
  }

  Widget _buildResultsList(BuildContext context, List<Post> results) {
    if (results.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.noResultsFound,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final post = results[index];
        return ListTile(
          title: Text(post.title),
          subtitle: Text(post.description),
          onTap: () {
            Navigator.pushNamed(context, '/post-detail', arguments: post);
          },
        );
      },
    );
  }
}
