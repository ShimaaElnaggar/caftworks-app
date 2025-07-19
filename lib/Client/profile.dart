import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/client_profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/constants/app_theme.dart';
import '../l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ClientProfileScreen extends StatefulWidget {
  final void Function(Locale)? onLocaleChange;
  final void Function(ThemeMode)? onThemeModeChange;
  final ThemeMode? themeMode;
  
  const ClientProfileScreen({
    Key? key,
    this.onLocaleChange,
    this.onThemeModeChange,
    this.themeMode,
  }) : super(key: key);

  @override
  State<ClientProfileScreen> createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen> {
  User? user;
  ClientProfile? profile;
  bool isLoading = true;
  String? error;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      if (token == null) {
        setState(() {
          error = 'Not logged in.';
          isLoading = false;
        });
        return;
      }
      //user information from sign upp
      final userRes = await http.get(
        Uri.parse('http://192.168.1.2:5000/api/users/me'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (userRes.statusCode != 200) {
        setState(() {
          error = 'Failed to load user info.';
          isLoading = false;
        });
        return;
      }
      final profileRes = await http.get(
        Uri.parse('http://192.168.1.2:5000/api/client-profiles/me'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (profileRes.statusCode == 404) {
        setState(() {
          error = 'no_profile';
          isLoading = false;
        });
        return;
      } else if (profileRes.statusCode != 200) {
        setState(() {
          error = 'Failed to load client profile.';
          isLoading = false;
        });
        return;
      }
      user = User.fromJson(jsonDecode(userRes.body));
      profile = ClientProfile.fromJson(jsonDecode(profileRes.body));
      nameController.text = user!.fullName;
      phoneController.text = user!.phone;
    } catch (e) {
      setState(() {
        error = 'Failed to load profile.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> createProfile() async {
    setState(() { isLoading = true; });
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      if (token == null) {
        setState(() {
          error = 'Not logged in.';
          isLoading = false;
        });
        return;
      }
      final res = await http.post(
        Uri.parse('http://192.168.1.2:5000/api/client-profiles'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: '{}',
      );
      if (res.statusCode == 201 || res.statusCode == 200) {
        await fetchProfile();
      } else {
        setState(() {
          error = 'Failed to create profile.';
        });
      }
    } catch (e) {
      setState(() {
        error = 'Failed to create profile.';
      });
    } finally {
      setState(() { isLoading = false; });
    }
  }

  Future<void> saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      if (token == null) {
        setState(() {
          error = 'Not logged in.';
          isLoading = false;
        });
        return;
      }
      final res = await http.put(
        Uri.parse('http://192.168.1.2:5000/api/users/me'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'full_name': nameController.text,
          'phone': phoneController.text,
        }),
      );
      if (res.statusCode == 200) {
        user = User.fromJson(jsonDecode(res.body));
        final loc = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.profile_updated)),
        );
      } else {
        final loc = AppLocalizations.of(context)!;
        setState(() {
          error = loc.failed_to_update_profile;
        });
      }
    } catch (e) {
      final loc = AppLocalizations.of(context)!;
      setState(() {
        error = loc.failed_to_update_profile;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('user_id');
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SvgPicture.asset(
            'assets/images/herfa_logo_blue.svg',
            height: 60,
            colorFilter: const ColorFilter.mode(
              Color(0xFF33367D),
              BlendMode.srcIn,
            ),
          ),
        ),
        backgroundColor: AppColors.foreground,
        elevation: 0,
      ),
      backgroundColor: AppColors.foreground,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error == 'no_profile'
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('No client profile found. Create one to continue.'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: isLoading ? null : createProfile,
                        child: const Text('Create Profile'),
                      ),
                    ],
                  ),
                )
              : error != null
                  ? Center(child: Text(error!, style: const TextStyle(color: Colors.red)))
                  : user == null
                      ? const Center(child: Text('No profile found.'))
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                color: AppColors.cardLight,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 48,
                                        backgroundColor: AppColors.primary100Light,
                                        child: Image.asset(
                                          'assets/images/imageboarding3.png',
                                          width: 96,
                                          height: 96,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        nameController.text,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: AppColors.primary900Light,
                                        ),
                                      ),
                                      if (user!.rating != null)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 6),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.star, color: Colors.amber, size: 20),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${user!.rating!.toStringAsFixed(1)} (${user!.ratingCount ?? 0} reviews)',
                                                style: const TextStyle(fontSize: 15, color: AppColors.primary700Light),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 28),                       
                              Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                color: AppColors.cardLight,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: nameController,
                                          decoration: const InputDecoration(
                                            labelText: 'Full Name',
                                            prefixIcon: Icon(Icons.person),
                                          ),
                                          validator: (v) => v == null || v.isEmpty ? 'Name required' : null,
                                        ),
                                        const SizedBox(height: 16),
                                        TextFormField(
                                          controller: phoneController,
                                          decoration: const InputDecoration(
                                            labelText: 'Phone',
                                            prefixIcon: Icon(Icons.phone),
                                          ),
                                          validator: (v) => v == null || v.isEmpty ? 'Phone required' : null,
                                        ),
                                        const SizedBox(height: 20),
                                        TextFormField(
                                          initialValue: user!.email,
                                          decoration: const InputDecoration(
                                            labelText: 'Email',
                                            prefixIcon: Icon(Icons.email),
                                          ),
                                          readOnly: true,
                                        ),
                                        const SizedBox(height: 16),
                                        TextFormField(
                                          initialValue: user!.country,
                                          decoration: const InputDecoration(
                                            labelText: 'Country',
                                            prefixIcon: Icon(Icons.flag),
                                          ),
                                          readOnly: true,
                                        ),
                                        const SizedBox(height: 28),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: isLoading ? null : saveProfile,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.primaryLight,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              padding: const EdgeInsets.symmetric(vertical: 16),
                                            ),
                                            child: isLoading
                                                ? const SizedBox(
                                                    width: 24,
                                                    height: 24,
                                                    child: CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 2,
                                                    ),
                                                  )
                                                : Text(
                                                    loc.save_changes,
                                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryForegroundLight),
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 28),
                              Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                color: AppColors.cardLight,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        loc.settings,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary900Light,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      ListTile(
                                        leading: const Icon(Icons.language, color: AppColors.primaryLight),
                                        title: Text(loc.language),
                                        trailing: DropdownButton<String>(
                                          value: Localizations.localeOf(context).languageCode,
                                          onChanged: (String? newValue) {
                                            if (newValue != null && widget.onLocaleChange != null) {
                                              widget.onLocaleChange!(Locale(newValue));
                                            }
                                          },
                                          items: [
                                            DropdownMenuItem(
                                              value: 'en',
                                              child: Text(loc.english),
                                            ),
                                            DropdownMenuItem(
                                              value: 'ar',
                                              child: Text(loc.arabic),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.brightness_6, color: AppColors.primaryLight),
                                        title: Text(loc.theme),
                                        trailing: DropdownButton<ThemeMode>(
                                          value: widget.themeMode ?? ThemeMode.system,
                                          onChanged: (ThemeMode? newValue) {
                                            if (newValue != null && widget.onThemeModeChange != null) {
                                              widget.onThemeModeChange!(newValue);
                                            }
                                          },
                                          items: [
                                            DropdownMenuItem(
                                              value: ThemeMode.system,
                                              child: Text(loc.system),
                                            ),
                                            DropdownMenuItem(
                                              value: ThemeMode.light,
                                              child: Text(loc.light_mode),
                                            ),
                                            DropdownMenuItem(
                                              value: ThemeMode.dark,
                                              child: Text(loc.dark_mode),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(),
                                      ListTile(
                                        leading: const Icon(Icons.logout, color: AppColors.destructiveLight),
                                        title: Text(
                                          loc.logout,
                                          style: const TextStyle(color: AppColors.destructiveLight),
                                        ),
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(loc.logout),
                                                content: Text('Are you sure you want to logout?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.of(context).pop(),
                                                    child: Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                      logout();
                                                    },
                                                    child: Text(loc.logout),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
    );
  }
}

extension UserCopyWith on User {
  User copyWith({String? fullName, String? phone, String? profileImage}) {
    return User(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email,
      phone: phone ?? this.phone,
      country: country,
      profileImage: profileImage ?? this.profileImage,
      rating: rating,
      ratingCount: ratingCount,
    );
  }
} 