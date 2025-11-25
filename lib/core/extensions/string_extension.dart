import 'package:intl/intl.dart';

extension StringX on String {
  /// Converts string date '2025-10-24' to formatted date '24 Oct, 2025'
  String toFormattedDate() {
    try {
      final date = DateTime.parse(this);
      return DateFormat('dd MMM, yyyy').format(date);
    } catch (e) {
      return this;
    }
  }

  String toYear() {
    try {
      final date = DateTime.parse(this);
      return date.year.toString();
    } catch (e) {
      return this;
    }
  }

  String toLiveCountdown() {
    try {
      final targetDate = DateTime.parse(this);
      final now = DateTime.now();
      final difference = targetDate.difference(now);

      // If episode is released (past date)
      if (difference.isNegative) {
        final sinceDifference = now.difference(targetDate);

        if (sinceDifference.inDays >= 365) {
          return '${(sinceDifference.inDays / 365).floor()}y ago';
        } else if (sinceDifference.inDays >= 30) {
          return '${(sinceDifference.inDays / 30).floor()}mo ago';
        } else if (sinceDifference.inDays >= 7) {
          return '${(sinceDifference.inDays / 7).floor()}w ago';
        } else if (sinceDifference.inDays > 0) {
          return '${sinceDifference.inDays}d ago';
        } else if (sinceDifference.inHours > 0) {
          return '${sinceDifference.inHours}h ago';
        } else {
          return 'Just released';
        }
      }

      // Future date - countdown logic
      final years = difference.inDays ~/ 365;
      final months = (difference.inDays % 365) ~/ 30;
      final days = (difference.inDays % 30);
      final hours = difference.inHours % 24;
      final minutes = difference.inMinutes % 60;
      final seconds = difference.inSeconds % 60;

      if (years > 0) {
        return '${years}y ${months}mo ${days}d';
      } else if (months > 0) {
        return '${months}mo ${days}d ${hours}h';
      } else if (days > 0) {
        return '${days}d ${hours}h ${minutes}m';
      } else if (hours > 0) {
        return '${hours}h ${minutes}m ${seconds}s';
      } else if (minutes > 0) {
        return '${minutes}m ${seconds}s';
      } else if (seconds > 0) {
        return '${seconds}s';
      } else {
        return 'Releasing now';
      }
    } catch (e) {
      return this;
    }
  }

  bool isFutureDate() {
    try {
      final targetDate = DateTime.parse(this);
      return targetDate.isAfter(DateTime.now());
    } catch (e) {
      return false;
    }
  }
}
