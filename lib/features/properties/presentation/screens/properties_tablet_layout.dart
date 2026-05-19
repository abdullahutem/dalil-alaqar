import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:dalil_alaqar/features/properties/presentation/cubit/properties_cubit.dart';
import 'package:dalil_alaqar/features/properties/presentation/cubit/properties_state.dart';
import 'package:dalil_alaqar/features/properties/presentation/widgets/property_card.dart';

class PropertiesTabletLayout extends StatefulWidget {
  const PropertiesTabletLayout({super.key});

  @override
  State<PropertiesTabletLayout> createState() => _PropertiesTabletLayoutState();
}

class _PropertiesTabletLayoutState extends State<PropertiesTabletLayout> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<PropertiesCubit>().loadMore();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: BlocBuilder<PropertiesCubit, PropertiesState>(
          builder: (context, state) {
            if (state is PropertiesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PropertiesError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 80, color: AppColors.error),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: Text(
                        state.message,
                        style: TextStyle(color: AppColors.error, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<PropertiesCubit>().getProperties(
                          refresh: true,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }

            if (state is PropertiesSuccess ||
                state is PropertiesLoadMoreError) {
              final propertiesResponse = state is PropertiesSuccess
                  ? state.propertiesResponse
                  : (state as PropertiesLoadMoreError).propertiesResponse;

              final properties = propertiesResponse.properties;
              final isLoadingMore =
                  state is PropertiesSuccess && state.isLoadingMore;

              if (properties.isEmpty) {
                return const Center(
                  child: Text(
                    'لا توجد عقارات متاحة',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<PropertiesCubit>().getProperties(
                    refresh: true,
                  );
                },
                child: Column(
                  children: [
                    // Properties count and pagination info
                    Container(
                      padding: const EdgeInsets.all(24),
                      color: Colors.grey[100],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'إجمالي العقارات: ${propertiesResponse.meta.total}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'صفحة ${propertiesResponse.meta.currentPage} من ${propertiesResponse.meta.lastPage}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Properties grid
                    Expanded(
                      child: GridView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(24),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 24,
                              mainAxisSpacing: 24,
                            ),
                        itemCount: properties.length + (isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= properties.length) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final property = properties[index];
                          return PropertyCard(
                            property: property,
                            onTap: () {
                              // TODO: Navigate to property details
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'تم النقر على: ${property.title}',
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    // Load more error message
                    if (state is PropertiesLoadMoreError)
                      Container(
                        padding: const EdgeInsets.all(12),
                        color: Colors.red[50],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, color: AppColors.error),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                state.message,
                                style: TextStyle(
                                  color: AppColors.error,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
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
