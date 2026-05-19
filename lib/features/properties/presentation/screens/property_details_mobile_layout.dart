import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:dalil_alaqar/features/properties/presentation/cubit/property_details_cubit.dart';
import 'package:dalil_alaqar/features/properties/presentation/cubit/property_details_state.dart';
import 'package:dalil_alaqar/features/properties/presentation/widgets/property_details_content.dart';
import 'package:dalil_alaqar/features/properties/presentation/widgets/property_image_gallery.dart';

class PropertyDetailsMobileLayout extends StatelessWidget {
  const PropertyDetailsMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
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
          final property = state.property;

          return CustomScrollView(
            slivers: [
              // App Bar with Image Gallery
              SliverAppBar(
                title: Text(
                  property.title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: AppColors.white),
                ),
                expandedHeight: 300,
                pinned: true,
                backgroundColor: isDark
                    ? AppColors.darkSurface
                    : AppColors.primary,
                leading: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),

                flexibleSpace: FlexibleSpaceBar(
                  background: PropertyImageGallery(
                    images: property.images,
                    primaryImage: property.primaryImage,
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: PropertyDetailsContent(property: property),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
