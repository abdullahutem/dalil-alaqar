# Cache Enhancement Implementation Guide

This guide shows how to enhance your local data sources with the new cache validation, transaction safety, and proper logging.

## ✅ What's Been Implemented

1. **Cache Metadata Table** - Added to DatabaseHelper (version 18)
2. **Base Cached Data Source** - `BaseCachedDataSource` class with cache validation
3. **App Logger** - Proper logging utility replacing print statements
4. **Example Implementation** - Promotions feature fully updated

## 📋 Migration Checklist for Each Feature

Use this checklist when updating other features (offices, properties, advertisements, etc.):

### Step 1: Update Import Statements

```dart
// Add these imports
import 'package:dalil_alaqar/core/databases/local/base_cached_data_source.dart';
import 'package:dalil_alaqar/core/utils/app_logger.dart';
```

### Step 2: Extend BaseCachedDataSource

**Before:**
```dart
class OfficesLocalDataSourceImpl implements OfficesLocalDataSource {
  final DatabaseHelper databaseHelper;

  OfficesLocalDataSourceImpl({required this.databaseHelper});
}
```

**After:**
```dart
class OfficesLocalDataSourceImpl extends BaseCachedDataSource
    implements OfficesLocalDataSource {
  static const String _cacheKey = 'offices'; // Unique key for this feature
  static const Duration _defaultCacheAge = Duration(days: 7); // Or customize

  OfficesLocalDataSourceImpl({required DatabaseHelper databaseHelper})
      : super(databaseHelper: databaseHelper);
}
```

### Step 3: Add Cache Validation Helper

Add this private helper method to your implementation:

```dart
/// Check if cache is valid
Future<bool> _isCacheValid({Duration? maxAge}) async {
  return super.isCacheValid(_cacheKey, maxAge: maxAge);
}
```

**Note:** Don't add `isCacheValid` to the abstract class - it's a private helper in the implementation.

### Step 4: Update getCached Method

**Before:**
```dart
@override
Future<List<OfficeModel>> getCachedOffices() async {
  final db = await databaseHelper.database;
  final result = await db.query('offices', orderBy: 'id ASC');

  return result.map((json) {
    return OfficeModel(...);
  }).toList();
}
```

**After:**
```dart
@override
Future<List<OfficeModel>?> getCachedOffices() async {
  try {
    // Check if cache is valid first
    if (!await _isCacheValid()) {
      AppLogger.cache('Offices cache is invalid or expired', 'Offices');
      return null;
    }

    final db = await databaseHelper.database;
    final result = await db.query('offices', orderBy: 'id ASC');

    if (result.isEmpty) {
      AppLogger.cache('No cached offices found', 'Offices');
      return null;
    }

    final offices = result.map((json) {
      return OfficeModel(...);
    }).toList();

    AppLogger.success(
      'Loaded ${offices.length} offices from cache',
      'Offices',
    );
    return offices;
  } catch (e, stackTrace) {
    AppLogger.error(
      'Failed to get cached offices',
      'Offices',
      e,
      stackTrace,
    );
    return null;
  }
}
```

**Before:**
```dart
@override
Future<List<OfficeModel>> getCachedOffices() async {
  final db = await databaseHelper.database;
  final result = await db.query('offices', orderBy: 'id ASC');

  return result.map((json) {
    return OfficeModel(...);
  }).toList();
}
```

**After:**
```dart
@override
Future<List<OfficeModel>?> getCachedOffices() async {
  try {
    // Check if cache is valid first
    if (!await isCacheValid()) {
      AppLogger.cache('Offices cache is invalid or expired', 'Offices');
      return null;
    }

    final db = await databaseHelper.database;
    final result = await db.query('offices', orderBy: 'id ASC');

    if (result.isEmpty) {
      AppLogger.cache('No cached offices found', 'Offices');
      return null;
    }

    final offices = result.map((json) {
      return OfficeModel(...);
    }).toList();

    AppLogger.success(
      'Loaded ${offices.length} offices from cache',
      'Offices',
    );
    return offices;
  } catch (e, stackTrace) {
    AppLogger.error(
      'Failed to get cached offices',
      'Offices',
      e,
      stackTrace,
    );
    return null;
  }
}
```

