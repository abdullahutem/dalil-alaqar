# Migration Checklist

Track your progress migrating features to the enhanced caching system.

## ✅ Core Implementation (Complete)

- [x] Database Helper - Added cache_metadata table (v18)
- [x] Base Cached Data Source - Reusable base class
- [x] App Logger - Production-ready logging
- [x] Documentation - All guides created
- [x] Example - Promotions fully migrated

## 🔄 Feature Migration Progress

### High Priority (Do First)

#### Promotions ✅ **COMPLETE**
- [x] Extend BaseCachedDataSource
- [x] Add cache validation
- [x] Use transactions
- [x] Add logging
- [x] Test offline/online

#### Plans ✅ **COMPLETE**
- [x] Create plans table in database
- [x] Create PlansLocalDataSource
- [x] Extend BaseCachedDataSource
- [x] Add _isCacheValid() helper
- [x] Implement getCachedPlans()
- [x] Implement cachePlans() with transaction
- [x] Replace print with AppLogger
- [x] Update repository with local data source
- [x] Update cubit factory
- [x] Ready for testing

**Cache Duration:** `Duration(days: 30)`  
**Cache Key:** `'plans'`  
**Storage:** Hybrid (columns + JSON for nested objects)  
**Files:**
- `lib/features/plans/data/datasources/plans_local_data_source.dart` ✅ Created
- `lib/features/plans/data/repositories/plans_repository_impl.dart` ✅ Updated
- `lib/features/plans/presentation/cubit/plans_cubit.dart` ✅ Updated
- `lib/core/databases/local/database_helper.dart` ✅ Updated (v19)

#### Properties 🔲 **TODO**
- [ ] Extend BaseCachedDataSource
- [ ] Add _isCacheValid() helper
- [ ] Update getCachedPropertiesJson()
- [ ] Wrap cachePropertiesJson() in transaction
- [ ] Replace print with AppLogger
- [ ] Update repository null handling
- [ ] Test thoroughly

**Cache Duration:** `Duration(hours: 6)`  
**Cache Key:** `'properties'`  
**Files:**
- `lib/features/properties/data/datasources/properties_local_data_source.dart`
- `lib/features/properties/data/repositories/properties_repository_impl.dart`

#### Property Details 🔲 **TODO**
- [ ] Extend BaseCachedDataSource
- [ ] Add _isCacheValid() helper
- [ ] Update getCachedPropertyDetails()
- [ ] Wrap cachePropertyDetails() in transaction
- [ ] Replace print with AppLogger
- [ ] Update repository null handling
- [ ] Test thoroughly

**Cache Duration:** `Duration(hours: 6)`  
**Cache Key:** `'property_details'`  
**Files:**
- `lib/features/properties/data/datasources/property_details_local_data_source.dart`

### Medium Priority

#### Office Info ✅ **COMPLETE**
- [x] Create office_info table in database
- [x] Create OfficeInfoLocalDataSource
- [x] Extend BaseCachedDataSource
- [x] Add _isCacheValid() helper
- [x] Implement getCachedOfficeInfo()
- [x] Implement cacheOfficeInfo() with transaction
- [x] Update repository with local data source
- [x] Cache after updates/logo uploads
- [x] Update cubit factory
- [x] Ready for testing

**Cache Duration:** `Duration(days: 7)`  
**Cache Key:** `'office_info'`  
**Storage:** Column-based (single record)  
**Files:**
- `lib/features/office_info/data/datasources/office_info_local_data_source.dart` ✅ Created
- `lib/features/office_info/data/repositories/office_info_repository_impl.dart` ✅ Updated
- `lib/features/office_info/presentation/cubit/office_info_cubit.dart` ✅ Updated
- `lib/core/databases/local/database_helper.dart` ✅ Updated (v20)

#### Profile ✅ **COMPLETE**
- [x] Create profile table in database
- [x] Create ProfileLocalDataSource
- [x] Extend BaseCachedDataSource
- [x] Add _isCacheValid() helper
- [x] Implement getCachedProfile()
- [x] Implement cacheProfile() with transaction
- [x] Update repository with local data source
- [x] Cache after profile updates
- [x] Update cubit factory
- [x] Ready for testing

**Cache Duration:** `Duration(days: 7)`  
**Cache Key:** `'profile'`  
**Storage:** JSON (nested user and office objects)  
**Files:**
- `lib/features/profile/data/datasources/profile_local_data_source.dart` ✅ Created
- `lib/features/profile/data/repositories/profile_repository_impl.dart` ✅ Updated
- `lib/features/profile/presentation/cubit/profile_cubit.dart` ✅ Updated
- `lib/core/databases/local/database_helper.dart` ✅ Updated (v21)

#### Offices 🔲 **TODO**
- [ ] Extend BaseCachedDataSource
- [ ] Add _isCacheValid() helper
- [ ] Update getCachedOffices()
- [ ] Wrap cacheOffices() in transaction
- [ ] Replace print with AppLogger
- [ ] Update repository null handling
- [ ] Test thoroughly

**Cache Duration:** `Duration(days: 7)`  
**Cache Key:** `'offices'`  
**Files:**
- `lib/features/offices/data/datasources/offices_local_data_source.dart`
- `lib/features/offices/data/repositories/offices_repository_impl.dart`

#### Office Properties 🔲 **TODO**
- [ ] Extend BaseCachedDataSource
- [ ] Add _isCacheValid() helper
- [ ] Update getCached methods
- [ ] Wrap cache methods in transaction
- [ ] Replace print with AppLogger
- [ ] Update repository null handling
- [ ] Test thoroughly

