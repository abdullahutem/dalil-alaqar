class DashboardStatsEntity {
  final PropertiesStats properties;
  final EmployeesStats employees;
  final ViewsStats views;
  final SubscriptionInfo subscription;
  final LimitsInfo limits;
  final List<RecentPropertyEntity> recentProperties;
  final List<TopViewedPropertyEntity> topViewedProperties;

  const DashboardStatsEntity({
    required this.properties,
    required this.employees,
    required this.views,
    required this.subscription,
    required this.limits,
    required this.recentProperties,
    required this.topViewedProperties,
  });
}

class PropertiesStats {
  final int total;
  final int available;
  final int reserved;
  final int sold;
  final int rented;
  final int thisMonth;

  const PropertiesStats({
    required this.total,
    required this.available,
    required this.reserved,
    required this.sold,
    required this.rented,
    required this.thisMonth,
  });
}

class EmployeesStats {
  final int total;
  final int active;
  final int inactive;

  const EmployeesStats({
    required this.total,
    required this.active,
    required this.inactive,
  });
}

class ViewsStats {
  final String total;
  final String thisMonth;

  const ViewsStats({required this.total, required this.thisMonth});
}

class SubscriptionInfo {
  final String planName;
  final String status;
  final String endDate;
  final int daysRemaining;
  final bool isExpiringSoon;

  const SubscriptionInfo({
    required this.planName,
    required this.status,
    required this.endDate,
    required this.daysRemaining,
    required this.isExpiringSoon,
  });
}

class LimitsInfo {
  final int maxProperties;
  final int usedProperties;
  final bool canAddMore;

  const LimitsInfo({
    required this.maxProperties,
    required this.usedProperties,
    required this.canAddMore,
  });
}

class RecentPropertyEntity {
  final int id;
  final String title;
  final String price;
  final String status;
  final String propertyType;
  final String offerType;
  final String governorate;
  final int viewsCount;
  final String createdAt;

  const RecentPropertyEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.status,
    required this.propertyType,
    required this.offerType,
    required this.governorate,
    required this.viewsCount,
    required this.createdAt,
  });
}

class TopViewedPropertyEntity {
  final int id;
  final String title;
  final String propertyType;
  final String offerType;
  final int viewsCount;

  const TopViewedPropertyEntity({
    required this.id,
    required this.title,
    required this.propertyType,
    required this.offerType,
    required this.viewsCount,
  });
}
