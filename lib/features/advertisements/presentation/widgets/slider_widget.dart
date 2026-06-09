import 'package:carousel_slider/carousel_slider.dart';
import 'package:dalil_alaqar/core/databases/api/end_points.dart';
import 'package:dalil_alaqar/core/utils/image_cache_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:dalil_alaqar/features/advertisements/domain/entities/slide_entity.dart';
import 'package:dalil_alaqar/features/advertisements/presentation/cubit/slider_cubit.dart';
import 'package:dalil_alaqar/features/advertisements/presentation/cubit/slider_state.dart';
import 'package:dalil_alaqar/features/advertisements/presentation/widgets/slider_skeleton.dart';

class SliderWidget extends StatefulWidget {
  final bool isTablet;

  const SliderWidget({super.key, this.isTablet = false});

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    // استخدام Cubit الموجود بدلاً من إنشاء واحد جديد
    return _SliderContent(isTablet: widget.isTablet);
  }
}

class _SliderContent extends StatefulWidget {
  final bool isTablet;

  const _SliderContent({required this.isTablet});

  @override
  State<_SliderContent> createState() => _SliderContentState();
}

class _SliderContentState extends State<_SliderContent> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final height = widget.isTablet ? 400.0 : 320.0;

    return BlocBuilder<SliderCubit, SliderState>(
      builder: (context, state) {
        if (state is SliderLoading) {
          return SliderSkeleton(isTablet: widget.isTablet);
        }

        if (state is SliderError) {
          print("=============${state.message}");
          return Container(
            height: height,
            margin: widget.isTablet
                ? const EdgeInsets.fromLTRB(24, 0, 24, 0)
                : EdgeInsets.zero,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: TextStyle(color: AppColors.error),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SliderCubit>().getSlides();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is SliderSuccess) {
          final slides = state.sliderResponse.slides;

          if (slides.isEmpty) {
            return Container(
              height: height,
              margin: widget.isTablet
                  ? const EdgeInsets.fromLTRB(24, 0, 24, 0)
                  : EdgeInsets.zero,
              child: const Center(child: Text('No slides available')),
            );
          }

          return Container(
            margin: widget.isTablet
                ? const EdgeInsets.fromLTRB(24, 0, 24, 0)
                : EdgeInsets.zero,
            child: Stack(
              children: [
                CarouselSlider.builder(
                  carouselController: _carouselController,
                  itemCount: slides.length,
                  itemBuilder: (context, index, realIndex) {
                    return _buildSlide(context, slides[index]);
                  },
                  options: CarouselOptions(
                    height: height,
                    viewportFraction: 1.0,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 5),
                    autoPlayAnimationDuration: const Duration(
                      milliseconds: 800,
                    ),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                  ),
                ),
                // Indicators
                Positioned(
                  bottom: 24,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      slides.length,
                      (index) => GestureDetector(
                        onTap: () {
                          _carouselController.animateToPage(index);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 32 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? AppColors.primary
                                : AppColors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
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

  Widget _buildSlide(BuildContext context, SlideEntity slide) {
    // Construct full image URL
    // The API returns relative path like "advertisements/banner-apartments-baghdad.jpg"
    // We need to prepend the storage base URL
    final imageUrl = slide.image.startsWith('http')
        ? slide.image
        : '${EndPoints.kBaseImageUrl}${slide.image}';

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image with optimized caching
        ImageCacheConfig.cachedImage(imageUrl: imageUrl, fit: BoxFit.cover),
        // Gradient Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.3),
                Colors.black.withValues(alpha: 0.6),
              ],
            ),
          ),
        ),
        // Content
        Padding(
          padding: EdgeInsets.all(widget.isTablet ? 48 : 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                slide.title,
                style: TextStyle(
                  fontSize: widget.isTablet ? 36 : 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                slide.description,
                style: TextStyle(
                  fontSize: widget.isTablet ? 16 : 11,
                  color: AppColors.white.withValues(alpha: 0.9),
                  height: 1.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}
