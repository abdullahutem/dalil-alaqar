import 'package:flutter/material.dart';
import '../../domain/entities/plan_entity.dart';

class PlanDetailsScreen extends StatelessWidget {
  final PlanEntity plan;

  const PlanDetailsScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: Text(plan.name), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.grey.withValues(alpha: 0.05)
                    : Colors.grey.withValues(alpha: 0.03),
              ),
              child: Column(
                children: [
                  // Plan icon
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getPlanIcon(plan.slug),
                      color: primaryColor,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    plan.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    plan.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Pricing section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.payments_outlined,
                            color: primaryColor,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'الأسعار',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildPriceRow(
                        'شهري',
                        plan.prices.monthly,
                        isDark,
                        primaryColor,
                        isHighlighted: true,
                      ),
                      const Divider(height: 24),
                      _buildPriceRow(
                        'ربع سنوي',
                        plan.prices.quarterly,
                        isDark,
                        primaryColor,
                      ),
                      const Divider(height: 24),
                      _buildPriceRow(
                        'نصف سنوي',
                        plan.prices.semiAnnual,
                        isDark,
                        primaryColor,
                      ),
                      const Divider(height: 24),
                      _buildPriceRow(
                        'سنوي',
                        plan.prices.annual,
                        isDark,
                        primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Limits section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: primaryColor,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'الحدود',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildLimitRow(
                        Icons.home_work_outlined,
                        'العقارات',
                        plan.limits.isUnlimitedProperties
                            ? 'غير محدودة'
                            : '${plan.limits.maxProperties} عقار',
                        isDark,
                      ),
                      const SizedBox(height: 16),
                      _buildLimitRow(
                        Icons.people_outline,
                        'الموظفين',
                        plan.limits.isUnlimitedEmployees
                            ? 'غير محدود'
                            : '${plan.limits.maxEmployees} موظف',
                        isDark,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Features section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star_outline,
                            color: primaryColor,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'المميزات',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ...plan.features.map(
                        (feature) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: primaryColor,
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  feature,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Trial info
            if (plan.hasTrial)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  color: isDark
                      ? Colors.grey.withValues(alpha: 0.05)
                      : Colors.grey.withValues(alpha: 0.03),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Icon(
                          Icons.celebration_outlined,
                          color: isDark ? Colors.grey[400] : Colors.grey[700],
                          size: 32,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'تجربة مجانية',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'احصل على ${plan.trialDays} يوم تجربة مجانية',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String price,
    bool isDark,
    Color primaryColor, {
    bool isHighlighted = false,
  }) {
    return Container(
      padding: isHighlighted ? const EdgeInsets.all(12) : null,
      decoration: isHighlighted
          ? BoxDecoration(
              color: primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.normal,
              color: isHighlighted ? primaryColor : null,
            ),
          ),
          Row(
            children: [
              Text(
                _formatPrice(price),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isHighlighted ? primaryColor : null,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'دينار',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLimitRow(
    IconData icon,
    String label,
    String value,
    bool isDark,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(fontSize: 15)),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  IconData _getPlanIcon(String slug) {
    switch (slug.toLowerCase()) {
      case 'diamond':
        return Icons.diamond_outlined;
      case 'gold':
        return Icons.workspace_premium_outlined;
      case 'silver':
        return Icons.stars_outlined;
      case 'basic':
        return Icons.bookmark_border;
      default:
        return Icons.card_membership;
    }
  }

  String _formatPrice(String price) {
    final numPrice = double.tryParse(price) ?? 0;
    if (numPrice % 1 == 0) {
      return numPrice.toInt().toString();
    }
    return numPrice.toString();
  }
}
