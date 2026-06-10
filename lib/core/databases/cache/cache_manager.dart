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
  static const String officesCacheKey = 'offices_data';
  static const String officeDetailsCachePrefix = 'office_details_';
  static const String propertyTypesCacheKey = 'property_types_data';
  static const String propertiesCacheKey = 'properties_data';
  static const String propertyDetailsCachePrefix = 'property_details_';
  static const String promotionsCacheKey = 'promotions_data';
  static const String dashboardStatsCacheKey = 'dashboard_stats_data';
  static const String employeesCacheKey = 'employees_data';
  static const String currenciesCacheKey = 'currencies_data';
  static const String districtsCachePrefix = 'districts_gov_';
  static const String governoratesCacheKey = 'governorates_data';
  static const String neighborhoodsCachePrefix = 'neighborhoods_dist_';

  // Office properties cache keys
  static const String officePropertiesListCacheKey =
      'office_properties_list_data';
  static const String officePropertyDetailsCachePrefix =
      'office_property_details_';
  static const String officePropertyStatsCacheKey =
      'office_property_stats_data';

  // مدة صلاحية كاش المكاتب بالساعات
  static const int _officesCacheDurationHours = 24; // يوم واحد
  static const int _officeDetailsCacheDurationHours =
      48; // يومين لتفاصيل المكتب
  static const int _propertyTypesCacheDurationHours =
      72; // 3 أيام لأنواع العقارات (نادراً ما تتغير)
  static const int _propertiesCacheDurationHours =
      12; // 12 ساعة للعقارات (تتغير بشكل متكرر)
  static const int _propertyDetailsCacheDurationHours =
      24; // يوم واحد لتفاصيل العقار
  static const int _promotionsCacheDurationHours =
      48; // يومين للعروض الترويجية (نادراً ما تتغير)
  static const int _dashboardStatsCacheDurationHours =
      6; // 6 ساعات لإحصائيات لوحة التحكم (تتغير بشكل متكرر)
  static const int _employeesCacheDurationHours =
      24; // يوم واحد للموظفين (تتغير بشكل معتدل)
  static const int _currenciesCacheDurationHours =
      72; // 3 أيام للعملات (نادراً ما تتغير)
  static const int _districtsCacheDurationHours =
      72; // 3 أيام للأحياء (نادراً ما تتغير)
  static const int _governoratesCacheDurationHours =
      72; // 3 أيام للمحافظات (نادراً ما تتغير)
  static const int _neighborhoodsCacheDurationHours =
      72; // 3 أيام للأحياء السكنية (نادراً ما تتغير)

  // Office properties cache durations
  static const int _officePropertiesListCacheDurationHours =
      12; // 12 ساعة لقائمة عقارات المكتب
  static const int _officePropertyDetailsCacheDurationHours =
      24; // يوم واحد لتفاصيل عقار المكتب
  static const int _officePropertyStatsCacheDurationHours =
      6; // 6 ساعات لإحصائيات عقارات المكتب

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

  /// حفظ بيانات المكاتب
  Future<bool> cacheOfficesData(String data) {
    return cacheData(
      key: officesCacheKey,
      data: data,
      customDurationHours: _officesCacheDurationHours,
    );
  }

  /// استرجاع بيانات المكاتب
  String? getCachedOfficesData() {
    return getCachedData(
      key: officesCacheKey,
      customDurationHours: _officesCacheDurationHours,
    );
  }

  /// حفظ بيانات تفاصيل المكتب
  Future<bool> cacheOfficeDetailsData(int officeId, String data) {
    return cacheData(
      key: '$officeDetailsCachePrefix$officeId',
      data: data,
      customDurationHours: _officeDetailsCacheDurationHours,
    );
  }

  /// استرجاع بيانات تفاصيل المكتب
  String? getCachedOfficeDetailsData(int officeId) {
    return getCachedData(
      key: '$officeDetailsCachePrefix$officeId',
      customDurationHours: _officeDetailsCacheDurationHours,
    );
  }

  /// حذف كاش تفاصيل مكتب معين
  Future<bool> clearOfficeDetailsCache(int officeId) {
    return clearCache('$officeDetailsCachePrefix$officeId');
  }

  /// حفظ بيانات أنواع العقارات
  Future<bool> cachePropertyTypesData(String data) {
    return cacheData(
      key: propertyTypesCacheKey,
      data: data,
      customDurationHours: _propertyTypesCacheDurationHours,
    );
  }

  /// استرجاع بيانات أنواع العقارات
  String? getCachedPropertyTypesData() {
    return getCachedData(
      key: propertyTypesCacheKey,
      customDurationHours: _propertyTypesCacheDurationHours,
    );
  }

  /// حفظ بيانات العقارات
  Future<bool> cachePropertiesData(String data) {
    return cacheData(
      key: propertiesCacheKey,
      data: data,
      customDurationHours: _propertiesCacheDurationHours,
    );
  }

  /// استرجاع بيانات العقارات
  String? getCachedPropertiesData() {
    return getCachedData(
      key: propertiesCacheKey,
      customDurationHours: _propertiesCacheDurationHours,
    );
  }

  /// حفظ بيانات تفاصيل العقار
  Future<bool> cachePropertyDetailsData(int propertyId, String data) {
    return cacheData(
      key: '$propertyDetailsCachePrefix$propertyId',
      data: data,
      customDurationHours: _propertyDetailsCacheDurationHours,
    );
  }

  /// استرجاع بيانات تفاصيل العقار
  String? getCachedPropertyDetailsData(int propertyId) {
    return getCachedData(
      key: '$propertyDetailsCachePrefix$propertyId',
      customDurationHours: _propertyDetailsCacheDurationHours,
    );
  }

  /// حذف كاش تفاصيل عقار معين
  Future<bool> clearPropertyDetailsCache(int propertyId) {
    return clearCache('$propertyDetailsCachePrefix$propertyId');
  }

  /// حفظ بيانات العروض الترويجية
  Future<bool> cachePromotionsData(String data) {
    return cacheData(
      key: promotionsCacheKey,
      data: data,
      customDurationHours: _promotionsCacheDurationHours,
    );
  }

  /// استرجاع بيانات العروض الترويجية
  String? getCachedPromotionsData() {
    return getCachedData(
      key: promotionsCacheKey,
      customDurationHours: _promotionsCacheDurationHours,
    );
  }

  /// حفظ بيانات إحصائيات لوحة التحكم
  Future<bool> cacheDashboardStatsData(String data) {
    return cacheData(
      key: dashboardStatsCacheKey,
      data: data,
      customDurationHours: _dashboardStatsCacheDurationHours,
    );
  }

  /// استرجاع بيانات إحصائيات لوحة التحكم
  String? getCachedDashboardStatsData() {
    return getCachedData(
      key: dashboardStatsCacheKey,
      customDurationHours: _dashboardStatsCacheDurationHours,
    );
  }

  /// حفظ بيانات الموظفين
  Future<bool> cacheEmployeesData(String data) {
    return cacheData(
      key: employeesCacheKey,
      data: data,
      customDurationHours: _employeesCacheDurationHours,
    );
  }

  /// استرجاع بيانات الموظفين
  String? getCachedEmployeesData() {
    return getCachedData(
      key: employeesCacheKey,
      customDurationHours: _employeesCacheDurationHours,
    );
  }

  /// حفظ بيانات العملات
  Future<bool> cacheCurrenciesData(String data) {
    return cacheData(
      key: currenciesCacheKey,
      data: data,
      customDurationHours: _currenciesCacheDurationHours,
    );
  }

  /// استرجاع بيانات العملات
  String? getCachedCurrenciesData() {
    return getCachedData(
      key: currenciesCacheKey,
      customDurationHours: _currenciesCacheDurationHours,
    );
  }

  /// حفظ بيانات الأحياء لمحافظة معينة
  Future<bool> cacheDistrictsData(int governorateId, String data) {
    return cacheData(
      key: '$districtsCachePrefix$governorateId',
      data: data,
      customDurationHours: _districtsCacheDurationHours,
    );
  }

  /// استرجاع بيانات الأحياء لمحافظة معينة
  String? getCachedDistrictsData(int governorateId) {
    return getCachedData(
      key: '$districtsCachePrefix$governorateId',
      customDurationHours: _districtsCacheDurationHours,
    );
  }

  /// حذف كاش أحياء محافظة معينة
  Future<bool> clearDistrictsCache(int governorateId) {
    return clearCache('$districtsCachePrefix$governorateId');
  }

  /// حفظ بيانات المحافظات
  Future<bool> cacheGovernoratesData(String data) {
    return cacheData(
      key: governoratesCacheKey,
      data: data,
      customDurationHours: _governoratesCacheDurationHours,
    );
  }

  /// استرجاع بيانات المحافظات
  String? getCachedGovernoratesData() {
    return getCachedData(
      key: governoratesCacheKey,
      customDurationHours: _governoratesCacheDurationHours,
    );
  }

  /// حفظ بيانات الأحياء السكنية لحي معين
  Future<bool> cacheNeighborhoodsData(int districtId, String data) {
    return cacheData(
      key: '$neighborhoodsCachePrefix$districtId',
      data: data,
      customDurationHours: _neighborhoodsCacheDurationHours,
    );
  }

  /// استرجاع بيانات الأحياء السكنية لحي معين
  String? getCachedNeighborhoodsData(int districtId) {
    return getCachedData(
      key: '$neighborhoodsCachePrefix$districtId',
      customDurationHours: _neighborhoodsCacheDurationHours,
    );
  }

  /// حذف كاش أحياء سكنية لحي معين
  Future<bool> clearNeighborhoodsCache(int districtId) {
    return clearCache('$neighborhoodsCachePrefix$districtId');
  }

  /// حفظ بيانات قائمة عقارات المكتب
  Future<bool> cacheOfficePropertiesListData(String data) {
    return cacheData(
      key: officePropertiesListCacheKey,
      data: data,
      customDurationHours: _officePropertiesListCacheDurationHours,
    );
  }

  /// استرجاع بيانات قائمة عقارات المكتب
  String? getCachedOfficePropertiesListData() {
    return getCachedData(
      key: officePropertiesListCacheKey,
      customDurationHours: _officePropertiesListCacheDurationHours,
    );
  }

  /// حفظ بيانات تفاصيل عقار المكتب
  Future<bool> cacheOfficePropertyDetailsData(int propertyId, String data) {
    return cacheData(
      key: '$officePropertyDetailsCachePrefix$propertyId',
      data: data,
      customDurationHours: _officePropertyDetailsCacheDurationHours,
    );
  }

  /// استرجاع بيانات تفاصيل عقار المكتب
  String? getCachedOfficePropertyDetailsData(int propertyId) {
    return getCachedData(
      key: '$officePropertyDetailsCachePrefix$propertyId',
      customDurationHours: _officePropertyDetailsCacheDurationHours,
    );
  }

  /// حذف كاش تفاصيل عقار مكتب معين
  Future<bool> clearOfficePropertyDetailsCache(int propertyId) {
    return clearCache('$officePropertyDetailsCachePrefix$propertyId');
  }

  /// حفظ بيانات إحصائيات عقارات المكتب
  Future<bool> cacheOfficePropertyStatsData(String data) {
    return cacheData(
      key: officePropertyStatsCacheKey,
      data: data,
      customDurationHours: _officePropertyStatsCacheDurationHours,
    );
  }

  /// استرجاع بيانات إحصائيات عقارات المكتب
  String? getCachedOfficePropertyStatsData() {
    return getCachedData(
      key: officePropertyStatsCacheKey,
      customDurationHours: _officePropertyStatsCacheDurationHours,
    );
  }
}
