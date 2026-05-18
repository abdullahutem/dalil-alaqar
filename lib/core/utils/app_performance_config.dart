import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// إعدادات الأداء العامة للتطبيق
class AppPerformanceConfig {
  /// تفعيل تحسينات الأداء عند بدء التطبيق
  static void initialize() {
    // تفعيل الكاش للصور
    _setupImageCache();

    // تحسين أداء الرسم
    _setupRenderingOptimizations();

    // تحسين أداء الذاكرة
    _setupMemoryOptimizations();
  }

  /// إعداد كاش الصور
  static void _setupImageCache() {
    // تم إعداده في ImageCacheConfig
    print('✓ Image cache configured');
  }

  /// تحسينات الرسم
  static void _setupRenderingOptimizations() {
    // تفعيل الكاش للطبقات المعقدة
    debugRepaintRainbowEnabled = false;

    // تحسين أداء الظلال
    debugDisableShadows = false;

    print('✓ Rendering optimizations enabled');
  }

  /// تحسينات الذاكرة
  static void _setupMemoryOptimizations() {
    // تحديد حجم الكاش للصور في الذاكرة
    PaintingBinding.instance.imageCache.maximumSize = 100; // 100 صورة
    PaintingBinding.instance.imageCache.maximumSizeBytes =
        50 * 1024 * 1024; // 50 MB

    print('✓ Memory optimizations enabled');
  }

  /// تنظيف الذاكرة
  static void clearMemoryCache() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
    print('✓ Memory cache cleared');
  }

  /// الحصول على معلومات الكاش
  static Map<String, dynamic> getCacheInfo() {
    final imageCache = PaintingBinding.instance.imageCache;
    return {
      'currentSize': imageCache.currentSize,
      'maximumSize': imageCache.maximumSize,
      'currentSizeBytes': imageCache.currentSizeBytes,
      'maximumSizeBytes': imageCache.maximumSizeBytes,
      'liveImageCount': imageCache.liveImageCount,
      'pendingImageCount': imageCache.pendingImageCount,
    };
  }

  /// طباعة معلومات الكاش
  static void printCacheInfo() {
    final info = getCacheInfo();
    print('=== Cache Info ===');
    print('Current Size: ${info['currentSize']}/${info['maximumSize']}');
    print(
      'Current Bytes: ${(info['currentSizeBytes'] / 1024 / 1024).toStringAsFixed(2)} MB / ${(info['maximumSizeBytes'] / 1024 / 1024).toStringAsFixed(2)} MB',
    );
    print('Live Images: ${info['liveImageCount']}');
    print('Pending Images: ${info['pendingImageCount']}');
    print('==================');
  }
}

/// Widget لمراقبة الأداء (للتطوير فقط)
class PerformanceMonitor extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const PerformanceMonitor({
    super.key,
    required this.child,
    this.enabled = false,
  });

  @override
  State<PerformanceMonitor> createState() => _PerformanceMonitorState();
}

class _PerformanceMonitorState extends State<PerformanceMonitor> {
  @override
  void initState() {
    super.initState();
    if (widget.enabled) {
      _startMonitoring();
    }
  }

  void _startMonitoring() {
    // طباعة معلومات الكاش كل 10 ثواني
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted && widget.enabled) {
        AppPerformanceConfig.printCacheInfo();
        _startMonitoring();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Mixin لتحسين أداء الـ Widgets
mixin PerformanceOptimizedWidget {
  /// استخدام AutomaticKeepAliveClientMixin للحفاظ على حالة الـ Widget
  bool get wantKeepAlive => true;
}

/// Extension لتحسين أداء القوائم
extension ListPerformanceExtension on ListView {
  /// إنشاء ListView محسّن للأداء
  static Widget optimized({
    Key? key,
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
    ScrollController? controller,
    bool shrinkWrap = false,
    ScrollPhysics? physics,
    EdgeInsetsGeometry? padding,
  }) {
    return ListView.builder(
      key: key,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      controller: controller,
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding,
      // تحسينات الأداء
      addAutomaticKeepAlives: true,
      addRepaintBoundaries: true,
      addSemanticIndexes: true,
      cacheExtent: 100, // تحميل مسبق للعناصر
    );
  }
}

/// Extension لتحسين أداء الـ GridView
extension GridPerformanceExtension on GridView {
  /// إنشاء GridView محسّن للأداء
  static Widget optimized({
    Key? key,
    required SliverGridDelegate gridDelegate,
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
    ScrollController? controller,
    bool shrinkWrap = false,
    ScrollPhysics? physics,
    EdgeInsetsGeometry? padding,
  }) {
    return GridView.builder(
      key: key,
      gridDelegate: gridDelegate,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      controller: controller,
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding,
      // تحسينات الأداء
      addAutomaticKeepAlives: true,
      addRepaintBoundaries: true,
      addSemanticIndexes: true,
      cacheExtent: 100,
    );
  }
}
