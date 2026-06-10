# 📖 Caching Quick Reference Guide

Quick reference for developers working with the cached features in Dalil Alaqar.

---

## 🎯 Cached Features Overview

| Feature | Cache Duration | Strategy | Database Version |
|---------|----------------|----------|------------------|
| Advertisements | 48h | Full list | v1-3 |
| Offices | 24h | First page only | v4 |
| Office Details | 48h | Per-office ID | v5 |
| Property Types | 72h | Full list | v6 |
| Properties | 12h | First page only | v7 |
| Property Details | 24h | Per-property ID | v8 |
| Promotions | 48h | Full list | v9 |
| Dashboard | 6h | Stats only | v10 |
| Employees | 24h | Full list + invalidation | v11 |
| Currencies | 72h | Full list | v12 |
| Districts | 72h | Per-governorate ID | v13 |
| Governorates | 72h | Full list | v14 |
| Neighborhoods | 72h | Per-district ID | v15 |
| **Office Properties** | - | **NOT CACHED** | v16 (structure only) |

---

## ⚡ Quick Actions

### Check if Feature is Cached
```dart
// Look for these files:
lib/features/[feature]/data/datasources/[feature]_local_data_source.dart

// If exists → cached
// If missing → not cached
```

### Find Cache Duration
```dart
// In local data source file, look for:
final cacheDuration = Duration(hours: XX);
```

### Test Offline Functionality
1. Open app with internet
2. Navigate to feature
3. Turn off internet/wifi
4. Navigate back to feature
5. Should see cached data

### Clear Cache for Testing
```dart
// Option 1: Uninstall/reinstall app
// Option 2: Call clear method in local data source
await localDataSource.clearCache();
```

---

## 🔧 Common Tasks

### Add Caching to New Feature

**Step 1: Create Local Data Source**
```dart
// lib/features/[feature]/data/datasources/[feature]_local_data_source.dart

abstract class FeatureLocalDataSource {
  Future<List<FeatureModel>> getCached();
  Future<void> cache(List<FeatureModel> items);
  Future<void> clear();
}

class FeatureLocalDataSourceImpl implements FeatureLocalDataSource {
  final DatabaseHelper databaseHelper;
  static const _cacheDuration = Duration(hours: 24); // Adjust as needed

  FeatureLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<FeatureModel>> getCached() async {
    final db = await databaseHelper.database;
    final result = await db.query('feature_table');
    return result.map((json) => FeatureModel.fromJson(json)).toList();
  }

  @override
  Future<void> cache(List<FeatureModel> items) async {
    final db = await databaseHelper.database;
    await db.delete('feature_table'); // Clear old data
    
    final cachedAt = DateTime.now().toIso8601String();
    for (final item in items) {
      await db.insert('feature_table', {
        ...item.toJson(),
        'cached_at': cachedAt,
      });
    }
  }

  @override
  Future<void> clear() async {
    final db = await databaseHelper.database;
    await db.delete('feature_table');
  }
}
```

**Step 2: Update Database Helper**
```dart
// lib/core/databases/local/database_helper.dart

// 1. Increment version
version: 17, // Was 16

// 2. Add table creation in onCreate
Future _createDB(Database db, int version) async {
  // ... existing tables ...
  
  if (version >= 17) {
    await _createFeatureTable(db);
  }
}

// 3. Add migration in onUpgrade
Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
  // ... existing migrations ...
  
  if (oldVersion < 17) {
    await _createFeatureTable(db);
  }
}

// 4. Create table method
Future _createFeatureTable(Database db) async {
  await db.execute('''
    CREATE TABLE feature_table (
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      description TEXT,
      cached_at TEXT NOT NULL
    )
  ''');
}
```

**Step 3: Update Repository**
```dart
// lib/features/[feature]/data/repositories/[feature]_repository_impl.dart

class FeatureRepositoryImpl implements FeatureRepository {
  final FeatureRemoteDataSource remoteDataSource;
  final FeatureLocalDataSource localDataSource; // Add this
  final NetworkInfo networkInfo;

  FeatureRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource, // Add this
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ResponseEntity>> getFeatures() async {
    // No internet → return cache
    if (!(await networkInfo.isConnected ?? false)) {
      return _getCachedData();
    }

    try {
      // Try API
      final result = await remoteDataSource.getFeatures();
      // Cache success
      await localDataSource.cache(result.data);
      return Right(result);
    } on ServerException catch (e) {
      // API failed → fallback to cache
      return _getCachedData();
    }
  }

  Future<Either<Failure, ResponseEntity>> _getCachedData() async {
    try {
      final cached = await localDataSource.getCached();
      if (cached.isEmpty) {
        return Left(Failure(errMessage: 'لا توجد بيانات محفوظة'));
      }
      return Right(ResponseEntity(data: cached));
    } catch (e) {
      return Left(Failure(errMessage: 'خطأ في قراءة البيانات المحفوظة'));
    }
  }
}
```

**Step 4: Update Cubit Factory**
```dart
// lib/features/[feature]/presentation/cubit/[feature]_cubit.dart

factory FeatureCubit.create() {
  final apiConsumer = DioConsumer(dio: Dio());
  final remoteDataSource = FeatureRemoteDataSourceImpl(
    apiConsumer: apiConsumer,
  );
  final localDataSource = FeatureLocalDataSourceImpl(
    databaseHelper: DatabaseHelper.instance, // Add this
  );
  final networkInfo = NetworkInfoImpl(DataConnectionChecker());
  final repository = FeatureRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource, // Add this
    networkInfo: networkInfo,
  );
  final useCase = GetFeaturesUseCase(repository);
  return FeatureCubit(getFeaturesUseCase: useCase);
}
```

