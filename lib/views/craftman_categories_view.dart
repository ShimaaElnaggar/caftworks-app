import 'dart:convert';

import 'package:craftworks_app/l10n/app_localizations.dart';
import 'package:craftworks_app/models/category.dart';
import 'package:craftworks_app/services/category_services.dart';
import 'package:craftworks_app/services/preferences_services.dart';
import 'package:flutter/material.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  List<Category> _categories = [];
  List<Category> _recommendedCategories = [];
  bool _isLoading = true;
  String _userName = "John Doe";

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadRecommendations();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final userString = PreferencesServices.getString('user');

    if (userString != null) {
      final user = jsonDecode(userString);
      setState(() {
        _userName = user['full_name'] ?? 'User';
      });
    }
  }

  Future<void> _handleLogout() async {
    await PreferencesServices.remove('token');
    await PreferencesServices.remove('user');

    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Future<void> _loadCategories() async {
    final categories = await CategoryService().fetchCategories();
    setState(() {
      _categories = categories.cast<Category>();
      _isLoading = false;
    });
  }

  Future<void> _loadRecommendations() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _recommendedCategories = [
        Category(
          id: 'r1',
          name: 'Summer Special',
          description: 'Limited time offers',
          icon: '',
          subcategories: [],
        ),
        Category(
          id: 'r2',
          name: 'Best Sellers',
          description: 'Top picks this month',
          icon: '',
          subcategories: [],
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.categoriesTitle),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context, theme, localizations),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                if (_recommendedCategories.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        localizations.recommendedForYou,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (_recommendedCategories.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final category = _recommendedCategories[index];
                        return _buildCategoryCard(context, category, true);
                      }, childCount: _recommendedCategories.length),
                    ),
                  ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                    child: Text(
                      localizations.allCategories,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final category = _categories[index];
                      return _buildCategoryCard(context, category, false);
                    }, childCount: _categories.length),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    Category category,
    bool isRecommended,
  ) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.pushNamed(context, '/category-posts', arguments: category);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: isRecommended
                ? LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withOpacity(0.7),
                      theme.colorScheme.secondary.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isRecommended ? null : theme.cardColor,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.category,
                size: 40,
                color: isRecommended ? Colors.white : theme.primaryColor,
              ),
              const SizedBox(height: 8),
              Text(
                category.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isRecommended ? Colors.white : null,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                category.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: isRecommended
                      ? Colors.white70
                      : theme.textTheme.bodySmall?.color,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.category),
          label: AppLocalizations.of(context)!.categoriesTitle,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: AppLocalizations.of(context)!.home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.favorite),
          label: AppLocalizations.of(context)!.favorites,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: AppLocalizations.of(context)!.profile,
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/craftsman_start');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/favorites');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/profile');
            break;
        }
      },
    );
  }

  Widget _buildDrawer(
    BuildContext context,
    ThemeData theme,
    AppLocalizations localizations,
  ) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: theme.primaryColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Text(
                    _userName[0].toUpperCase(),
                    style: const TextStyle(fontSize: 24, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _userName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Premium Member',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(localizations.home),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: Text(localizations.categoriesTitle),
            selected: true,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: Text(localizations.orders),
            onTap: () {
              Navigator.pushNamed(context, '/orders');
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: Text(localizations.favorites),
            onTap: () {
              Navigator.pushNamed(context, '/favorites');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(localizations.settings),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: Text(localizations.help),
            onTap: () {
              Navigator.pushNamed(context, '/help');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(localizations.logout),
            onTap: _handleLogout,
          ),
        ],
      ),
    );
  }
}
