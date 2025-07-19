import 'package:flutter/material.dart';
import '../core/constants/app_theme.dart';
import 'post_request.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/animation.dart';
import '../../l10n/app_localizations.dart';
import 'settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 
  List<dynamic> popularServices = [];
  List<dynamic> categories = [];
  bool isLoadingServices = false;
  bool isLoadingCategories = false;
  String? servicesError;
  String? categoriesError;
  int? selectedCategoryIndex;
  bool showTopRatedOnly = false;
  bool isFetchingCategory = false;

  int _selectedIndex = 0;

  //user information in bar
  String? userName;
  String? userAvatar;
  bool isLoadingUser = false;
  String? userError;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    fetchCategories();
    fetchPopularServices();
  }

  Future<void> fetchUserInfo() async {
    setState(() {
      isLoadingUser = true;
      userError = null;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      if (token == null) {
        setState(() {
          userError = 'Not logged in.';
        });
        return;
      }
      final url = Uri.parse('http://192.168.1.2:5000/api/users/me');
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer ' + token,
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userName = data['full_name'] ?? 'User';
          userAvatar = data['profile_image'];
        });
      } else {
        setState(() {
          userError = 'Failed to load user info.';
        });
      }
    } catch (e) {
      setState(() {
        userError = 'Network error: ' + e.toString();
      });
    } finally {
      setState(() {
        isLoadingUser = false;
      });
    }
  }

  Future<void> fetchPopularServices({String? categoryId}) async {
    setState(() {
      isLoadingServices = true;
      isFetchingCategory = categoryId != null;
      servicesError = null;
    });
    try {
      Uri url;
      if (categoryId != null) {
        url = Uri.parse('http://192.168.1.2:5000/api/services/categories/$categoryId/craftsmen');
      } else {
        url = Uri.parse('http://192.168.1.2:5000/api/craftsman-profiles');
      }
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          popularServices = categoryId != null ? data['data'] : data;
        });
      } else {
        setState(() {
          servicesError = 'Failed to load craftsmen.';
        });
      }
    } catch (e) {
      setState(() {
        servicesError = 'Network error: $e';
      });
    } finally {
      setState(() {
        isLoadingServices = false;
        isFetchingCategory = false;
      });
    }
  }

  Future<void> fetchCategories() async {
    setState(() {
      isLoadingCategories = true;
      categoriesError = null;
    });
    try {
      final url = Uri.parse('http://192.168.1.2:5000/api/services/categories');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          categories = jsonDecode(response.body);
        });
      } else {
        setState(() {
          categoriesError = 'Failed to load categories.';
        });
      }
    } catch (e) {
      setState(() {
        categoriesError = 'Network error: $e';
      });
    } finally {
      setState(() {
        isLoadingCategories = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.foreground,
      appBar: AppBar(
        backgroundColor: AppColors.foreground,
        elevation: 0,
        toolbarHeight: 70,
        title: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: [
                if (isLoadingUser)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else if (userError != null)
                  Text(
                    userError!,
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                  )
                else
                  Flexible(
                    child: Row(
                      children: [
                        const Text(
                          '👋 ',
                          style: TextStyle(fontSize: 24),
                        ),
                        Flexible(
                          child: Text(
                            userName != null ? 'Hello, ' + userName! : 'Hello',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary900Light),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.search, color: AppColors.primaryLight, size: 28),
                  onPressed: () {
                  },
                  tooltip: 'Search',
                ),
              ],
            );
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        color: AppColors.foreground,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _PromoBanner(),

             
              const Text(
                'Popular',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary900Light),
              ),
              Row(
                children: [
                  Checkbox(
                    value: showTopRatedOnly,
                    onChanged: (val) {
                      setState(() {
                        showTopRatedOnly = val ?? false;
                      });
                    },
                  ),
                  const Text('Show only top-rated (4.5+)'),
                ],
              ),
              const SizedBox(height: 10),
              if (isLoadingServices)
                const Center(child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: CircularProgressIndicator(),
                ))
              else if (servicesError != null)
                Center(child: Text(servicesError!, style: TextStyle(color: Colors.red)))
              else if (popularServices.isEmpty)
                const Center(child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text('No craftsmen found for this category.', style: TextStyle(color: Colors.grey)),
                ))
              else
                SizedBox(
                  height: 200,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: (showTopRatedOnly
                        ? popularServices.where((service) {
                            final user = service['user_id'] ?? {};
                            final rating = user['rating'] is num ? user['rating'].toDouble() : 0.0;
                            return rating >= 4.5;
                          }).toList().length
                        : popularServices.length),
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final filtered = showTopRatedOnly
                          ? popularServices.where((service) {
                              final user = service['user_id'] ?? {};
                              final rating = user['rating'] is num ? user['rating'].toDouble() : 0.0;
                              return rating >= 4.5;
                            }).toList()
                          : popularServices;
                      final service = filtered[index];
                      final user = service['user_id'] ?? {};
                      final String name = user['full_name'] ?? 'Unknown';
                      final String? profileImage = user['profile_image'];
                      final String bio = service['bio'] ?? '';
                      final double rating = user['rating'] is num ? user['rating'].toDouble() : 0.0;
                      final bool isTopRated = rating >= 4.5;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 170,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.mutedLight.withOpacity(0.12),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                          border: isTopRated
                              ? Border.all(color: AppColors.primaryLight, width: 2)
                              : null,
                        ),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  child: (profileImage != null && profileImage != '')
                                      ? Image.network(
                                          profileImage,
                                          height: 100,
                                          width: 170,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Image.asset(
                                              'assets/images/imageboarding3.png',
                                              height: 100,
                                              width: 170,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        )
                                      : Image.asset(
                                          'assets/images/imageboarding3.png',
                                          height: 100,
                                          width: 170,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: AppColors.primary900Light,
                                            ),
                                          ),
                                          if (isTopRated)
                                            Container(
                                              margin: const EdgeInsets.only(left: 6),
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: AppColors.primaryLight,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: const Text(
                                                'Top Rated',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        bio,
                                        style: const TextStyle(
                                          color: AppColors.mutedForegroundLight,
                                          fontSize: 13,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.star, color: AppColors.warningLight, size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                            rating.toStringAsFixed(1),
                                            style: const TextStyle(fontSize: 14, color: AppColors.primary900Light),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 20),
         
              const Text(
                'Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                 color: AppColors.primary900Light),
              ),
              const SizedBox(height: 10),
              if (isLoadingCategories)
                const Center(child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: CircularProgressIndicator(),
                ))
              else if (categoriesError != null)
                Center(child: Text(categoriesError!, style: TextStyle(color: Colors.red)))
              else
                SizedBox(
                  height: 110,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      final categoryId = cat['id'] ?? cat['_id'];
                      final bool isSelected = selectedCategoryIndex == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        width: 100,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryLight : AppColors.primary100Light,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.mutedLight.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(
                            color: isSelected ? AppColors.primary700Light : AppColors.primary600,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            setState(() {
                              selectedCategoryIndex = index;
                            });
                            fetchPopularServices(categoryId: categoryId);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primary100Light : AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: cat['icon'] != null
                                    ? Icon(Icons.category, size: 32, color: AppColors.primaryLight)
                                    : Icon(Icons.category, size: 32, color: AppColors.primary600),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                cat['name'] ?? '',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isSelected ? AppColors.primary900Light : AppColors.primary600,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 1) {
            //how it works tab
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PostRequestPage()),
            );
          } else if (index == 3) {
            Navigator.pushNamed(context, '/Home');
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.mutedForeground,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
         BottomNavigationBarItem(
           icon: Icon(Icons.info_outline),
           label: 'How it works',
         ),
          BottomNavigationBarItem(
            icon: Container(
              decoration: const BoxDecoration(
                color: AppColors.primaryLight, 
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryLight,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.add,
                size: 36,
                color: AppColors.primaryForegroundLight, 
              ),
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Orders',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.card,
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8, bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary100Light,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Opacity(
              opacity: 0.2,
              child: Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.percent,
                  size: 120, 
                  color: AppColors.primary700Light,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '20% Off on your\nfirst request!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary900Light,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Book now',
                  style: TextStyle(color: AppColors.primaryForegroundLight),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

