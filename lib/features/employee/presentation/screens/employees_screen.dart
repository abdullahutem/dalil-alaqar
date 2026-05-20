import 'package:dalil_alaqar/core/localization/app_localizations.dart';
import 'package:dalil_alaqar/core/localization/locale_cubit.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:dalil_alaqar/core/utils/breakpoints.dart';
import 'package:dalil_alaqar/features/employee/presentation/cubit/employees_cubit.dart';
import 'package:dalil_alaqar/features/employee/presentation/screens/employees_mobile_layout.dart';
import 'package:dalil_alaqar/features/employee/presentation/screens/employees_tablet_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmployeesCubit.create()..getEmployees(),
      child: const EmployeesResponsive(),
    );
  }
}

class EmployeesResponsive extends StatelessWidget {
  const EmployeesResponsive({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isRTL = context.read<LocaleCubit>().isArabic;
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
    );
  }
}