### Step 5: Update cache Method with Transactions

**Before:**
```dart
@override
Future<void> cacheOffices(List<OfficeModel> offices) async {
  final db = await databaseHelper.database;
  
  print('💾 Caching ${offices.length} offices');
  
  await db.delete('offices');
  
  for (final office in offices) {
    await db.insert('offices', {...});
  }
  
  print('✅ Successfully cached');
}
```

**After:**
```dart
@override
Future<void> cacheOffices(List<OfficeModel> offices) async {
  try {
    final db = await databaseHelper.database;

    AppLogger.database(
      'Caching ${offices.length} offices',
      'Offices',
    );

    // Use transaction for atomicity
    await db.transaction((txn) async {
      // Clear existing data
      await txn.delete('offices');

      // Insert new data
      final cachedAt = DateTime.now().toIso8601String();
      for (final office in offices) {
        await txn.insert('offices', {
          // ... all fields
          'cached_at': cachedAt,
        });
      }

      // Update cache metadata
      await updateCacheMetadata(txn, _cacheKey, _defaultCacheAge);
    });

    AppLogger.success(
      'Successfully cached ${offices.length} offices',
      'Offices',
    );
  } catch (e, stackTrace) {
    AppLogger.error(
      'Failed to cache offices',
      'Offices',
      e,
      stackTrace,
    );
    rethrow;
  }
}
```

### Step 6: Update clear Method

**Before:**
```dart
@override
Future<void> clearOffices() async {
  final db = await databaseHelper.database;
  await db.delete('offices');
}
```

**After:**
```dart
@override
Future<void> clearOffices() async {
  try {
    final db = await databaseHelper.database;

    await db.transaction((txn) async {
      await txn.delete('offices');
      // Clear cache metadata as well
      await txn.delete(
        'cache_metadata',
        where: 'key = ?',
        whereArgs: [_cacheKey],
      );
    });

    AppLogger.info('Cleared offices cache', 'Offices');
  } catch (e, stackTrace) {
    AppLogger.error(
      'Failed to clear offices cache',
      'Offices',
      e,
      stackTrace,
    );
    rethrow;
  }
}
```

### Step 7: Update Repository to Handle Null

In your repository implementation, handle the nullable return:

**Before:**
```dart
final cachedOffices = await localDataSource.getCachedOffices();

if (cachedOffices.isEmpty) {
  return Left(CacheFailure(message: 'No cached data'));
}
```

**After:**
```dart
final cachedOffices = await localDataSource.getCachedOffices();

if (cachedOffices == null || cachedOffices.isEmpty) {
  return Left(CacheFailure(message: 'No cached data'));
}
```

## 📊 Cache Duration Recommendations

Choose appropriate cache durations for each feature:

| Feature | Recommended Duration | Reason |
|---------|---------------------|---------|
| Categories | 30-60 days | Rarely changes |
| Promotions | 7 days | Changes weekly |
| Properties | 1 hour | Changes frequently |
| Property Details | 6 hours | Moderate changes |
| Offices | 7 days | Changes occasionally |
| Advertisements/Sliders | 1 day | Daily updates |
| Currencies | 1 day | Daily rate updates |
| Governorates/Districts | 60 days | Static data |

## 🎨 Logger Usage Examples

```dart
// Info messages
AppLogger.info('Starting operation', 'FeatureName');

// Success messages
AppLogger.success('Operation completed', 'FeatureName');

// Warnings (non-critical issues)
AppLogger.warning('Cache outdated, refreshing', 'FeatureName');

// Errors (with exception and stack trace)
AppLogger.error('Failed to fetch data', 'FeatureName', e, stackTrace);

// Database operations
AppLogger.database('Inserting 10 records', 'FeatureName');

// Network operations
AppLogger.network('Fetching from API', 'FeatureName');

// Cache operations
AppLogger.cache('Cache hit', 'FeatureName');
```

## 🔄 For JSON-Based Storage (Properties, Property Details)

If you're using JSON storage approach, you still benefit from:

