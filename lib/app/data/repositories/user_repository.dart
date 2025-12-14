import 'dart:math';
import 'package:uuid/uuid.dart';
import '../models/user_profile.dart';
import '../providers/database_provider.dart';

class UserRepository {
  final DatabaseProvider _dbProvider = DatabaseProvider();
  final _uuid = const Uuid();

  Future<UserProfile?> getUserProfile() async {
    final db = await _dbProvider.database;
    final maps = await db.query('user_profile', where: 'id = 1', limit: 1);

    if (maps.isEmpty) return null;
    return UserProfile.fromMap(maps.first);
  }

  Future<UserProfile> createUserProfile({String? name}) async {
    final db = await _dbProvider.database;
    final now = DateTime.now().millisecondsSinceEpoch;
    final referralCode = _generateReferralCode();

    final profile = UserProfile(
      name: name,
      referralCode: referralCode,
      createdAt: now,
      updatedAt: now,
    );

    await db.insert('user_profile', profile.toMap());
    return profile;
  }

  Future<UserProfile> updateUserProfile({
    String? name,
    String? email,
    String? profilePicturePath,
  }) async {
    final db = await _dbProvider.database;
    final now = DateTime.now().millisecondsSinceEpoch;

    final updates = <String, dynamic>{'updated_at': now, 'is_synced': 0};

    if (name != null) updates['name'] = name;
    if (email != null) updates['email'] = email;
    if (profilePicturePath != null)
      updates['profile_picture_path'] = profilePicturePath;

    await db.update('user_profile', updates, where: 'id = 1');

    return (await getUserProfile())!;
  }

  Future<void> updateReferredByCode(String code) async {
    final db = await _dbProvider.database;
    final now = DateTime.now().millisecondsSinceEpoch;

    await db.update('user_profile', {
      'referred_by_code': code,
      'updated_at': now,
      'is_synced': 0,
    }, where: 'id = 1');

    // Record the referral
    await db.insert('referrals', {
      'id': _uuid.v4(),
      'referral_code': code,
      'used_at': now,
    });
  }

  Future<String> getReferralCode() async {
    final profile = await getUserProfile();
    return profile?.referralCode ?? '';
  }

  Future<bool> checkIfReferralUsed() async {
    final profile = await getUserProfile();
    return profile?.referredByCode != null;
  }

  String _generateReferralCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(
      6,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }
}