**Cache Duration:** `Duration(days: 1)`  
**Cache Key:** `'office_properties'`, `'office_property_details'`  
**Files:**
- `lib/features/office_properties/data/datasources/office_properties_list_local_data_source.dart`
- `lib/features/office_properties/data/datasources/office_property_details_local_data_source.dart`

#### Advertisements/Sliders 🔲 **TODO**
- [ ] Extend BaseCachedDataSource
- [ ] Add _isCacheValid() helper
- [ ] Update getCachedSlides()
- [ ] Wrap cacheSlides() in transaction
- [ ] Replace print with AppLogger
- [ ] Update repository null handling
- [ ] Test thoroughly

**Cache Duration:** `Duration(days: 1)`  
**Cache Key:** `'advertisements'`  
**Files:**
- `lib/features/advertisements/data/datasources/slider_local_data_source.dart`

### Low Priority (Do Later)

#### Employees 🔲 **TODO**
- [ ] Extend BaseCachedDataSource
- [ ] Add cache validation
- [ ] Use transactions
- [ ] Add logging
- [ ] Test

**Cache Duration:** `Duration(days: 7)`  
**Cache Key:** `'employees'`

#### Currencies 🔲 **TODO**
- [ ] Extend BaseCachedDataSource
- [ ] Add cache validation
- [ ] Use transactions
- [ ] Add logging
- [ ] Test

**Cache Duration:** `Duration(days: 1)`  
**Cache Key:** `'currencies'`

#### Governorates 🔲 **TODO**
- [ ] Extend BaseCachedDataSource
- [ ] Add cache validation
- [ ] Use transactions
- [ ] Add logging
- [ ] Test

**Cache Duration:** `Duration(days: 60)`  
**Cache Key:** `'governorates'`

#### Districts 🔲 **TODO**
- [ ] Extend BaseCachedDataSource
- [ ] Add cache validation
- [ ] Use transactions
- [ ] Add logging
- [ ] Test

**Cache Duration:** `Duration(days: 60)`  
**Cache Key:** `'districts'`

#### Neighborhoods 🔲 **TODO**
- [ ] Extend BaseCachedDataSource
- [ ] Add cache validation
- [ ] Use transactions
- [ ] Add logging
- [ ] Test

**Cache Duration:** `Duration(days: 60)`  
**Cache Key:** `'neighborhoods'`

## 📊 Progress Tracker

### Overall Progress
- ✅ Core Implementation: 5/5 (100%)
- ✅ High Priority Features: 2/3 (67%)
- 🔄 Medium Priority Features: 2/3 (67%)
- 🔄 Low Priority Features: 0/5 (0%)

**Total Progress: 4/11 features (36%)**

### Time Estimates
- High Priority: ~2-3 hours total
- Medium Priority: ~2-3 hours total
- Low Priority: ~2-3 hours total

**Total Migration Time: ~6-9 hours**

## 🎯 Weekly Goals

### Week 1 (Current)
- [x] Complete core implementation
- [x] Complete documentation
- [x] Migrate Promotions (example)
- [ ] Migrate Properties
- [ ] Migrate Property Details

### Week 2
- [ ] Migrate Offices
- [ ] Migrate Office Properties
- [ ] Migrate Advertisements

### Week 3
- [ ] Migrate remaining low-priority features
- [ ] Final testing
- [ ] Performance monitoring

## ✅ Per-Feature Checklist

Use this checklist for each feature:

### Before Migration
- [ ] Read QUICK_CACHE_MIGRATION.md
- [ ] Identify cache duration needed
- [ ] Identify storage type (columns vs JSON)
- [ ] Check current implementation

### During Migration
- [ ] Update class declaration (extend base)
- [ ] Add constants (_cacheKey, _defaultCacheAge)
- [ ] Add _isCacheValid() helper
- [ ] Update getCached method
  - [ ] Check cache validity first
  - [ ] Return null if expired
  - [ ] Add success logging
  - [ ] Add error handling
  - [ ] Make return type nullable
- [ ] Update cache method
  - [ ] Wrap in transaction
  - [ ] Add database logging
  - [ ] Call updateCacheMetadata
  - [ ] Add error handling
- [ ] Update clear method
  - [ ] Wrap in transaction
  - [ ] Clear metadata too
  - [ ] Add logging
- [ ] Update repository
  - [ ] Handle null returns
  - [ ] Replace print with AppLogger

### After Migration
- [ ] Clear app data
- [ ] Test fresh data load
- [ ] Check debug logs
- [ ] Test cache load
- [ ] Test cache expiration
- [ ] Test offline mode
- [ ] Verify transaction rollback (simulate error)

## 📝 Notes Template

Use this for each feature migration:

```
Feature: [Name]
Date Started: [Date]
Date Completed: [Date]
Cache Key: '[key]'
Cache Duration: Duration([value])
Storage Type: [Columns/JSON]

Issues Encountered:
- 

Solutions Applied:
- 

Tests Performed:
✓ 
✓ 
✓ 

Performance Notes:
- 
```

## 🎉 Completion Celebration

When all features are migrated:
- [ ] Run full app test suite
- [ ] Monitor crash reports
- [ ] Check cache hit rates
- [ ] Measure API call reduction
- [ ] Document lessons learned
- [ ] Share with team

---

**Remember:** Quality over speed. Test thoroughly after each migration!

**Need Help?** Check:
1. Promotions implementation (working example)
2. QUICK_CACHE_MIGRATION.md (quick reference)
3. CACHE_ENHANCEMENT_GUIDE.md (detailed steps)
