import 'package:flutter/material.dart';
import '../../domain/entities/employee_entity.dart';

class EmployeeCardCompact extends StatelessWidget {
  final EmployeeEntity employee;

  const EmployeeCardCompact({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAvatar(context),
          const SizedBox(height: 8),
          Text(
            employee.name,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            employee.office.name,
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: employee.isActive
                  ? Colors.green.withValues(alpha: 0.12)
                  : Colors.red.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              employee.isActive ? 'نشط' : 'غير نشط',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: employee.isActive ? Colors.green[700] : Colors.red[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: employee.avatar != null
          ? ClipOval(
              child: Image.network(
                employee.avatar!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, _) => _defaultAvatarIcon(context),
              ),
            )
          : _defaultAvatarIcon(context),
    );
  }

  Widget _defaultAvatarIcon(BuildContext context) {
    return Icon(
      Icons.person,
      color: Theme.of(context).colorScheme.primary,
      size: 28,
    );
  }
}
