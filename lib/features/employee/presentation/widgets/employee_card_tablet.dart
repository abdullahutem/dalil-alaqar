import 'package:flutter/material.dart';
import '../../domain/entities/employee_entity.dart';

class EmployeeCardTablet extends StatelessWidget {
  final EmployeeEntity employee;

  const EmployeeCardTablet({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildAvatar(context),
                const SizedBox(width: 16),
                Expanded(child: _buildHeader(context)),
                _buildStatusBadge(context),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            _buildContactRow(context),
            const SizedBox(height: 8),
            _buildOfficeRow(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 64,
      height: 64,
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
      size: 34,
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          employee.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          employee.role,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.primary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildContactRow(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: _infoItem(
            context,
            icon: Icons.email_outlined,
            label: 'البريد الإلكتروني',
            value: employee.email,
            theme: theme,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _infoItem(
            context,
            icon: Icons.phone_outlined,
            label: 'رقم الهاتف',
            value: employee.phoneNumber,
            theme: theme,
          ),
        ),
      ],
    );
  }

  Widget _buildOfficeRow(BuildContext context) {
    final theme = Theme.of(context);
    return _infoItem(
      context,
      icon: Icons.business_outlined,
      label: 'المكتب',
      value: employee.office.name,
      theme: theme,
    );
  }

  Widget _infoItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  color: theme.textTheme.bodySmall?.color
                      ?.withValues(alpha: 0.6),
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: employee.isActive
            ? Colors.green.withValues(alpha: 0.12)
            : Colors.red.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        employee.isActive ? 'نشط' : 'غير نشط',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: employee.isActive ? Colors.green[700] : Colors.red[700],
        ),
      ),
    );
  }
}
