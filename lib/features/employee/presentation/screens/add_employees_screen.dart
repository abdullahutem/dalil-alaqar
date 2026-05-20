import 'package:dalil_alaqar/core/localization/app_localizations.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:dalil_alaqar/core/utils/breakpoints.dart';
import 'package:dalil_alaqar/features/employee/presentation/cubit/add_employee_cubit.dart';
import 'package:dalil_alaqar/features/employee/presentation/screens/add_employees_mobile_layout.dart';
import 'package:dalil_alaqar/features/employee/presentation/screens/add_employees_tablet_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEmployeesScreen extends StatelessWidget {
  const AddEmployeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddEmployeeCubit.create(),
      child: const AddEmployeesResponsive(),
    );
  }
}

class AddEmployeesResponsive extends StatelessWidget {
  const AddEmployeesResponsive({super.key});

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
        title: Text(localizations.translate('add_employee')),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (Breakpoints.isMobile(constraints.maxWidth)) {
            return const AddEmployeesMobileLayout();
          } else {
            return const AddEmployeesTabletLayout();
          }
        },
      ),
    );
  }
}
