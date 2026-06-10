# Offices Feature - Local Data Caching Implementation

## Overview
Both the **offices list** and **office details** features now implement comprehensive local data caching strategies similar to the advertisements feature. This improves user experience by providing instant data access and offline support.

## Architecture

### Caching Strategy
The implementation uses a two-tier caching approach:

1. **Fast Cache (SharedPreferences)** - For instant access on app startup
2. **SQLite Database** - For persistent storage with more detailed data

### Data Flow

```
┌─────────────────────────────────────────────────────┐
│                    User Request                     │
└──────────────────────┬──────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────┐
│         Check SharedPreferences Cache               │
│         (Fast access, expires in 24 hours)          │
└──────────┬──────────────────────┬───────────────────┘
           │ Cache Hit            │ Cache Miss
           ▼                      ▼
    Return Cached Data    Check Internet Connection
    Update in Background          │
                                  ├── Connected ──────┐
                                  │                   │
                                  │                   ▼
                                  │          Fetch from API
                                  │                   │
                                  │                   ▼
                                  │         Cache to SQLite
                                  │         Cache to SharedPrefs
                                  │                   │
                                  │                   ▼
                                  │          Return Fresh Data
                                  │
                                  └── Disconnected ──┐
                                                     │
                                                     ▼
                                            Load from SQLite
                                                     │
                                                     ▼
                                            Return Cached Data
```

## Implementation Details

### 1. Local Data Source (`offices_local_data_source.dart`)
Handles all SQLite database operations:
- **getCachedOffices()**: Retrieves all cached offices from database
- **cacheOffices()**: Stores offices list to database with timestamp
- **clearOffices()**: Removes all cached offices

### 2. Database Schema
The `offices` table in SQLite includes all office fields:
```sql
CREATE TABLE offices (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  owner_name TEXT,
  slug TEXT NOT NULL,
  logo TEXT,
  email TEXT,
  phone TEXT,
  mobile_phone TEXT,
  whatsapp_number TEXT,
  commercial_license TEXT,
  license_number TEXT,
  description TEXT,
  website TEXT,
  facebook TEXT,
  instagram TEXT,
  twitter TEXT,
  governorate_id INTEGER,
  district_id INTEGER,
  address TEXT,
  latitude TEXT,
  longitude TEXT,
  subscription_type TEXT,
  subscription_start_date TEXT,
  subscription_end_date TEXT,
  max_properties INTEGER,
  is_verified INTEGER NOT NULL,
  verification_date TEXT,
  rating REAL,
  total_ratings INTEGER,
  total_properties INTEGER,
  total_views INTEGER,
  status TEXT,
  created_at TEXT,
  updated_at TEXT,
  cached_at TEXT NOT NULL
)
```

### 3. Repository Implementation (`offices_repository_impl.dart`)
Implements the caching logic:

#### For First Page (page == 1):
1. Check SharedPreferences cache first
2. If cache hit → Return cached data and update in background
3. If cache miss or no internet → Load from SQLite
4. If internet available → Fetch from API and cache to both stores

#### For Other Pages (page > 1):
- Always fetch from API
- No caching (pagination pages change frequently)

### 4. Cache Manager
Added offices-specific cache methods:
- **cacheOfficesData()**: Store offices JSON in SharedPreferences
- **getCachedOfficesData()**: Retrieve cached offices JSON
- Cache expires after 24 hours

## Key Features

### ✅ Instant Load
First page loads instantly from SharedPreferences cache on subsequent app launches.

### ✅ Offline Support
When offline, users can still view cached offices data from SQLite database.

### ✅ Background Updates
When cached data is shown, a background update fetches fresh data without blocking the UI.

### ✅ Smart Caching
Only the first page is cached to optimize storage. Pagination pages are always fetched fresh.

### ✅ Error Resilience
- API errors → Fall back to cache
- Network errors → Fall back to cache
- Cache errors → Show appropriate error message

## Usage

The caching is completely transparent to the presentation layer. The cubit works exactly as before:

```dart
// Initialize cubit with local data source support
final cubit = OfficesCubit.create();

// Fetch offices (automatically uses cache if available)
await cubit.getOffices();
```

## Cache Invalidation

The cache is automatically invalidated:
- After 24 hours (SharedPreferences)
- When fresh data is fetched from API (both caches updated)
- On app reinstall (all data cleared)

## Benefits

1. **Improved Performance**: Instant data access on app startup
2. **Better UX**: No loading spinner when cached data is available
3. **Offline Support**: Users can browse offices without internet
4. **Reduced Server Load**: Fewer API calls due to caching
5. **Data Freshness**: Background updates ensure data stays current

## Files Modified/Created

### Created:
- `lib/features/offices/data/datasources/offices_local_data_source.dart`
- `lib/features/office_details/data/datasources/office_details_local_data_source.dart`
- `lib/features/offices/CACHING_IMPLEMENTATION.md` (this file)

### Modified:
- `lib/features/offices/data/repositories/offices_repository_impl.dart`
- `lib/features/offices/data/models/offices_response_model.dart` (added toJson)
- `lib/features/offices/presentation/cubit/offices_cubit.dart`
- `lib/features/office_details/data/repositories/office_details_repository_impl.dart`
- `lib/features/office_details/presentation/cubit/office_details_cubit.dart`
- `lib/core/databases/local/database_helper.dart` (added offices & office_details tables)
- `lib/core/databases/cache/cache_manager.dart` (added offices & office_details cache methods)

## Testing Recommendations

1. **First Load**: Verify data loads from API and caches properly
2. **Subsequent Load**: Verify instant load from cache
3. **Offline Mode**: Turn off internet and verify cached data is shown
4. **Background Update**: Watch network logs to confirm background updates
5. **Cache Expiry**: Test behavior after 24+ hours
6. **Pagination**: Verify pages 2+ are not cached

## Notes

- Nested governorate and district objects are not stored in SQLite cache for offices list to simplify the schema
- If nested objects are needed, they should be fetched from their respective tables/caches
- The implementation follows the same pattern as the advertisements/slider feature for consistency
- **Office details are fully cached** including all nested objects (governorate, district, recent properties) since they don't change frequently
- Office details cache expires after 48 hours (longer than offices list) since individual office data changes less frequently

## Office Details Caching

### Database Schema
The `office_details` table stores complete office information as JSON:
```sql
CREATE TABLE office_details (
  office_id INTEGER PRIMARY KEY,
  details_json TEXT NOT NULL,
  cached_at TEXT NOT NULL
)
```

### Why JSON Storage?
Office details include complex nested structures (governorate, district, recent properties with their types and images). Storing as JSON is more efficient than creating multiple related tables.

### Cache Duration
- **Offices List**: 24 hours (changes more frequently)
- **Office Details**: 48 hours (changes less frequently)

### Benefits for Office Details
1. **Instant Load**: Previously viewed offices load instantly
2. **Offline Access**: Users can revisit offices they've viewed even offline
3. **Reduced Server Load**: Popular offices are served from cache
4. **Better UX**: No loading delays when browsing back to previously viewed offices
