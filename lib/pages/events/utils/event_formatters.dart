import 'package:intl/intl.dart';

/// Utility functions for safe formatting and edge-case handling across the Events module.
class EventFormatters {
  /// Validates whether a string is a well-formed HTTP/HTTPS image URL
  static bool isValidImageUrl(String? url) {
    if (url == null || url.trim().isEmpty) return false;
    final trimmed = url.trim().toLowerCase();
    if (!trimmed.startsWith('http://') && !trimmed.startsWith('https://')) {
      return false;
    }
    final uri = Uri.tryParse(url.trim());
    return uri != null && uri.hasAuthority;
  }

  /// Formats large numbers compactly: 950 -> "950", 1200 -> "1.2k", 25000 -> "25k", 1000000 -> "1M"
  static String formatCount(int count) {
    if (count <= 0) return '0';
    if (count < 1000) return '$count';
    if (count < 10000) {
      final formatted = (count / 1000).toStringAsFixed(1);
      return formatted.endsWith('.0') ? '${formatted.substring(0, formatted.length - 2)}k' : '${formatted}k';
    }
    if (count < 1000000) {
      return '${(count / 1000).round()}k';
    }
    final formatted = (count / 1000000).toStringAsFixed(1);
    return formatted.endsWith('.0') ? '${formatted.substring(0, formatted.length - 2)}M' : '${formatted}M';
  }

  static final DateFormat _dateFormat = DateFormat('dd MMM');
  static final DateFormat _timeFormat = DateFormat('h:mm a');
  static final DateFormat _fullDateFormat = DateFormat('dd MMM, h:mm a');

  /// Formats single-day or multi-day event date & time ranges accurately
  static String formatDateTimeRange(DateTime start, DateTime end) {
    // If on same calendar day: "27 Aug, 8:00 PM - 10:00 PM"
    if (start.year == end.year && start.month == end.month && start.day == end.day) {
      return '${_dateFormat.format(start)}, ${_timeFormat.format(start)} - ${_timeFormat.format(end)}';
    }

    // If multi-day or overnight: "27 Aug, 8:00 PM - 28 Aug, 2:00 AM"
    return '${_dateFormat.format(start)}, ${_timeFormat.format(start)} - ${_dateFormat.format(end)}, ${_timeFormat.format(end)}';
  }

  /// Formats date for large card: "27 Aug, 8:00 PM - 10:00 PM"
  static String formatLargeCardDate(DateTime start, DateTime end) {
    if (start.year == end.year && start.month == end.month && start.day == end.day) {
      return '${_fullDateFormat.format(start)} - ${_timeFormat.format(end)}';
    }
    return '${_fullDateFormat.format(start)} - ${_fullDateFormat.format(end)}';
  }

  /// Sanitizes title / text with fallback
  static String sanitizeText(String? text, {String fallback = 'Untitled Event'}) {
    if (text == null || text.trim().isEmpty) return fallback;
    return text.trim();
  }

  /// Sanitizes venue with fallback
  static String sanitizeVenue(String? venue) {
    if (venue == null || venue.trim().isEmpty) return 'Campus';
    return venue.trim();
  }

  /// Sanitizes organizer / club with fallback
  static String sanitizeClub(String? club) {
    if (club == null || club.trim().isEmpty) return 'Club Organizer';
    return club.trim();
  }
}
