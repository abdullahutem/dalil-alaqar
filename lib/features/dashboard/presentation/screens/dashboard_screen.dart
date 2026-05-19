import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:dalil_alaqar/features/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:dalil_alaqar/features/dashboard/presentation/widgets/dashboard_drawer.dart';
import 'package:dalil_alaqar/features/dashboard/presentation/widgets/dashboard_skeleton.dart';
import 'package:dalil_alaqar/features/dashboard/presentation/widgets/stat_card.dart';
import 'package:dalil_alaqar/features/dashboard/presentation/widgets/subscription_card.dart';
import 'package:dalil_alaqar/features/dashboard/presentation/widgets/property_list_item.dart';
import 'package:dalil_alaqar/features/dashboard/presentation/widgets/top_viewed_item.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardCubit.create()..getDashboardStats(),
      child: const DashboardContent(),
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة التحكم'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const DashboardDrawer(),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const DashboardSkeleton();
          }

          if (state is DashboardError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'حدث خطأ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<DashboardCubit>().getDashboardStats();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة المحاولة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is DashboardSuccess) {
            final stats = state.stats;

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<DashboardCubit>().refresh();
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats Cards Grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.5,
                      children: [
                        StatCard(
                          title: 'إجمالي العقارات',
                          value: '${stats.properties.total}',
                          icon: Icons.home_work,
                          color: Colors.blue,
                          subtitle: 'هذا الشهر: ${stats.properties.thisMonth}',
                        ),
                        StatCard(
                          title: 'عقارات متاحة',
                          value: '${stats.properties.available}',
                          icon: Icons.check_circle,
                          color: Colors.green,
                        ),
                        StatCard(
                          title: 'عقارات محجوزة',
                          value: '${stats.properties.reserved}',
                          icon: Icons.bookmark,
                          color: Colors.orange,
                        ),
                        StatCard(
                          title: 'عقارات مباعة',
                          value: '${stats.properties.sold}',
                          icon: Icons.sell,
                          color: Colors.red,
                        ),
                        StatCard(
                          title: 'إجمالي الموظفين',
                          value: '${stats.employees.total}',
                          icon: Icons.people,
                          color: Colors.purple,
                          subtitle: 'نشط: ${stats.employees.active}',
                        ),
                        StatCard(
                          title: 'إجمالي المشاهدات',
                          value: stats.views.total,
                          icon: Icons.visibility,
                          color: Colors.teal,
                          subtitle: 'هذا الشهر: ${stats.views.thisMonth}',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Subscription Card
                    SubscriptionCard(
                      subscription: stats.subscription,
                      limits: stats.limits,
                    ),
                    const SizedBox(height: 24),

                    // Recent Properties Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'العقارات الأخيرة',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (stats.recentProperties.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(
                            'لا توجد عقارات حديثة',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      )
                    else
                      ...stats.recentProperties.map(
                        (property) => PropertyListItem(property: property),
                      ),
                    const SizedBox(height: 24),

                    // Top Viewed Properties Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'الأكثر مشاهدة',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (stats.topViewedProperties.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(
                            'لا توجد عقارات',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      )
                    else
                      ...stats.topViewedProperties.asMap().entries.map(
                        (entry) => TopViewedItem(
                          property: entry.value,
                          rank: entry.key + 1,
                        ),
                      ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
