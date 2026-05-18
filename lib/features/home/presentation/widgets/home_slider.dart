import 'package:flutter/material.dart';
import 'package:dalil_alaqar/core/localization/app_localizations.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';

class HomeSlider extends StatefulWidget {
  final bool isTablet;

  const HomeSlider({super.key, this.isTablet = false});

  @override
  State<HomeSlider> createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final height = widget.isTablet ? 400.0 : 320.0;

    return Container(
      height: height,
      margin: widget.isTablet
          ? const EdgeInsets.fromLTRB(24, 0, 24, 0)
          : EdgeInsets.zero,
      decoration: BoxDecoration(),
      child: ClipRRect(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: 3,
              itemBuilder: (context, index) {
                return _buildSlide(context, index, localizations);
              },
            ),
            // Gradient Overlay
            Positioned.fill(
              child: Container(
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
            ),
            // Content
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.all(widget.isTablet ? 48 : 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.translate('welcome_title'),
                      style: TextStyle(
                        fontSize: widget.isTablet ? 36 : 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      localizations.translate('welcome_subtitle'),
                      style: TextStyle(
                        fontSize: widget.isTablet ? 16 : 14,
                        color: AppColors.white.withValues(alpha: 0.9),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
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
                  3,
                  (index) => AnimatedContainer(
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
          ],
        ),
      ),
    );
  }

  Widget _buildSlide(
    BuildContext context,
    int index,
    AppLocalizations localizations,
  ) {
    final gradients = [
      [const Color(0xFF2C3E50), const Color(0xFF3498DB)],
      [const Color(0xFF1A237E), const Color(0xFF283593)],
      [const Color(0xFF4A148C), const Color(0xFF6A1B9A)],
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradients[index],
        ),
      ),
      child: Stack(
        children: [
          // Decorative Pattern
          Positioned(
            right: -80,
            top: -80,
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                Icons.hotel_rounded,
                size: 280,
                color: AppColors.white,
              ),
            ),
          ),
          Positioned(
            left: -40,
            bottom: -40,
            child: Opacity(
              opacity: 0.08,
              child: Icon(
                Icons.star_rounded,
                size: 180,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
