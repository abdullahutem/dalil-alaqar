import 'package:flutter/material.dart';
import 'package:dalil_alaqar/features/dashboard/domain/entities/dashboard_stats_entity.dart';

class SubscriptionCard extends StatelessWidget {
  final SubscriptionInfo subscription;
  final LimitsInfo limits;

  const SubscriptionCard({
    super.key,
    required this.subscription,
    required this.limits,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = subscription.status == 'active';
    final isExpiringSoon = subscription.isExpiringSoon;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isActive
              ? [Colors.blue[700]!, Colors.blue[500]!]
              : [Colors.grey[700]!, Colors.grey[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: (isActive ? Colors.blue : Colors.grey).withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  subscription.planName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isActive ? 'نشط' : 'غير نشط',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // End Date
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.white70, size: 16),
              const SizedBox(width: 8),
              Text(
                'تنتهي في: ${subscription.endDate}',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Days Remaining
          Row(
            children: [
              Icon(
                isExpiringSoon ? Icons.warning_amber : Icons.access_time,
                color: isExpiringSoon ? Colors.orange[300] : Colors.white70,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'الأيام المتبقية: ${subscription.daysRemaining} يوم',
                style: TextStyle(
                  color: isExpiringSoon ? Colors.orange[300] : Colors.white70,
                  fontSize: 14,
                  fontWeight: isExpiringSoon
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(color: Colors.white30),
          const SizedBox(height: 12),

          // Limits Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'العقارات المستخدمة',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${limits.usedProperties} / ${limits.maxProperties}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: limits.canAddMore
                      ? Colors.green.withOpacity(0.3)
                      : Colors.red.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: limits.canAddMore ? Colors.green : Colors.red,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      limits.canAddMore ? Icons.check_circle : Icons.cancel,
                      color: limits.canAddMore ? Colors.green : Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      limits.canAddMore ? 'يمكن الإضافة' : 'الحد الأقصى',
                      style: TextStyle(
                        color: limits.canAddMore ? Colors.white : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
