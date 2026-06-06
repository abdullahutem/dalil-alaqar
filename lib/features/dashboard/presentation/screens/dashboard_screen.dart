import 'package:dalil_alaqar/core/utils/breakpoints.dart';
import 'package:dalil_alaqar/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:dalil_alaqar/features/dashboard/presentation/screens/dashboard_mobile_layout.dart';
import 'package:dalil_alaqar/features/dashboard/presentation/screens/dashboard_tablet_layout.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DashboardCubit.create()..getDashboardStats(),
        ),
        BlocProvider(create: (context) => ProfileCubit.create()),
      ],
      child: const DashboardResponsive(),
    );
  }
}

class DashboardResponsive extends StatelessWidget {
  const DashboardResponsive({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Mobile: < 600px
        // Tablet: 600px - 1024px
        // Desktop: > 1024px (currently using tablet layout)

        if (Breakpoints.isMobile(constraints.maxWidth)) {
          return const DashboardMobileLayout();
        } else {
          return const DashboardTabletLayout();
        }
      },
    );
  }
}
