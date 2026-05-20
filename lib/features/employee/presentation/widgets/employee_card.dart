import 'package:flutter/material.dart';
import '../../domain/entities/employee_entity.dart';

class EmployeeCard extends StatelessWidget {
  final EmployeeEntity employee;

  const EmployeeCard({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _buildAvatar(context),
            const SizedBox(width: 12),
            Expanded(child: _buildInfo(context)),
            _buildStatusBadge(context),
          ],
        ),
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

  Widget _buildInfo(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          employee.name,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              Icons.email_outlined,
              size: 13,
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                employee.email,
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Row(
          children: [
            Icon(
              Icons.phone_outlined,
              size: 13,
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 4),
            Text(
              employee.phoneNumber,
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Row(
          children: [
            Icon(
              Icons.business_outlined,
              size: 13,
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                employee.office.name,
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: employee.isActive
            ? Colors.green.withValues(alpha: 0.12)
            : Colors.red.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        employee.isActive ? 'نشط' : 'غير نشط',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: employee.isActive ? Colors.green[700] : Colors.red[700],
        ),
      ),
    );
  }
}
