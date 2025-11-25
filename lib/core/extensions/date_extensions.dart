import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

extension DateTimeX on DateTime {
  /// Converts DateTime '2025-10-19 12:50:23.974974' to formatted date '19 Oct, 2025'
  String toFormattedDate() {
    return DateFormat('dd MMM, yyyy').format(this);
  }

  /// Converts DateTime to time ago format using timeago package
  /// Example: DateTime.now() => 'just now'
  /// Example: DateTime.now().subtract(Duration(hours: 2)) => '2 hours ago'
  String toTimeAgo({String? locale}) {
    return timeago.format(this, locale: locale);
  }

  /// Converts DateTime to time ago format with custom clock (useful for testing)
  String toTimeAgoWithClock(DateTime clock, {String? locale}) {
    return timeago.format(this, locale: locale, clock: clock);
  }
}