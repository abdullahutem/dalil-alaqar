import 'package:dalil_alaqar/core/localization/app_localizations.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:dalil_alaqar/core/utils/breakpoints.dart';
import 'package:dalil_alaqar/features/employee/domain/entities/employee_entity.dart';
import 'package:dalil_alaqar/features/employee/presentation/cubit/add_employee_cubit.dart';
import 'package:dalil_alaqar/features/employee/presentation/cubit/update_employee_cubit.dart';
import 'package:dalil_alaqar/features/employee/presentation/screens/add_employees_mobile_layout.dart';
import 'package:dalil_alaqar/features/employee/presentation/screens/add_employees_tablet_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEmployeesScreen extends StatelessWidget {
  final EmployeeEntity? employee;

  const AddEmployeesScreen({super.key, this.employee});

  @override
  Widget build(BuildContext context) {
    // If employee is provided, use UpdateEmployeeCubit, otherwise use AddEmployeeCubit
    if (employee != null) {
      return BlocProvider(
        create: (context) => UpdateEmployeeCubit.create(),
        child: AddEmployeesResponsive(employee: employee),
      );
    } else {
      return BlocProvider(
        create: (context) => AddEmployeeCubit.create(),
        child: const AddEmployeesResponsive(),
      );
    }
  }
}

class AddEmployeesResponsive extends StatelessWidget {
  final EmployeeEntity? employee;

  const AddEmployeesResponsive({super.key, this.employee});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          employee != null
              ? 'تحديث الموظف'
              : localizations.translate('add_employee'),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (Breakpoints.isMobile(constraints.maxWidth)) {
            return AddEmployeesMobileLayout(employee: employee);
          } else {
            return AddEmployeesTabletLayout(employee: employee);
          }
        },
      ),
    );
  }
}
