# 🔧 Troubleshooting Guide

## Common Issues and Solutions

### 1. ProviderNotFoundException ✅ FIXED

**Error:**
```
ProviderNotFoundException: Error: Could not find the correct Provider<PropertyTypesCubit> above this Builder Widget
```

**Root Cause:** 
Two issues were fixed:
1. Cubits needed factory methods to create dependencies
2. `initState()` was trying to access providers before context was ready

**Solutions Applied:**

**Fix 1: Added Factory Methods**
All cubits now have `.create()` factory methods:
```dart
BlocProvider(
  create: (context) => PropertyTypesCubit.create(),
)
```

**Fix 2: Changed initState to didChangeDependencies**
In `AdvancedSearchScreen`:
```dart
bool _isInitialized = false;

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  if (!_isInitialized) {
    _isInitialized = true;
    context.read<PropertyTypesCubit>().getPropertyTypes();
  }
}
```

**If you still see this error:**
1. Hot restart the app (not hot reload)
2. Run `flutter clean` and rebuild
3. Check that you're using `.create()` for all cubits
4. Never use `context.read()` in `initState()`

---

### 2. Network Connection Issues

**Error:**
```
SocketException: Failed host lookup
```

**Possible Causes:**
- No internet connection
- API server is down
- Wrong API base URL

**Solutions:**
1. Check internet connection
2. Verify API base URL in `lib/core/databases/api/end_points.dart`
3. Test API endpoints in browser or Postman
4. Check if API server is running

**Current API Base URL:**
```dart
static const String baseUrl = "https://dalil-alaqar.codebrains.net/api/";
```

---

### 3. Dio Errors

**Error:**
```
DioException: Connection timeout
```

**Solutions:**
1. Increase timeout in DioConsumer:
```dart
BaseOptions(
  connectTimeout: const Duration(seconds: 30),
  receiveTimeout: const Duration(seconds: 30),
)
```

2. Check network connectivity
3. Verify API endpoint is correct

---

### 4. JSON Parsing Errors

**Error:**
```
type 'Null' is not a subtype of type 'String'
```

**Possible Causes:**
- API response structure changed
- Missing fields in response
- Null values where non-null expected

**Solutions:**
1. Check API response format
2. Update model classes to match API
3. Add null safety checks:
```dart
final String name = json['name'] ?? '';
```

---

### 5. State Not Updating

**Problem:**
UI doesn't update when data changes

**Solutions:**
1. Ensure you're using `BlocBuilder`:
```dart
BlocBuilder<PropertyTypesCubit, PropertyTypesState>(
  builder: (context, state) {
    // Your UI
  },
)
```

2. Check that cubit is emitting states:
```dart
emit(PropertyTypesLoading());
emit(PropertyTypesSuccess(response: response));
```

3. Verify BlocProvider is in widget tree

---

### 6. Cascading Selection Not Working

**Problem:**
Districts don't load when governorate selected

**Solutions:**
1. Check that `getDistrictsByGovernorate()` is called:
```dart
context.read<DistrictsCubit>().getDistrictsByGovernorate(governorateId);
```

2. Verify API endpoint is correct:
```dart
EndPoints.districtsByGovernorate(governorateId)
```

3. Check API response in network inspector

---

### 7. Filters Not Applying

**Problem:**
Search filters don't filter properties

**Solutions:**
1. Ensure `refresh: true` is passed:
```dart
context.read<PropertiesCubit>().getProperties(
  refresh: true,
  propertyTypeId: 1,
);
```

2. Check query parameters are built correctly
3. Verify API supports the filter parameters

---

### 8. Pagination Not Working

**Problem:**
Load more doesn't fetch next page

**Solutions:**
1. Check `hasMore` getter:
```dart
if (cubit.hasMore) {
  cubit.loadMore();
}
```

2. Verify pagination meta from API:
```dart
"meta": {
  "current_page": 1,
  "last_page": 5,
  "per_page": 20,
  "total": 100
}
```

3. Check that `_currentPage` is incrementing

---

### 9. Images Not Loading

**Problem:**
Property images don't display

**Solutions:**
1. Check image URLs are valid
2. Add error handling:
```dart
CachedNetworkImage(
  imageUrl: imageUrl,
  errorWidget: (context, url, error) => Icon(Icons.error),
  placeholder: (context, url) => CircularProgressIndicator(),
)
```

3. Check network permissions in AndroidManifest.xml and Info.plist

---

### 10. Build Errors

**Error:**
```
The method 'X' isn't defined for the type 'Y'
```

**Solutions:**
1. Run `flutter pub get`
2. Check imports are correct
3. Verify method exists in class
4. Hot restart the app

---

### 11. Hot Reload Not Working

**Problem:**
Changes don't appear after hot reload

**Solutions:**
1. Use hot restart instead (Shift + R)
2. Stop and restart the app
3. Run `flutter clean` and rebuild

---

### 12. Performance Issues

**Problem:**
App is slow or laggy

**Solutions:**
1. Enable release mode:
```bash
flutter run --release
```

2. Optimize images:
- Use appropriate image sizes
- Enable caching
- Use thumbnails for lists

3. Implement pagination:
- Already implemented ✅
- Load 20 items per page

4. Cache filter data:
- Property types rarely change
- Cache locally with SharedPreferences

---

## 🔍 Debugging Tips

### 1. Enable Debug Logging

Add to DioConsumer:
```dart
dio.interceptors.add(LogInterceptor(
  requestBody: true,
  responseBody: true,
));
```

### 2. Check State Changes

Add to cubits:
```dart
@override
void onChange(Change<PropertyTypesState> change) {
  super.onChange(change);
  print('State changed: ${change.currentState} -> ${change.nextState}');
}
```

### 3. Network Inspector

Use Flutter DevTools Network tab to inspect API calls.

### 4. Widget Inspector

Use Flutter DevTools Widget Inspector to check widget tree.

---

## 📱 Platform-Specific Issues

### iOS

**Issue:** Network requests fail
**Solution:** Add to Info.plist:
```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```

### Android

**Issue:** Network requests fail
**Solution:** Add to AndroidManifest.xml:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

---

## 🆘 Still Having Issues?

### 1. Check Documentation
- Read feature-specific README.md files
- Check QUICK_REFERENCE.md
- Review ADVANCED_SEARCH_GUIDE.md

### 2. Verify Setup
- All dependencies installed
- API base URL correct
- Network permissions granted

### 3. Clean Build
```bash
flutter clean
flutter pub get
flutter run
```

### 4. Check Logs
Look for error messages in console output.

### 5. Test API Directly
Use Postman or browser to test API endpoints.

---

## ✅ Verification Checklist

Before reporting an issue, verify:

- [ ] Flutter version is up to date
- [ ] All dependencies are installed (`flutter pub get`)
- [ ] No compilation errors (`flutter analyze`)
- [ ] API base URL is correct
- [ ] Internet connection is working
- [ ] API endpoints are accessible
- [ ] BlocProviders are set up correctly
- [ ] Hot restart has been tried
- [ ] Clean build has been tried

---

## 📞 Getting Help

If you're still stuck:

1. **Check error message** - Read the full error stack trace
2. **Search documentation** - Check all .md files in project
3. **Test in isolation** - Create minimal reproduction
4. **Check API** - Test endpoints directly
5. **Review code** - Compare with working examples

---

**Last Updated:** May 19, 2026  
**Status:** All Known Issues Resolved ✅
