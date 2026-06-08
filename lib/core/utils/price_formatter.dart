import 'package:intl/intl.dart';

/// Helper class for formatting prices with different display options
class PriceFormatter {
  /// Formats a price with thousands separators
  /// Example: 1234567.89 -> "1,234,567.89" (for 'en') or "١٬٢٣٤٬٥٦٧٫٨٩" (for 'ar')
  static String formatWithSeparators(String price, {String locale = 'ar'}) {
    try {
      final numPrice = double.parse(price);
      final formatter = NumberFormat('#,###.##', locale);
      return formatter.format(numPrice);
    } catch (e) {
      return price;
    }
  }

  /// Formats a price in a compact/abbreviated way for display in cards
  /// Example: 1000000 -> "1.0 مليون", 50000 -> "50 ألف", 500 -> "500"
  static String formatCompact(String price, {bool showDecimals = true}) {
    try {
      final numPrice = double.parse(price);

      if (numPrice >= 1000000000) {
        // Billions
        final billions = numPrice / 1000000000;
        return showDecimals
            ? '${billions.toStringAsFixed(1)} مليار'
            : '${billions.toStringAsFixed(0)} مليار';
      } else if (numPrice >= 1000000) {
        // Millions
        final millions = numPrice / 1000000;
        return showDecimals
            ? '${millions.toStringAsFixed(1)} مليون'
            : '${millions.toStringAsFixed(0)} مليون';
      } else if (numPrice >= 1000) {
        // Thousands
        final thousands = numPrice / 1000;
        return showDecimals
            ? '${thousands.toStringAsFixed(1)} ألف'
            : '${thousands.toStringAsFixed(0)} ألف';
      }

      // Less than 1000
      return numPrice.toStringAsFixed(0);
    } catch (e) {
      return price;
    }
  }

  /// Formats a price with currency symbol
  /// Example: "1000000", "$" -> "$1,000,000" or "1,000,000 $" based on position
  static String formatWithCurrency(
    String price,
    String currencySymbol, {
    String locale = 'ar',
    String position = 'after', // 'before' or 'after'
    bool compact = false,
  }) {
    try {
      final formattedPrice = compact
          ? formatCompact(price)
          : formatWithSeparators(price, locale: locale);

      // Position the currency symbol
      if (position == 'before') {
        return '$currencySymbol$formattedPrice';
      } else {
        return '$formattedPrice $currencySymbol';
      }
    } catch (e) {
      return '$price $currencySymbol';
    }
  }

  /// Formats price with full currency information
  /// Returns formatted price with symbol, or just the price if currency is null
  static String formatPriceWithCurrency({
    required String price,
    String? currencySymbol,
    String? currencyCode,
    String position = 'after',
    String locale = 'ar',
    bool compact = false,
    String defaultCurrency = 'ريال',
  }) {
    final symbol = currencySymbol ?? defaultCurrency;
    return formatWithCurrency(
      price,
      symbol,
      locale: locale,
      position: position,
      compact: compact,
    );
  }

  /// Removes trailing zeros from decimal numbers
  /// Example: "1000.00" -> "1000", "1000.50" -> "1000.5"
  static String removeTrailingZeros(String number) {
    try {
      final numValue = double.parse(number);
      if (numValue == numValue.toInt()) {
        return numValue.toInt().toString();
      }
      return numValue
          .toString()
          .replaceAll(RegExp(r'0*$'), '')
          .replaceAll(RegExp(r'\.$'), '');
    } catch (e) {
      return number;
    }
  }
}
