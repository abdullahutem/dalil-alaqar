import 'dart:convert';
import 'package:dalil_alaqar/core/databases/local/base_cached_data_source.dart';
import 'package:dalil_alaqar/core/databases/local/database_helper.dart';
import 'package:dalil_alaqar/core/utils/app_logger.dart';
import 'package:dalil_alaqar/features/profile/data/models/profile_model.dart';
import 'package:dalil_alaqar/features/profile/data/models/profile_user_model.dart';
import 'package:dalil_alaqar/features/profile/data/models/office_model.dart';

abstract class ProfileLocalDataSource {
  Future<ProfileModel?> getCachedProfile();
  Future<void> cacheProfile(ProfileModel profile);
  Future<void> clearProfile();
}

class ProfileLocalDataSourceImpl extends BaseCachedDataSource
    implements ProfileLocalDataSource {
  static const String _cacheKey = 'profile';
  static const Duration _defaultCacheAge = Duration(days: 7);

  ProfileLocalDataSourceImpl({required DatabaseHelper databaseHelper})
    : super(databaseHelper: databaseHelper);

  /// Check if profile cache is valid
  Future<bool> _isCacheValid({Duration? maxAge}) async {
    return super.isCacheValid(_cacheKey, maxAge: maxAge);
  }

  @override
  Future<ProfileModel?> getCachedProfile() async {
    try {
      // Check if cache is valid first
      if (!await _isCacheValid()) {
        AppLogger.cache('Profile cache is invalid or expired', 'Profile');
        return null;
      }

      final db = await databaseHelper.database;
      final result = await db.query('profile', limit: 1);

      if (result.isEmpty) {
        AppLogger.cache('No cached profile found', 'Profile');
        return null;
      }

      final json = result.first;
      final userJson =
          jsonDecode(json['user_json'] as String) as Map<String, dynamic>;
      final officeJson =
          jsonDecode(json['office_json'] as String) as Map<String, dynamic>;

      final profile = ProfileModel(
        user: ProfileUserModel.fromJson(userJson),
        office: OfficeModel.fromJson(officeJson),
      );

      AppLogger.success('Loaded profile from cache', 'Profile');
      return profile;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get cached profile', 'Profile', e, stackTrace);
      return null;
    }
  }

  @override
  Future<void> cacheProfile(ProfileModel profile) async {
    try {
      final db = await databaseHelper.database;

      AppLogger.database('Caching profile', 'Profile');

      // Use transaction for atomicity
      await db.transaction((txn) async {
        // Clear existing profile (only one record)
        await txn.delete('profile');

        // Insert new profile
        final cachedAt = DateTime.now().toIso8601String();
        await txn.insert('profile', {
          'id': 1, // Single profile record
          'user_json': jsonEncode((profile.user as ProfileUserModel).toJson()),
          'office_json': jsonEncode((profile.office as OfficeModel).toJson()),
          'cached_at': cachedAt,
        });

        // Update cache metadata
        await updateCacheMetadata(txn, _cacheKey, _defaultCacheAge);
      });

      AppLogger.success('Successfully cached profile', 'Profile');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to cache profile', 'Profile', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> clearProfile() async {
    try {
      final db = await databaseHelper.database;

      await db.transaction((txn) async {
        await txn.delete('profile');
        // Clear cache metadata as well
        await txn.delete(
          'cache_metadata',
          where: 'key = ?',
          whereArgs: [_cacheKey],
        );
      });

      AppLogger.info('Cleared profile cache', 'Profile');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to clear profile cache',
        'Profile',
        e,
        stackTrace,
      );
      rethrow;
    }
  }
}
