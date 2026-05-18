import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// إعدادات الكاش المخصصة للصور
class ImageCacheConfig {
  // مدة الكاش للصور (30 يوم)
  static const Duration _maxCacheDuration = Duration(days: 30);

  // الحد الأقصى لعدد الصور في الكاش (500 صورة)
  static const int _maxCacheObjects = 500;

  // مدير الكاش المخصص
  static final CacheManager customCacheManager = CacheManager(
    Config(
      'customImageCache',
      stalePeriod: _maxCacheDuration,
      maxNrOfCacheObjects: _maxCacheObjects,
      repo: JsonCacheInfoRepository(databaseName: 'customImageCache'),
      fileService: HttpFileService(),
    ),
  );

  /// Widget مخصص لعرض الصور مع الكاش المحسّن
  static Widget cachedImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
    BorderRadius? borderRadius,
  }) {
    // التحقق من صحة القيم وتحويلها بشكل آمن
    int? memCacheWidth;
    int? memCacheHeight;

    if (width != null && width.isFinite && width > 0) {
      memCacheWidth = width.toInt();
    }

    if (height != null && height.isFinite && height > 0) {
      memCacheHeight = height.toInt();
    }

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        cacheManager: customCacheManager,
        placeholder: (context, url) => placeholder ?? _defaultPlaceholder(),
        errorWidget: (context, url, error) =>
            errorWidget ?? _defaultErrorWidget(),
        // تفعيل الكاش في الذاكرة أيضاً - فقط إذا كانت القيم صحيحة
        memCacheWidth: memCacheWidth,
        memCacheHeight: memCacheHeight,
        maxWidthDiskCache: 1000,
        maxHeightDiskCache: 1000,
      ),
    );
  }

  /// Placeholder افتراضي
  static Widget _defaultPlaceholder() {
    return Container(
      color: Colors.grey.withValues(alpha: 0.1),
      child: Center(
        child: Opacity(
          opacity: 0.15,
          child: ColorFiltered(
            colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            child: Image.asset("assets/images/logo.png", height: 80),
          ),
        ),
      ),
    );
  }

  /// Error widget افتراضي
  static Widget _defaultErrorWidget() {
    return Container(
      color: Colors.grey.withValues(alpha: 0.1),
      child: Center(
        child: Opacity(
          opacity: 0.15,
          child: ColorFiltered(
            colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            child: Image.asset("assets/images/logo.png", height: 80),
          ),
        ),
      ),
    );
  }

  /// حذف كاش الصور
  static Future<void> clearImageCache() async {
    await customCacheManager.emptyCache();
  }

  /// حذف صورة معينة من الكاش
  static Future<void> removeImageFromCache(String imageUrl) async {
    await customCacheManager.removeFile(imageUrl);
  }

  /// الحصول على حجم الكاش
  static Future<int> getCacheSize() async {
    final files = await customCacheManager.getFileFromCache('');
    return files?.validTill.millisecondsSinceEpoch ?? 0;
  }

  /// تحميل الصور مسبقاً (Preload)
  static Future<void> preloadImages(
    BuildContext context,
    List<String> imageUrls,
  ) async {
    for (final url in imageUrls) {
      try {
        await precacheImage(
          CachedNetworkImageProvider(url, cacheManager: customCacheManager),
          context,
        );
      } catch (e) {
        print('Error preloading image $url: $e');
      }
    }
  }
}
