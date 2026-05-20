import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:dalil_alaqar/features/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:dalil_alaqar/features/dashboard/presentation/widgets/dashboard_drawer.dart';
import 'package:dalil_alaqar/features/dashboard/presentation/widgets/subscription_card.dart';
import 'package:dalil_alaqar/features/dashboard/presentation/widgets/property_list_item.dart';
import 'package:dalil_alaqar/features/dashboard/presentation/widgets/top_viewed_item.dart';

class DashboardMobileLayout extends StatelessWidget {
  const DashboardMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final bg = isDark ? const Color(0xFF111111) : const Color(0xFFF2F2F7);
    final border = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.08);
    final muted = isDark
        ? Colors.white.withValues(alpha: 0.40)
        : Colors.black.withValues(alpha: 0.38);
    final primary = isDark ? Colors.white : Colors.black;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: surface,
          elevation: 0,
          scrolledUnderElevation: 0.5,
          shadowColor: border,
          centerTitle: true,
          title: Text(
            'لوحة التحكم',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: primary,
              letterSpacing: -0.2,
            ),
          ),
          iconTheme: IconThemeData(color: primary),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0.5),
            child: Divider(height: 0.5, thickness: 0.5, color: border),
          ),
        ),
        drawer: const DashboardDrawer(),
        body: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return _LoadingView(
                bg: bg,
                isDark: isDark,
                surface: surface,
                border: border,
              );
            }
            if (state is DashboardError) {
              return _ErrorView(
                message: state.message,
                isDark: isDark,
                border: border,
                muted: muted,
                primary: primary,
                onRetry: () =>
                    context.read<DashboardCubit>().getDashboardStats(),
              );
            }
            if (state is DashboardSuccess) {
              final stats = state.stats;
              return RefreshIndicator(
                color: const Color(0xFF1D9E75),
                onRefresh: () => context.read<DashboardCubit>().refresh(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      // Stats Grid
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _SectionLabel(text: 'الإحصائيات', muted: muted),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.3,
                          children: [
                            _StatCard(
                              title: 'إجمالي العقارات',
                              value: '${stats.properties.total}',
                              subtitle:
                                  'هذا الشهر: ${stats.properties.thisMonth}',
                              icon: Icons.home_work_outlined,
                              isDark: isDark,
                              surface: surface,
                              border: border,
                              muted: muted,
                              primary: primary,
                            ),
                            _StatCard(
                              title: 'متاحة',
                              value: '${stats.properties.available}',
                              icon: Icons.check_circle_outline_rounded,
                              isDark: isDark,
                              surface: surface,
                              border: border,
                              muted: muted,
                              primary: primary,
                            ),
                            _StatCard(
                              title: 'محجوزة',
                              value: '${stats.properties.reserved}',
                              icon: Icons.bookmark_outline_rounded,
                              isDark: isDark,
                              surface: surface,
                              border: border,
                              muted: muted,
                              primary: primary,
                            ),
                            _StatCard(
                              title: 'مباعة',
                              value: '${stats.properties.sold}',
                              icon: Icons.sell_outlined,
                              isDark: isDark,
                              surface: surface,
                              border: border,
                              muted: muted,
                              primary: primary,
                            ),
                            _StatCard(
                              title: 'الموظفون',
                              value: '${stats.employees.total}',
                              subtitle: 'نشط: ${stats.employees.active}',
                              icon: Icons.people_outline_rounded,
                              isDark: isDark,
                              surface: surface,
                              border: border,
                              muted: muted,
                              primary: primary,
                            ),
                            _StatCard(
                              title: 'المشاهدات',
                              value: stats.views.total,
                              subtitle: 'هذا الشهر: ${stats.views.thisMonth}',
                              icon: Icons.remove_red_eye_outlined,
                              isDark: isDark,
                              surface: surface,
                              border: border,
                              muted: muted,
                              primary: primary,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Subscription
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _SectionLabel(text: 'الاشتراك', muted: muted),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SubscriptionCard(
                          subscription: stats.subscription,
                          limits: stats.limits,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Recent Properties
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _SectionLabel(
                          text: 'العقارات الأخيرة',
                          muted: muted,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (stats.recentProperties.isEmpty)
                        _EmptyState(
                          message: 'لا توجد عقارات حديثة',
                          muted: muted,
                        )
                      else
                        _CardList(
                          surface: surface,
                          border: border,
                          children: stats.recentProperties.map((p) {
                            return PropertyListItem(property: p);
                          }).toList(),
                        ),
                      const SizedBox(height: 24),
                      // Top Viewed
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _SectionLabel(
                          text: 'الأكثر مشاهدة',
                          muted: muted,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (stats.topViewedProperties.isEmpty)
                        _EmptyState(message: 'لا توجد عقارات', muted: muted)
                      else
                        _CardList(
                          surface: surface,
                          border: border,
                          children: stats.topViewedProperties
                              .asMap()
                              .entries
                              .map((e) {
                                return TopViewedItem(
                                  property: e.value,
                                  rank: e.key + 1,
                                );
                              })
                              .toList(),
                        ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

// Loading & Error Views
class _LoadingView extends StatelessWidget {
  final Color bg;
  final bool isDark;
  final Color surface;
  final Color border;

  const _LoadingView({
    required this.bg,
    required this.isDark,
    required this.surface,
    required this.border,
  });

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: bg,
    child: SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _SkeletonBox(width: 80, height: 12, isDark: isDark),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.3,
              children: List.generate(
                6,
                (index) => _SkeletonStatCard(
                  isDark: isDark,
                  surface: surface,
                  border: border,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _SkeletonBox(width: 60, height: 12, isDark: isDark),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _SkeletonSubscriptionCard(
              isDark: isDark,
              surface: surface,
              border: border,
            ),
          ),
        ],
      ),
    ),
  );
}

class _ErrorView extends StatelessWidget {
  final String message;
  final bool isDark;
  final Color border, muted, primary;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.isDark,
    required this.border,
    required this.muted,
    required this.primary,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline_rounded, size: 48, color: muted),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: primary, height: 1.6),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.07)
                    : Colors.black.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: border, width: 0.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh_rounded, size: 16, color: muted),
                  const SizedBox(width: 6),
                  Text(
                    'إعادة المحاولة',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// Shared Widgets
class _SectionLabel extends StatelessWidget {
  final String text;
  final Color muted;
  const _SectionLabel({required this.text, required this.muted});

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      color: muted,
      letterSpacing: 0.5,
    ),
  );
}

class _EmptyState extends StatelessWidget {
  final String message;
  final Color muted;
  const _EmptyState({required this.message, required this.muted});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 28),
    child: Center(
      child: Text(message, style: TextStyle(fontSize: 13, color: muted)),
    ),
  );
}

