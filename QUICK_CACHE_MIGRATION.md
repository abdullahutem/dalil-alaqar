# Quick Cache Migration Reference

## 🎯 Three-Step Migration

### 1. Update Class Declaration

```dart
class YourLocalDataSourceImpl extends BaseCachedDataSource
    implements YourLocalDataSource {
  static const String _cacheKey = 'your_feature';
  static const Duration _defaultCacheAge = Duration(days: 7);

  YourLocalDataSourceImpl({required DatabaseHelper databaseHelper})
      : super(databaseHelper: databaseHelper);
}
```

### 2. Add to getCached Method

```dart
// Add private helper
Future<bool> _isCacheValid({Duration? maxAge}) async {
  return super.isCacheValid(_cacheKey, maxAge: maxAge);
}

// At the start of getCached
if (!await _isCacheValid()) {
  AppLogger.cache('Cache expired', 'YourFeature');
  return null;
}

// At the end (success)
AppLogger.success('Loaded ${items.length} items from cache', 'YourFeature');

// In catch block
AppLogger.error('Failed to get cached items', 'YourFeature', e, stackTrace);
```

### 3. Wrap cache Method in Transaction

```dart
await db.transaction((txn) async {
  await txn.delete('your_table');
  
  for (final item in items) {
    await txn.insert('your_table', {...});
  }
  
  // Add this!
  await updateCacheMetadata(txn, _cacheKey, _defaultCacheAge);
});
```

## 📦 Required Imports

```dart
import 'package:dalil_alaqar/core/databases/local/base_cached_data_source.dart';
import 'package:dalil_alaqar/core/utils/app_logger.dart';
```

## 🔄 Abstract Class Updates

```dart
abstract class YourLocalDataSource {
  Future<List<YourModel>?> getCached(); // Add ? for nullable
  Future<void> cache(List<YourModel> items);
  Future<void> clear();
  // No need to add isCacheValid - it's a private helper
}
```

## ⏱️ Cache Durations

| Data Type | Duration |
|-----------|----------|
| Static (categories, locations) | 30-60 days |
| Semi-static (offices, promotions) | 7 days |
| Dynamic (properties list) | 1-6 hours |
| Frequently changing (rates) | 1 day |

## 🎨 Logger Quick Reference

```dart
AppLogger.info('message', 'Tag');
AppLogger.success('message', 'Tag');
AppLogger.warning('message', 'Tag');
AppLogger.error('message', 'Tag', e, stackTrace);
AppLogger.database('message', 'Tag');
AppLogger.cache('message', 'Tag');
```

## ✅ Don't Forget

1. Make return type nullable: `Future<List<Model>?>` not `Future<List<Model>>`
2. Add private `_isCacheValid()` helper method (not in abstract class)
3. Call `updateCacheMetadata()` inside transaction
4. Handle null in repository: `if (cached == null || cached.isEmpty)`
5. Replace all `print()` with `AppLogger.*`

## 🔍 Example Repository Change

```dart
// Before
if (cachedItems.isEmpty) { ... }

// After
if (cachedItems == null || cachedItems.isEmpty) { ... }
```

---

**Full Guide:** See `CACHE_ENHANCEMENT_GUIDE.md`

**Example:** See `lib/features/promotions/data/datasources/promotions_local_data_source.dart`
