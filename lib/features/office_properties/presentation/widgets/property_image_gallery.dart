import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/property_details_entity.dart';

class PropertyImageGallery extends StatefulWidget {
  final List<PropertyImageEntity> images;
  final String? baseUrl;

  const PropertyImageGallery({
    super.key,
    required this.images,
    this.baseUrl,
  });

  @override
  State<PropertyImageGallery> createState() => _PropertyImageGalleryState();
}

class _PropertyImageGalleryState extends State<PropertyImageGallery> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<PropertyImageEntity> get _sortedImages {
    final sorted = List<PropertyImageEntity>.from(widget.images);
    sorted.sort((a, b) => a.order.compareTo(b.order));
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final images = _sortedImages;

    if (images.isEmpty) {
      return _buildPlaceholder(context);
    }

    return Stack(
      children: [
        // Main pager
        SizedBox(
          height: 280,
          child: PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _openFullScreen(context, images, index),
                child: CachedNetworkImage(
                  imageUrl: _buildUrl(images[index].imagePath),
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    color: Theme.of(context).cardColor,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (_, __, ___) => _buildPlaceholder(context),
                ),
              );
            },
          ),
        ),

        // Counter badge
        if (images.length > 1)
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_currentIndex + 1} / ${images.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        // Dot indicators
        if (images.length > 1)
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _currentIndex == index ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),

        // Expand icon
        Positioned(
          top: 12,
          left: 12,
          child: GestureDetector(
            onTap: () => _openFullScreen(context, images, _currentIndex),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.fullscreen,
                  color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 280,
      color: theme.colorScheme.surfaceVariant,
      child: Center(
        child: Icon(
          Icons.home_work_outlined,
          size: 64,
          color: theme.colorScheme.primary.withOpacity(0.4),
        ),
      ),
    );
  }

  void _openFullScreen(
      BuildContext context, List<PropertyImageEntity> images, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _FullScreenGallery(
          images: images,
          initialIndex: index,
          baseUrl: widget.baseUrl,
        ),
      ),
    );
  }

  String _buildUrl(String path) {
    if (path.startsWith('http')) return path;
    final base = widget.baseUrl ?? '';
    return '$base/$path';
  }
}

class _FullScreenGallery extends StatefulWidget {
  final List<PropertyImageEntity> images;
  final int initialIndex;
  final String? baseUrl;

  const _FullScreenGallery({
    required this.images,
    required this.initialIndex,
    this.baseUrl,
  });

  @override
  State<_FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<_FullScreenGallery> {
  late int _current;
  late PageController _ctrl;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
    _ctrl = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  String _buildUrl(String path) {
    if (path.startsWith('http')) return path;
    final base = widget.baseUrl ?? '';
    return '$base/$path';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          '${_current + 1} / ${widget.images.length}',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: PageView.builder(
        controller: _ctrl,
        itemCount: widget.images.length,
        onPageChanged: (i) => setState(() => _current = i),
        itemBuilder: (context, index) {
          return InteractiveViewer(
            child: Center(
              child: CachedNetworkImage(
                imageUrl: _buildUrl(widget.images[index].imagePath),
                fit: BoxFit.contain,
                placeholder: (_, __) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (_, __, ___) => const Icon(Icons.broken_image,
                    color: Colors.white54, size: 64),
              ),
            ),
          );
        },
      ),
    );
  }
}