---

## 🐛 Troubleshooting

### Cache Not Working
**Symptom**: App shows "no internet" error even with cached data

**Solutions**:
1. Check database version incremented
2. Verify table created: Use DB Browser for SQLite
3. Check `toJson()` and `fromJson()` in model
4. Verify repository has `localDataSource` parameter
5. Check cubit factory injects local data source

### Stale Data Showing
**Symptom**: Old data displayed instead of fresh data

**Solutions**:
1. Check cache duration setting
2. Verify `cached_at` timestamp being saved
3. Test cache expiration logic
4. Clear cache manually for testing

### App Crashes on Startup
**Symptom**: App crashes after adding caching

**Solutions**:
1. Check database migration logic
2. Verify all models have `toJson()`/`fromJson()`
3. Check for null safety issues in serialization
4. Test with fresh install (clear app data)

### "Required parameter missing" Error
**Symptom**: Compile error about missing `localDataSource`

**Solutions**:
1. Add parameter to repository constructor
2. Inject in repository factory/create methods
3. Update all repository instantiations
4. Check cubit factory methods

---

## 📊 Cache Duration Guidelines

**Choose duration based on data type:**

| Data Type | Duration | Examples |
|-----------|----------|----------|
| **Reference Data** | 72 hours | Property types, currencies, locations |
| **Marketing Content** | 48 hours | Ads, promotions, office profiles |
| **Business Listings** | 24 hours | Properties, offices, employees |
| **Active Listings** | 12 hours | Available properties (frequent updates) |
| **Live Statistics** | 6 hours | Dashboard stats, counters |

**When to cache:**
- ✅ Read-mostly data
- ✅ Reference data (rarely changes)
- ✅ List views
- ✅ Detail views

**When NOT to cache:**
- ❌ Actively mutated data (unless with invalidation)
- ❌ Real-time data
- ❌ User-generated content (requires sync)
- ❌ Collaborative features

---

## 🧪 Testing Checklist

### Basic Functionality
- [ ] Load data while online → Success
- [ ] Turn off internet → Cached data displays
- [ ] Turn on internet → Background update works
- [ ] Wait for cache expiry → Fresh data fetched

### Edge Cases
- [ ] No cache + no internet → Shows error
- [ ] Expired cache + no internet → Shows stale data with warning
- [ ] Fresh install + no internet → Shows error
- [ ] Corrupted cache → Falls back to API

### Performance
- [ ] Initial load < 1 second (cached)
- [ ] Background update smooth (no UI freeze)
- [ ] Pagination works correctly
- [ ] List scrolling smooth

### Cache Invalidation (if applicable)
- [ ] Add item → Cache cleared → Fresh data loaded
- [ ] Update item → Cache updated → Correct data shown
- [ ] Delete item → Cache cleared → Item removed from list

---

## 🎓 Best Practices

### DO ✅
- Always increment database version
- Add `cached_at` timestamp to all tables
- Implement background updates in cubits
- Use indexes for foreign keys
- Test offline functionality
- Clear cache on mutations
- Handle empty cache gracefully
- Show loading indicators

### DON'T ❌
- Don't cache user authentication tokens (use secure storage)
- Don't cache sensitive data without encryption
- Don't cache filter-heavy lists (only first page)
- Don't forget migration logic in `onUpgrade`
- Don't skip `toJson()` method in models
- Don't use hard-coded database paths
- Don't forget error handling

---

## 📱 User Experience Tips

### Offline Indicator
```dart
// Show offline badge when using cached data
if (!isOnline && usingCachedData) {
  return Badge(
    label: 'غير متصل',
    icon: Icons.offline_bolt,
  );
}
```

### Last Updated Timestamp
```dart
// Show when data was last updated
Text(
  'آخر تحديث: ${timeAgo(cachedAt)}',
  style: TextStyle(color: Colors.grey, fontSize: 12),
)
```

### Pull to Refresh
```dart
// Always allow manual refresh
RefreshIndicator(
  onRefresh: () async {
    await cubit.refresh(); // Force API call
  },
  child: ListView(...),
)
```

### Loading States
```dart
// Show different states clearly
if (state is Loading) {
  return LoadingSpinner();
} else if (state is Success && state.isFromCache) {
  return DataView(
    data: state.data,
    badge: OfflineBadge(),
  );
} else if (state is Success) {
  return DataView(data: state.data);
}
```

---

## 🔗 Related Files

### Core Files
- `lib/core/databases/local/database_helper.dart` - Database management
- `lib/core/databases/cache/cache_manager.dart` - Cache utilities
- `lib/core/connection/network_info.dart` - Network connectivity

### Documentation
- `CACHING_IMPLEMENTATION_FINAL.md` - Complete implementation details
- `FINAL_CACHING_SUMMARY.md` - Summary with metrics
- `PROPERTIES_CACHING_NOTES.md` - Property-specific notes

---

## 📞 Need Help?

**Common Questions:**

**Q: How do I know if a feature is cached?**  
A: Check if `[feature]_local_data_source.dart` exists in data sources folder.

**Q: How do I change cache duration?**  
A: Update `_cacheDuration` constant in local data source file.

**Q: How do I force refresh cached data?**  
A: Call `clear()` method, then fetch fresh data from API.

**Q: Can I cache images?**  
A: Not in SQLite. Use `cached_network_image` package or file caching.

**Q: How do I debug cache issues?**  
A: Use DB Browser for SQLite to inspect database directly.

---

**Last Updated**: June 10, 2026  
**Database Version**: 16  
**Cached Features**: 13/14
