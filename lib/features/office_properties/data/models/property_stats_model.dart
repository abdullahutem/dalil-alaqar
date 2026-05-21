import '../../domain/entities/property_stats_entity.dart';

class PropertyStatsModel extends PropertyStatsEntity {
  const PropertyStatsModel({
    required super.total,
    required super.available,
    required super.reserved,
    required super.sold,
    required super.rented,
  });

  factory PropertyStatsModel.fromJson(Map<String, dynamic> json) {
    return PropertyStatsModel(
      total: json['total'] ?? 0,
      available: json['available'] ?? 0,
      reserved: json['reserved'] ?? 0,
      sold: json['sold'] ?? 0,
      rented: json['rented'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'available': available,
      'reserved': reserved,
      'sold': sold,
      'rented': rented,
    };
  }
}
