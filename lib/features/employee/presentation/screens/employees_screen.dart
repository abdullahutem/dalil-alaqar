import 'package:dalil_alaqar/core/localization/app_localizations.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:dalil_alaqar/core/utils/breakpoints.dart';
import 'package:dalil_alaqar/features/employee/presentation/cubit/employee_stats_cubit.dart';
import 'package:dalil_alaqar/features/employee/presentation/cubit/employees_cubit.dart';
import 'package:dalil_alaqar/features/employee/presentation/screens/add_employees_screen.dart';
import 'package:dalil_alaqar/features/employee/presentation/screens/employees_mobile_layout.dart';
import 'package:dalil_alaqar/features/employee/presentation/screens/employees_tablet_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EmployeesCubit.create()..getEmployees(),
        ),
        BlocProvider(
          create: (context) => EmployeeStatsCubit.create()..getStats(),
        ),
      ],
      child: const EmployeesResponsive(),
    );
  }
}

class EmployeesResponsive extends StatelessWidget {
  const EmployeesResponsive({super.key});

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
        title: Text(localizations.translate('app_name')),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Mobile: < 600px
          // Tablet: 600px - 1024px
          // Desktop: > 1024px (currently using tablet layout)

          if (Breakpoints.isMobile(constraints.maxWidth)) {
            return const EmployeesMobileLayout();
          } else {
            return const EmployeesTabletLayout();
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEmployeesScreen()),
          );
          // Refresh the list if an employee was added
          if (result == true && context.mounted) {
            context.read<EmployeesCubit>().refresh();
            context.read<EmployeeStatsCubit>().getStats();
          }
        },
        backgroundColor: isDark ? AppColors.darkDivider : AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          localizations.translate('add_employee'),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
