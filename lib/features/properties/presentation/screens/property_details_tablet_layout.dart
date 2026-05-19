import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:dalil_alaqar/features/properties/presentation/cubit/property_details_cubit.dart';
import 'package:dalil_alaqar/features/properties/presentation/cubit/property_details_state.dart';
import 'package:dalil_alaqar/features/properties/presentation/widgets/property_details_content.dart';
import 'package:dalil_alaqar/features/properties/presentation/widgets/property_image_gallery.dart';

class PropertyDetailsTabletLayout extends StatelessWidget {
  const PropertyDetailsTabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertyDetailsCubit, PropertyDetailsState>(
      builder: (context, state) {
        if (state is PropertyDetailsLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (state is PropertyDetailsError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 80,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('العودة'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is PropertyDetailsSuccess) {
          final isDark = Theme.of(context).brightness == Brightness.dark;

          final property = state.property;

          return CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                pinned: true,
                backgroundColor: isDark
                    ? AppColors.darkSurface
                    : AppColors.primary,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                  property.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),

              // Content in two columns
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column - Image Gallery
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: 500,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: PropertyImageGallery(
                            images: property.images,
                            primaryImage: property.primaryImage,
                          ),
                        ),
                      ),

                      const SizedBox(width: 24),

                      // Right Column - Details
                      Expanded(
                        flex: 2,
                        child: PropertyDetailsContent(
                          property: property,
                          isTablet: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
