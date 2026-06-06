import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/office_properties_cubit.dart';
import '../cubit/office_properties_state.dart';

class PropertyStatusDropdown extends StatelessWidget {
  final int propertyId;
  final String currentStatus;
  final bool compact;

  const PropertyStatusDropdown({
    super.key,
    required this.propertyId,
    required this.currentStatus,
    this.compact = false,
  });

  String _getStatusLabel(String status) {
    switch (status) {
      case 'available':
        return 'متاح';
      case 'reserved':
        return 'محجوز';
      case 'sold':
        return 'مباع';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'available':
        return Colors.green;
      case 'reserved':
        return Colors.orange;
      case 'sold':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfficePropertiesCubit, OfficePropertiesState>(
      builder: (context, state) {
        final isUpdating =
            state is OfficePropertiesSuccess &&
            state.updatingStatusPropertyId == propertyId;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 6 : 8,
            vertical: compact ? 2 : 4,
          ),
          decoration: BoxDecoration(
            color: _getStatusColor(currentStatus).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _getStatusColor(currentStatus).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: isUpdating
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SizedBox(
                    width: compact ? 12 : 16,
                    height: compact ? 12 : 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getStatusColor(currentStatus),
                      ),
                    ),
                  ),
                )
              : DropdownButton<String>(
                  value: currentStatus,
                  isDense: true,
                  underline: const SizedBox(),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: _getStatusColor(currentStatus),
                    size: compact ? 18 : 20,
                  ),
                  style: TextStyle(
                    fontSize: compact ? 10 : 11,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(currentStatus),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'available',
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.green,
                          ),
                          SizedBox(width: 6),
                          Text('متاح'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'reserved',
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.schedule, size: 16, color: Colors.orange),
                          SizedBox(width: 6),
                          Text('محجوز'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'sold',
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.sell, size: 16, color: Colors.red),
                          SizedBox(width: 6),
                          Text('مباع'),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (String? newStatus) {
                    if (newStatus != null && newStatus != currentStatus) {
                      _showConfirmationDialog(context, newStatus);
                    }
                  },
                ),
        );
      },
    );
  }

  void _showConfirmationDialog(BuildContext context, String newStatus) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('تأكيد تحديث الحالة'),
          content: Text(
            'هل أنت متأكد من تغيير حالة العقار من "${_getStatusLabel(currentStatus)}" إلى "${_getStatusLabel(newStatus)}"؟',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                final cubit = context.read<OfficePropertiesCubit>();
                final success = await cubit.updatePropertyStatus(
                  propertyId: propertyId,
                  status: newStatus,
                );

                if (context.mounted) {
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'تم تحديث حالة العقار إلى ${_getStatusLabel(newStatus)} بنجاح',
                        ),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('فشل تحديث حالة العقار'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }
              },
              child: const Text('تأكيد'),
            ),
          ],
        );
      },
    );
  }
}
