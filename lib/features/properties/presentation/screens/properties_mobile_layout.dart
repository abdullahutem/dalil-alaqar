import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:dalil_alaqar/features/properties/presentation/cubit/properties_cubit.dart';
import 'package:dalil_alaqar/features/properties/presentation/cubit/properties_state.dart';
import 'package:dalil_alaqar/features/properties/presentation/widgets/property_card.dart';

class PropertiesMobileLayout extends StatefulWidget {
  const PropertiesMobileLayout({super.key});

  @override
  State<PropertiesMobileLayout> createState() => _PropertiesMobileLayoutState();
}

class _PropertiesMobileLayoutState extends State<PropertiesMobileLayout> {
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
    return BlocBuilder<PropertiesCubit, PropertiesState>(
      builder: (context, state) {
        if (state is PropertiesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PropertiesError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: AppColors.error),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    state.message,
                    style: TextStyle(color: AppColors.error),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<PropertiesCubit>().getProperties(
                      refresh: true,
                    );
                  },
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        if (state is PropertiesSuccess || state is PropertiesLoadMoreError) {
          final propertiesResponse = state is PropertiesSuccess
              ? state.propertiesResponse
              : (state as PropertiesLoadMoreError).propertiesResponse;

          final properties = propertiesResponse.properties;
          final isLoadingMore =
              state is PropertiesSuccess && state.isLoadingMore;

          if (properties.isEmpty) {
            return const Center(child: Text('لا توجد عقارات متاحة'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<PropertiesCubit>().getProperties(
                refresh: true,
              );
            },
            child: Column(
              children: [
                // Properties list
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: properties.length + (isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= properties.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final property = properties[index];
                      return PropertyCard(
                        property: property,
                        onTap: () {
                          // TODO: Navigate to property details
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('تم النقر على: ${property.title}'),
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
                    padding: const EdgeInsets.all(8),
                    color: Colors.red[50],
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: AppColors.error),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            state.message,
                            style: TextStyle(color: AppColors.error),
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
    );
  }
}
