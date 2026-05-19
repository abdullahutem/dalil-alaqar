class PromotionEntity {
  final int id;
  final String title;
  final String? description;
  final String? image;
  final String type; // 'percentage', 'fixed_amount', 'free_feature'
  final double? discountValue;
  final int? officeId;
  final int? propertyId;
  final int? planId;
  final String? startDate;
  final String? endDate;
  final String? terms;
  final int? maxUsage;
  final int usageCount;
  final bool isActive;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  const PromotionEntity({
    required this.id,
    required this.title,
    this.description,
    this.image,
    required this.type,
    this.discountValue,
    this.officeId,
    this.propertyId,
    this.planId,
    this.startDate,
    this.endDate,
    this.terms,
    this.maxUsage,
    required this.usageCount,
    required this.isActive,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  bool get isPercentage => type == 'percentage';
  bool get isFixedAmount => type == 'fixed_amount';
  bool get isFreeFeature => type == 'free_feature';

  int? get remainingUsage =>
      maxUsage != null ? maxUsage! - usageCount : null;

  double get usagePercentage =>
      maxUsage != null && maxUsage! > 0 ? usageCount / maxUsage! : 0;
}
