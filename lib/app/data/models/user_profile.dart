class UserProfile {
  final int id;
  final String? name;
  final String? email;
  final String? profilePicturePath;
  final String referralCode;
  final String? referredByCode;
  final int isSynced;
  final String? serverId;
  final int createdAt;
  final int updatedAt;

  UserProfile({
    this.id = 1,
    this.name,
    this.email,
    this.profilePicturePath,
    required this.referralCode,
    this.referredByCode,
    this.isSynced = 0,
    this.serverId,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile_picture_path': profilePicturePath,
      'referral_code': referralCode,
      'referred_by_code': referredByCode,
      'is_synced': isSynced,
      'server_id': serverId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as int? ?? 1,
      name: map['name'] as String?,
      email: map['email'] as String?,
      profilePicturePath: map['profile_picture_path'] as String?,
      referralCode: map['referral_code'] as String,
      referredByCode: map['referred_by_code'] as String?,
      isSynced: map['is_synced'] as int? ?? 0,
      serverId: map['server_id'] as String?,
      createdAt: map['created_at'] as int,
      updatedAt: map['updated_at'] as int,
    );
  }

  String get displayName => name ?? 'Traveler';

  String get avatarLetter {
    if (name != null && name!.isNotEmpty) {
      return name![0].toUpperCase();
    }
    return 'T';
  }

  bool get isComplete => name != null && name!.isNotEmpty;

  UserProfile copyWith({
    String? name,
    String? email,
    String? profilePicturePath,
    String? referredByCode,
    int? isSynced,
    int? updatedAt,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePicturePath: profilePicturePath ?? this.profilePicturePath,
      referralCode: referralCode,
      referredByCode: referredByCode ?? this.referredByCode,
      isSynced: isSynced ?? this.isSynced,
      serverId: serverId,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (value.length > 50) {
      return 'Name must be less than 50 characters';
    }
    final nameRegex = RegExp(r"^[a-zA-Z\s\-']+$");
    if (!nameRegex.hasMatch(value)) {
      return 'Name can only contain letters, spaces, hyphens, and apostrophes';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Email is optional
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }
}