1. **Cache validation** - Same as column-based
2. **Transactions** - Ensures atomic updates
3. **Logging** - Proper debug information

Example for properties_cache table:

```dart
class PropertiesLocalDataSourceImpl extends BaseCachedDataSource
    implements PropertiesLocalDataSource {
  static const String _cacheKey = 'properties';
  static const Duration _defaultCacheAge = Duration(hours: 6);

  PropertiesLocalDataSourceImpl({required DatabaseHelper databaseHelper})
      : super(databaseHelper: databaseHelper);

  /// Check if cache is valid
  Future<bool> _isCacheValid({Duration? maxAge}) async {
    return super.isCacheValid(_cacheKey, maxAge: maxAge);
  }

  @override
  Future<String?> getCachedPropertiesJson() async {
    try {
      // Check if cache is valid
      if (!await _isCacheValid()) {
        AppLogger.cache('Properties cache expired', 'Properties');
        return null;
      }

      final db = await databaseHelper.database;
      final result = await db.query('properties_cache', limit: 1);

      if (result.isEmpty) {
        return null;
      }

      AppLogger.success('Loaded properties from cache', 'Properties');
      return result.first['data_json'] as String;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get cached properties', 'Properties', e, stackTrace);
      return null;
    }
  }

  @override
  Future<void> cachePropertiesJson(String jsonData) async {
    try {
      final db = await databaseHelper.database;

      AppLogger.database('Caching properties JSON', 'Properties');

      await db.transaction((txn) async {
        await txn.delete('properties_cache');

        final cachedAt = DateTime.now().toIso8601String();
        await txn.insert('properties_cache', {
          'id': 1,
          'data_json': jsonData,
          'cached_at': cachedAt,
        });

        // Update cache metadata
        await updateCacheMetadata(txn, _cacheKey, _defaultCacheAge);
      });

      AppLogger.success('Successfully cached properties', 'Properties');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to cache properties', 'Properties', e, stackTrace);
      rethrow;
    }
  }
}
```

## ✅ Features Priority Order

Migrate in this order based on usage and impact:

1. ✅ **Promotions** - Already done (example implementation)
2. 🔲 **Properties** - High usage, frequently cached
3. 🔲 **Property Details** - High usage
4. 🔲 **Offices** - Medium usage
5. 🔲 **Office Properties** - Medium usage
6. 🔲 **Advertisements/Sliders** - Medium usage
7. 🔲 **Employees** - Low usage
8. 🔲 **Currencies** - Low usage but important
9. 🔲 **Governorates/Districts/Neighborhoods** - Low priority (static data)

## 🧪 Testing Your Changes

After updating each feature:

1. ✅ Clear app data completely
2. ✅ Launch app and verify data loads from API
3. ✅ Close and reopen app - verify data loads from cache
4. ✅ Wait past cache expiration - verify fresh data fetched
5. ✅ Turn off internet - verify cached data still available
6. ✅ Check logs for proper messages

## 📝 Notes

- The `cache_metadata` table will be created automatically on next app launch (database migration)
- All existing data will be preserved
- Users won't notice any changes except better performance
- Logs only appear in debug mode (removed in release builds)
- You can customize cache duration per feature based on your needs

## 🚀 Benefits After Migration

1. ✅ **Cache Expiration** - Stale data automatically detected
2. ✅ **Transaction Safety** - No more partial cache updates
3. ✅ **Better Logging** - Easy debugging and monitoring
4. ✅ **Consistent Pattern** - All features follow same approach
5. ✅ **Null Safety** - Proper handling of missing/invalid cache
6. ✅ **Performance** - Early return when cache is invalid
7. ✅ **Production Ready** - No print statements in production

## 🔗 Reference Implementation

See `lib/features/promotions/data/datasources/promotions_local_data_source.dart` for the complete example.

## 💡 Tips

- Keep cache keys unique and descriptive (use feature name)
- Choose cache duration based on data change frequency
- Always use transactions for write operations
- Handle null returns gracefully in repositories
- Add appropriate log tags for easier filtering
- Test both online and offline scenarios

---

**Need Help?** Check the promotions implementation for a working example!