class _CardList extends StatelessWidget {
  final Color surface, border;
  final List<Widget> children;
  const _CardList({
    required this.surface,
    required this.border,
    required this.children,
  });

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: border, width: 0.5),
    ),
    child: Column(children: children),
  );
}

// Stat Card
class _StatCard extends StatelessWidget {
  final String title, value;
  final String? subtitle;
  final IconData icon;
  final bool isDark;
  final Color surface, border, muted, primary;

  const _StatCard({
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    required this.isDark,
    required this.surface,
    required this.border,
    required this.muted,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: border, width: 0.5),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.07)
                : Colors.black.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: muted),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: primary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: muted),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 1),
              Text(
                subtitle!,
                style: TextStyle(fontSize: 10, color: muted),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ],
    ),
  );
}

// Skeleton Widgets
class _SkeletonBox extends StatelessWidget {
  final double width, height;
  final bool isDark;
  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: isDark
          ? Colors.white.withValues(alpha: 0.08)
          : Colors.black.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(4),
    ),
  );
}

class _SkeletonStatCard extends StatelessWidget {
  final bool isDark;
  final Color surface, border;
  const _SkeletonStatCard({
    required this.isDark,
    required this.surface,
    required this.border,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: border, width: 0.5),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _SkeletonBox(width: 30, height: 30, isDark: isDark),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _SkeletonBox(width: 50, height: 20, isDark: isDark),
            const SizedBox(height: 4),
            _SkeletonBox(width: 80, height: 12, isDark: isDark),
          ],
        ),
      ],
    ),
  );
}

class _SkeletonSubscriptionCard extends StatelessWidget {
  final bool isDark;
  final Color surface, border;
  const _SkeletonSubscriptionCard({
    required this.isDark,
    required this.surface,
    required this.border,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: border, width: 0.5),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SkeletonBox(width: 100, height: 15, isDark: isDark),
                  const SizedBox(height: 6),
                  _SkeletonBox(width: 60, height: 12, isDark: isDark),
                ],
              ),
            ),
            _SkeletonBox(width: 80, height: 24, isDark: isDark),
          ],
        ),
        const SizedBox(height: 16),
        _SkeletonBox(width: double.infinity, height: 12, isDark: isDark),
        const SizedBox(height: 8),
        _SkeletonBox(width: double.infinity, height: 6, isDark: isDark),
      ],
    ),
  );
}
