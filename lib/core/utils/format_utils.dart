import 'package:intl/intl.dart';

class FormatUtils {
  FormatUtils._();

  /// Format currency with Indonesian Rupiah style
  static String currency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  /// Format date as "24 Apr 2026"
  static String date(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  /// Format date as "Apr 2026"
  static String monthYear(DateTime date) {
    return DateFormat('MMM yyyy').format(date);
  }

  /// Format date as "24 Apr 2026, 14:30"
  static String dateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }

  /// Relative date (e.g., "2 days ago", "Today")
  static String relativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else {
      return DateFormat('dd MMM yyyy').format(date);
    }
  }
}
