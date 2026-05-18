import 'package:shared_preferences/shared_preferences.dart';

/// مدير الكاش المتقدم مع دعم انتهاء الصلاحية
/// يستخدم لتخزين البيانات الغير مهمة مثل السلايدر، الخدمات، معلومات عن الفندق
class CacheManager {
  static const String _cachePrefix = 'cache_';
  static const String _timestampSuffix = '_timestamp';

  // مدة صلاحية الكاش بالساعات
  static const int _defaultCacheDurationHours = 24; // يوم واحد
  static const int _sliderCacheDurationHours = 48; // يومين للسلايدر
  static const int _aboutCacheDurationHours = 72; // 3 أيام لمعلومات الفندق
  static const int _servicesCacheDurationHours = 24; // يوم واحد للخدمات

  final SharedPreferences _prefs;

  CacheManager(this._prefs);

  /// حفظ البيانات في الكاش مع وقت الحفظ
  Future<bool> cacheData({
    required String key,
    required String data,
    int? customDurationHours,
  }) async {
    try {
      final cacheKey = _cachePrefix + key;
      final timestampKey = cacheKey + _timestampSuffix;
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      await _prefs.setString(cacheKey, data);
      await _prefs.setInt(timestampKey, timestamp);

      return true;
    } catch (e) {
      print('Error caching data for key $key: $e');
      return false;
    }
  }

  /// استرجاع البيانات من الكاش إذا كانت صالحة
  String? getCachedData({required String key, int? customDurationHours}) {
    try {
      final cacheKey = _cachePrefix + key;
      final timestampKey = cacheKey + _timestampSuffix;

      final data = _prefs.getString(cacheKey);
      final timestamp = _prefs.getInt(timestampKey);

      if (data == null || timestamp == null) {
        return null;
      }

      // التحقق من صلاحية الكاش
      final cacheDuration = customDurationHours ?? _defaultCacheDurationHours;
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final expiryTime = cacheTime.add(Duration(hours: cacheDuration));

      if (DateTime.now().isAfter(expiryTime)) {
        // الكاش منتهي الصلاحية
        clearCache(key);
        return null;
      }

      return data;
    } catch (e) {
      print('Error getting cached data for key $key: $e');
      return null;
    }
  }

  /// التحقق من وجود كاش صالح
  bool hasFreshCache({required String key, int? customDurationHours}) {
    return getCachedData(key: key, customDurationHours: customDurationHours) !=
        null;
  }

  /// حذف كاش معين
  Future<bool> clearCache(String key) async {
    try {
      final cacheKey = _cachePrefix + key;
      final timestampKey = cacheKey + _timestampSuffix;

      await _prefs.remove(cacheKey);
      await _prefs.remove(timestampKey);

      return true;
    } catch (e) {
      print('Error clearing cache for key $key: $e');
      return false;
    }
  }

  /// حذف جميع الكاش
  Future<bool> clearAllCache() async {
    try {
      final keys = _prefs.getKeys();
      for (final key in keys) {
        if (key.startsWith(_cachePrefix)) {
          await _prefs.remove(key);
        }
      }
      return true;
    } catch (e) {
      print('Error clearing all cache: $e');
      return false;
    }
  }

  /// الحصول على عمر الكاش بالساعات
  int? getCacheAgeInHours(String key) {
    try {
      final cacheKey = _cachePrefix + key;
      final timestampKey = cacheKey + _timestampSuffix;

      final timestamp = _prefs.getInt(timestampKey);
      if (timestamp == null) return null;

      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final age = DateTime.now().difference(cacheTime);

      return age.inHours;
    } catch (e) {
      return null;
    }
  }

  // مفاتيح الكاش للبيانات المختلفة
  static const String sliderCacheKey = 'slider_data';
  static const String aboutCacheKey = 'about_data';
  static const String servicesCacheKey = 'services_data';
  static const String featuresCacheKey = 'features_data';

  // دوال مساعدة للبيانات المحددة

  /// حفظ بيانات السلايدر
  Future<bool> cacheSliderData(String data) {
    return cacheData(
      key: sliderCacheKey,
      data: data,
      customDurationHours: _sliderCacheDurationHours,
    );
  }

  /// استرجاع بيانات السلايدر
  String? getCachedSliderData() {
    return getCachedData(
      key: sliderCacheKey,
      customDurationHours: _sliderCacheDurationHours,
    );
  }

  /// حفظ بيانات معلومات الفندق
  Future<bool> cacheAboutData(String data) {
    return cacheData(
      key: aboutCacheKey,
      data: data,
      customDurationHours: _aboutCacheDurationHours,
    );
  }

  /// استرجاع بيانات معلومات الفندق
  String? getCachedAboutData() {
    return getCachedData(
      key: aboutCacheKey,
      customDurationHours: _aboutCacheDurationHours,
    );
  }

  /// حفظ بيانات الخدمات
  Future<bool> cacheServicesData(String data) {
    return cacheData(
      key: servicesCacheKey,
      data: data,
      customDurationHours: _servicesCacheDurationHours,
    );
  }

  /// استرجاع بيانات الخدمات
  String? getCachedServicesData() {
    return getCachedData(
      key: servicesCacheKey,
      customDurationHours: _servicesCacheDurationHours,
    );
  }
}
