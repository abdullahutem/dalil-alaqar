import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/employee_entity.dart';
import '../cubit/delete_employee_cubit.dart';
import '../cubit/delete_employee_state.dart';
import '../cubit/employee_stats_cubit.dart';
import '../screens/add_employees_screen.dart';

class EmployeeCardTablet extends StatelessWidget {
  final EmployeeEntity employee;
  final VoidCallback? onUpdate;
  final VoidCallback? onDelete;

  const EmployeeCardTablet({
    super.key,
    required this.employee,
    this.onUpdate,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
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
                const SizedBox(width: 8),
                _buildPopupMenu(context),
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

  Widget _buildPopupMenu(BuildContext context) {
    final theme = Theme.of(context);
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: theme.iconTheme.color),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onSelected: (value) async {
        if (value == 'update') {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEmployeesScreen(employee: employee),
            ),
          );
          if (result == true && onUpdate != null) {
            onUpdate!();
            // Refresh stats after update
            if (context.mounted) {
              context.read<EmployeeStatsCubit>().getStats();
            }
          }
        } else if (value == 'delete') {
          _showDeleteDialog(context);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'update',
          child: Row(
            children: [
              Icon(
                Icons.edit_outlined,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              const Text('تحديث'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              const Icon(Icons.delete_outline, size: 20, color: Colors.red),
              const SizedBox(width: 12),
              const Text('حذف'),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider(
        create: (context) => DeleteEmployeeCubit.create(),
        child: BlocConsumer<DeleteEmployeeCubit, DeleteEmployeeState>(
          listener: (context, state) {
            if (state is DeleteEmployeeSuccess) {
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              if (onDelete != null) {
                onDelete!();
              }
              // Refresh stats after delete
              context.read<EmployeeStatsCubit>().getStats();
            } else if (state is DeleteEmployeeError) {
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is DeleteEmployeeLoading;
            return AlertDialog(
              title: const Text('تأكيد الحذف'),
              content: Text('هل أنت متأكد من حذف الموظف "${employee.name}"؟'),
              actions: [
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text('إلغاء'),
                ),
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          context.read<DeleteEmployeeCubit>().deleteEmployee(
                            employeeId: employee.id,
                          );
                        },
                  child: isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('حذف', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
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
        Icon(icon, size: 16, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  color: theme.textTheme.bodySmall?.color?.withValues(
                    alpha: 0.6,
                  ),
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
