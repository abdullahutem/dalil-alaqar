import 'package:dalil_alaqar/core/databases/local/base_cached_data_source.dart';
import 'package:dalil_alaqar/core/databases/local/database_helper.dart';
import 'package:dalil_alaqar/core/utils/app_logger.dart';
import 'package:dalil_alaqar/features/office_info/data/models/office_info_model.dart';

abstract class OfficeInfoLocalDataSource {
  Future<OfficeInfoModel?> getCachedOfficeInfo();
  Future<void> cacheOfficeInfo(OfficeInfoModel officeInfo);
  Future<void> clearOfficeInfo();
}

class OfficeInfoLocalDataSourceImpl extends BaseCachedDataSource
    implements OfficeInfoLocalDataSource {
  static const String _cacheKey = 'office_info';
  static const Duration _defaultCacheAge = Duration(days: 7);

  OfficeInfoLocalDataSourceImpl({required DatabaseHelper databaseHelper})
    : super(databaseHelper: databaseHelper);

  /// Check if office info cache is valid
  Future<bool> _isCacheValid({Duration? maxAge}) async {
    return super.isCacheValid(_cacheKey, maxAge: maxAge);
  }

  @override
  Future<OfficeInfoModel?> getCachedOfficeInfo() async {
    try {
      // Check if cache is valid first
      if (!await _isCacheValid()) {
        AppLogger.cache(
          'Office info cache is invalid or expired',
          'OfficeInfo',
        );
        return null;
      }

      final db = await databaseHelper.database;
      final result = await db.query('office_info', limit: 1);

      if (result.isEmpty) {
        AppLogger.cache('No cached office info found', 'OfficeInfo');
        return null;
      }

      final json = result.first;
      final officeInfo = OfficeInfoModel(
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        whatsappNumber: json['whatsapp_number'] as String?,
        website: json['website'] as String?,
        facebook: json['facebook'] as String?,
        instagram: json['instagram'] as String?,
        twitter: json['twitter'] as String?,
        description: json['description'] as String?,
        address: json['address'] as String?,
        logo: json['logo'] as String?,
        logoUrl: json['logo_url'] as String?,
        status: json['status'] as String,
        createdAt: json['created_at'] as String,
        updatedAt: json['updated_at'] as String,
      );

      AppLogger.success('Loaded office info from cache', 'OfficeInfo');
      return officeInfo;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get cached office info',
        'OfficeInfo',
        e,
        stackTrace,
      );
      return null;
    }
  }

  @override
  Future<void> cacheOfficeInfo(OfficeInfoModel officeInfo) async {
    try {
      final db = await databaseHelper.database;

      AppLogger.database('Caching office info', 'OfficeInfo');

      // Use transaction for atomicity
      await db.transaction((txn) async {
        // Clear existing office info (only one record)
        await txn.delete('office_info');

        // Insert new office info
        final cachedAt = DateTime.now().toIso8601String();
        await txn.insert('office_info', {
          'id': officeInfo.id,
          'name': officeInfo.name,
          'email': officeInfo.email,
          'phone': officeInfo.phone,
          'whatsapp_number': officeInfo.whatsappNumber,
          'website': officeInfo.website,
          'facebook': officeInfo.facebook,
          'instagram': officeInfo.instagram,
          'twitter': officeInfo.twitter,
          'description': officeInfo.description,
          'address': officeInfo.address,
          'logo': officeInfo.logo,
          'logo_url': officeInfo.logoUrl,
          'status': officeInfo.status,
          'created_at': officeInfo.createdAt,
          'updated_at': officeInfo.updatedAt,
          'cached_at': cachedAt,
        });

        // Update cache metadata
        await updateCacheMetadata(txn, _cacheKey, _defaultCacheAge);
      });

      AppLogger.success('Successfully cached office info', 'OfficeInfo');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to cache office info',
        'OfficeInfo',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<void> clearOfficeInfo() async {
    try {
      final db = await databaseHelper.database;

      await db.transaction((txn) async {
        await txn.delete('office_info');
        // Clear cache metadata as well
        await txn.delete(
          'cache_metadata',
          where: 'key = ?',
          whereArgs: [_cacheKey],
        );
      });

      AppLogger.info('Cleared office info cache', 'OfficeInfo');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to clear office info cache',
        'OfficeInfo',
        e,
        stackTrace,
      );
      rethrow;
    }
  }
}
