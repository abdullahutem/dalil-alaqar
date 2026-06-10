import 'package:dalil_alaqar/core/databases/local/database_helper.dart';
import 'package:dalil_alaqar/features/dashboard/data/models/dashboard_stats_model.dart';

abstract class DashboardLocalDataSource {
  Future<DashboardStatsModel?> getCachedDashboardStats();
  Future<void> cacheDashboardStats(DashboardStatsModel stats);
  Future<void> clearDashboardStats();
}

class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  final DatabaseHelper databaseHelper;

  DashboardLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<DashboardStatsModel?> getCachedDashboardStats() async {
    final db = await databaseHelper.database;
    final result = await db.query('dashboard_stats', limit: 1);

    if (result.isEmpty) {
      return null;
    }

    final json = result.first;

    // Parse recent properties
    final recentPropertiesJson = json['recent_properties'] as String?;
    final List<dynamic> recentPropertiesList = recentPropertiesJson != null
        ? (recentPropertiesJson
              .split('|||')
              .map((item) {
                final parts = item.split('::');
                if (parts.length >= 9) {
                  return {
                    'id': int.tryParse(parts[0]) ?? 0,
                    'title': parts[1],
                    'price': parts[2],
                    'status': parts[3],
                    'property_type': parts[4],
                    'offer_type': parts[5],
                    'governorate': parts[6],
                    'views_count': int.tryParse(parts[7]) ?? 0,
                    'created_at': parts[8],
                  };
                }
                return null;
              })
              .whereType<Map<String, dynamic>>()
              .toList())
        : [];

    // Parse top viewed properties
    final topViewedJson = json['top_viewed_properties'] as String?;
    final List<dynamic> topViewedList = topViewedJson != null
        ? (topViewedJson
              .split('|||')
              .map((item) {
                final parts = item.split('::');
                if (parts.length >= 5) {
                  return {
                    'id': int.tryParse(parts[0]) ?? 0,
                    'title': parts[1],
                    'property_type': parts[2],
                    'offer_type': parts[3],
                    'views_count': int.tryParse(parts[4]) ?? 0,
                  };
                }
                return null;
              })
              .whereType<Map<String, dynamic>>()
              .toList())
        : [];

    return DashboardStatsModel(
      properties: PropertiesStatsModel(
        total: json['properties_total'] as int,
        available: json['properties_available'] as int,
        reserved: json['properties_reserved'] as int,
        sold: json['properties_sold'] as int,
        rented: json['properties_rented'] as int,
        thisMonth: json['properties_this_month'] as int,
      ),
      employees: EmployeesStatsModel(
        total: json['employees_total'] as int,
        active: json['employees_active'] as int,
        inactive: json['employees_inactive'] as int,
      ),
      views: ViewsStatsModel(
        total: json['views_total'] as String,
        thisMonth: json['views_this_month'] as String,
      ),
      subscription: SubscriptionInfoModel(
        planName: json['subscription_plan_name'] as String,
        status: json['subscription_status'] as String,
        endDate: json['subscription_end_date'] as String,
        daysRemaining: json['subscription_days_remaining'] as int,
        isExpiringSoon: (json['subscription_is_expiring_soon'] as int) == 1,
      ),
      limits: LimitsInfoModel(
        maxProperties: json['limits_max_properties'] as int,
        usedProperties: json['limits_used_properties'] as int,
        canAddMore: (json['limits_can_add_more'] as int) == 1,
      ),
      recentProperties: recentPropertiesList
          .map((e) => RecentPropertyModel.fromJson(e))
          .toList(),
      topViewedProperties: topViewedList
          .map((e) => TopViewedPropertyModel.fromJson(e))
          .toList(),
    );
  }

  @override
  Future<void> cacheDashboardStats(DashboardStatsModel stats) async {
    try {
      final db = await databaseHelper.database;

      print('💾 Caching dashboard stats to database');

      // Clear existing stats
      await db.delete('dashboard_stats');

      // Serialize recent properties
      final recentPropertiesStr = stats.recentProperties
          .map(
            (p) =>
                '${p.id}::${p.title}::${p.price}::${p.status}::'
                '${p.propertyType}::${p.offerType}::${p.governorate}::'
                '${p.viewsCount}::${p.createdAt}',
          )
          .join('|||');

      // Serialize top viewed properties
      final topViewedStr = stats.topViewedProperties
          .map(
            (p) =>
                '${p.id}::${p.title}::${p.propertyType}::'
                '${p.offerType}::${p.viewsCount}',
          )
          .join('|||');

      // Insert new stats
      final cachedAt = DateTime.now().toIso8601String();
      await db.insert('dashboard_stats', {
        'properties_total': stats.properties.total,
        'properties_available': stats.properties.available,
        'properties_reserved': stats.properties.reserved,
        'properties_sold': stats.properties.sold,
        'properties_rented': stats.properties.rented,
        'properties_this_month': stats.properties.thisMonth,
        'employees_total': stats.employees.total,
        'employees_active': stats.employees.active,
        'employees_inactive': stats.employees.inactive,
        'views_total': stats.views.total,
        'views_this_month': stats.views.thisMonth,
        'subscription_plan_name': stats.subscription.planName,
        'subscription_status': stats.subscription.status,
        'subscription_end_date': stats.subscription.endDate,
        'subscription_days_remaining': stats.subscription.daysRemaining,
        'subscription_is_expiring_soon': stats.subscription.isExpiringSoon
            ? 1
            : 0,
        'limits_max_properties': stats.limits.maxProperties,
        'limits_used_properties': stats.limits.usedProperties,
        'limits_can_add_more': stats.limits.canAddMore ? 1 : 0,
        'recent_properties': recentPropertiesStr,
        'top_viewed_properties': topViewedStr,
        'cached_at': cachedAt,
      });

      print('✅ Successfully cached dashboard stats');
    } catch (e, stackTrace) {
      print('❌ Error caching dashboard stats: $e');
      print('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<void> clearDashboardStats() async {
    final db = await databaseHelper.database;
    await db.delete('dashboard_stats');
  }
}
