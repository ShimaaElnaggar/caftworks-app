class ClientProfile {
  final String id;
  final String userId;

  ClientProfile({required this.id, required this.userId});

  factory ClientProfile.fromJson(Map<String, dynamic> json) {
    return ClientProfile(
      id: json['_id'],
      userId: json['user_id'],
    );
  }
}

class User {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String country;
  final String? profileImage;
  final double? rating;
  final int? ratingCount;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.country,
    this.profileImage,
    this.rating,
    this.ratingCount,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      fullName: json['full_name'],
      email: json['email'],
      phone: json['phone'],
      country: json['country'] ?? 'Egypt',
      profileImage: json['profile_image'],
      rating: (json['rating'] is num) ? (json['rating'] as num).toDouble() : null,
      ratingCount: json['rating_count'],
    );
  }
} 