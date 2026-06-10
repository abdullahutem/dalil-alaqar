import 'package:flutter/foundation.dart';

/// Application-wide logger utility
/// Uses Flutter's debugPrint in debug mode, no-op in release mode
class AppLogger {
  static const String _prefix = '🏠 Dalil Alaqar';

  /// Log info message
  static void info(String message, [String? tag]) {
    _log('ℹ️', message, tag);
  }

  /// Log success message
  static void success(String message, [String? tag]) {
    _log('✅', message, tag);
  }

  /// Log warning message
  static void warning(String message, [String? tag]) {
    _log('⚠️', message, tag);
  }

  /// Log error message
  static void error(
    String message, [
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  ]) {
    _log('❌', message, tag);
    if (error != null) {
      _log('❌', 'Error: $error', tag);
    }
    if (stackTrace != null) {
      _log('❌', 'Stack trace: $stackTrace', tag);
    }
  }

  /// Log database operation
  static void database(String message, [String? tag]) {
    _log('💾', message, tag);
  }

  /// Log network operation
  static void network(String message, [String? tag]) {
    _log('🌐', message, tag);
  }

  /// Log cache operation
  static void cache(String message, [String? tag]) {
    _log('📦', message, tag);
  }

  static void _log(String emoji, String message, String? tag) {
    if (kDebugMode) {
      final tagPart = tag != null ? '[$tag] ' : '';
      debugPrint('$_prefix $emoji $tagPart$message');
    }
  }
}
