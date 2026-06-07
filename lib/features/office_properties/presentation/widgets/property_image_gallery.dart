import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/property_details_entity.dart';
import '../cubit/property_details_cubit.dart';

class PropertyImageGallery extends StatefulWidget {
  final List<PropertyImageEntity> images;
  final String? baseUrl;
  final int? propertyId;

  const PropertyImageGallery({
    super.key,
    required this.images,
    this.baseUrl,
    this.propertyId,
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
                  fit: BoxFit.fill,
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
              child: const Icon(
                Icons.fullscreen,
                color: Colors.white,
                size: 20,
              ),
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
    BuildContext context,
    List<PropertyImageEntity> images,
    int index,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<PropertyDetailsCubit>(),
          child: _FullScreenGallery(
            images: images,
            initialIndex: index,
            baseUrl: widget.baseUrl,
            propertyId: widget.propertyId,
          ),
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
  final int? propertyId;

  const _FullScreenGallery({
    required this.images,
    required this.initialIndex,
    this.baseUrl,
    this.propertyId,
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
    final currentImage = widget.images[_current];
    final canSetPrimary = widget.propertyId != null && !currentImage.isPrimary;
    final canDelete = widget.propertyId != null && widget.images.length > 1;

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
        actions: [
          if (canSetPrimary)
            IconButton(
              icon: const Icon(Icons.star_border, color: Colors.white),
              tooltip: 'تعيين كصورة رئيسية',
              onPressed: () => _setPrimaryImage(context),
            ),
          if (canDelete)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              tooltip: 'حذف الصورة',
              onPressed: () => _deleteImage(context),
            ),
          if (currentImage.isPrimary)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'رئيسية',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
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
                errorWidget: (_, __, ___) => const Icon(
                  Icons.broken_image,
                  color: Colors.white54,
                  size: 64,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _setPrimaryImage(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تعيين صورة رئيسية'),
        content: const Text('هل تريد تعيين هذه الصورة كصورة رئيسية للعقار؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('تعيين'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final cubit = context.read<PropertyDetailsCubit>();
      final currentImage = widget.images[_current];

      final success = await cubit.setPrimaryImage(
        widget.propertyId!,
        currentImage.id,
      );

      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تعيين الصورة كرئيسية بنجاح'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        // Just update the UI, don't close the fullscreen view
        // The gallery will update automatically through BlocListener
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('فشل تعيين الصورة كرئيسية'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteImage(BuildContext context) async {
    final currentImage = widget.images[_current];

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('حذف الصورة'),
        content: Text(
          currentImage.isPrimary
              ? 'هذه الصورة هي الصورة الرئيسية. عند حذفها، سيتم تعيين صورة أخرى تلقائياً كصورة رئيسية. هل تريد المتابعة؟'
              : 'هل أنت متأكد من حذف هذه الصورة؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final cubit = context.read<PropertyDetailsCubit>();

      final success = await cubit.deletePropertyImage(
        widget.propertyId!,
        currentImage.id,
      );

      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حذف الصورة بنجاح'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        // Close fullscreen view since the image list has changed
        Navigator.of(context).pop();
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('فشل حذف الصورة'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
