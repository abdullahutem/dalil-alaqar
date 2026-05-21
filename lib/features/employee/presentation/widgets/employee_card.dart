import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/employee_entity.dart';
import '../cubit/delete_employee_cubit.dart';
import '../cubit/delete_employee_state.dart';
import '../cubit/employee_stats_cubit.dart';
import '../screens/add_employees_screen.dart';

class EmployeeCard extends StatelessWidget {
  final EmployeeEntity employee;
  final VoidCallback? onUpdate;
  final VoidCallback? onDelete;

  const EmployeeCard({
    super.key,
    required this.employee,
    this.onUpdate,
    this.onDelete,
  });

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
            const SizedBox(width: 8),
            _buildPopupMenu(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    final theme = Theme.of(context);
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: theme.iconTheme.color),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
