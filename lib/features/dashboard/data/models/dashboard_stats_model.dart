import 'package:dalil_alaqar/features/dashboard/domain/entities/dashboard_stats_entity.dart';

class DashboardStatsModel extends DashboardStatsEntity {
  const DashboardStatsModel({
    required super.properties,
    required super.employees,
    required super.views,
    required super.subscription,
    required super.limits,
    required super.recentProperties,
    required super.topViewedProperties,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      properties: PropertiesStatsModel.fromJson(json['properties']),
      employees: EmployeesStatsModel.fromJson(json['employees']),
      views: ViewsStatsModel.fromJson(json['views']),
      subscription: SubscriptionInfoModel.fromJson(json['subscription']),
      limits: LimitsInfoModel.fromJson(json['limits']),
      recentProperties: (json['recent_properties'] as List)
          .map((e) => RecentPropertyModel.fromJson(e))
          .toList(),
      topViewedProperties: (json['top_viewed_properties'] as List)
          .map((e) => TopViewedPropertyModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'properties': (properties as PropertiesStatsModel).toJson(),
    'employees': (employees as EmployeesStatsModel).toJson(),
    'views': (views as ViewsStatsModel).toJson(),
    'subscription': (subscription as SubscriptionInfoModel).toJson(),
    'limits': (limits as LimitsInfoModel).toJson(),
    'recent_properties': recentProperties
        .map((p) => (p as RecentPropertyModel).toJson())
        .toList(),
    'top_viewed_properties': topViewedProperties
        .map((p) => (p as TopViewedPropertyModel).toJson())
        .toList(),
  };
}

class PropertiesStatsModel extends PropertiesStats {
  const PropertiesStatsModel({
    required super.total,
    required super.available,
    required super.reserved,
    required super.sold,
    required super.rented,
    required super.thisMonth,
  });

  factory PropertiesStatsModel.fromJson(Map<String, dynamic> json) {
    return PropertiesStatsModel(
      total: json['total'] ?? 0,
      available: json['available'] ?? 0,
      reserved: json['reserved'] ?? 0,
      sold: json['sold'] ?? 0,
      rented: json['rented'] ?? 0,
      thisMonth: json['this_month'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'total': total,
    'available': available,
    'reserved': reserved,
    'sold': sold,
    'rented': rented,
    'this_month': thisMonth,
  };
}

class EmployeesStatsModel extends EmployeesStats {
  const EmployeesStatsModel({
    required super.total,
    required super.active,
    required super.inactive,
  });

  factory EmployeesStatsModel.fromJson(Map<String, dynamic> json) {
    return EmployeesStatsModel(
      total: json['total'] ?? 0,
      active: json['active'] ?? 0,
      inactive: json['inactive'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'total': total,
    'active': active,
    'inactive': inactive,
  };
}

class ViewsStatsModel extends ViewsStats {
  const ViewsStatsModel({required super.total, required super.thisMonth});

  factory ViewsStatsModel.fromJson(Map<String, dynamic> json) {
    return ViewsStatsModel(
      total: json['total']?.toString() ?? '0',
      thisMonth: json['this_month']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() => {'total': total, 'this_month': thisMonth};
}

class SubscriptionInfoModel extends SubscriptionInfo {
  const SubscriptionInfoModel({
    required super.planName,
    required super.status,
    required super.endDate,
    required super.daysRemaining,
    required super.isExpiringSoon,
  });

  factory SubscriptionInfoModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionInfoModel(
      planName: json['plan_name'] ?? '',
      status: json['status'] ?? '',
      endDate: json['end_date'] ?? '',
      daysRemaining: json['days_remaining'] ?? 0,
      isExpiringSoon: json['is_expiring_soon'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'plan_name': planName,
    'status': status,
    'end_date': endDate,
    'days_remaining': daysRemaining,
    'is_expiring_soon': isExpiringSoon,
  };
}

class LimitsInfoModel extends LimitsInfo {
  const LimitsInfoModel({
    required super.maxProperties,
    required super.usedProperties,
    required super.canAddMore,
  });

  factory LimitsInfoModel.fromJson(Map<String, dynamic> json) {
    return LimitsInfoModel(
      maxProperties: json['max_properties'] ?? 0,
      usedProperties: json['used_properties'] ?? 0,
      canAddMore: json['can_add_more'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'max_properties': maxProperties,
    'used_properties': usedProperties,
    'can_add_more': canAddMore,
  };
}

class RecentPropertyModel extends RecentPropertyEntity {
  const RecentPropertyModel({
    required super.id,
    required super.title,
    required super.price,
    required super.status,
    required super.propertyType,
    required super.offerType,
    required super.governorate,
    required super.viewsCount,
    required super.createdAt,
  });

  factory RecentPropertyModel.fromJson(Map<String, dynamic> json) {
    return RecentPropertyModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      price: json['price']?.toString() ?? '0',
      status: json['status'] ?? '',
      propertyType: json['property_type'] ?? '',
      offerType: json['offer_type'] ?? '',
      governorate: json['governorate'] ?? '',
      viewsCount: json['views_count'] ?? 0,
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'price': price,
    'status': status,
    'property_type': propertyType,
    'offer_type': offerType,
    'governorate': governorate,
    'views_count': viewsCount,
    'created_at': createdAt,
  };
}

class TopViewedPropertyModel extends TopViewedPropertyEntity {
  const TopViewedPropertyModel({
    required super.id,
    required super.title,
    required super.propertyType,
    required super.offerType,
    required super.viewsCount,
  });

  factory TopViewedPropertyModel.fromJson(Map<String, dynamic> json) {
    return TopViewedPropertyModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      propertyType: json['property_type'] ?? '',
      offerType: json['offer_type'] ?? '',
      viewsCount: json['views_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'property_type': propertyType,
    'offer_type': offerType,
    'views_count': viewsCount,
  };
}
