class TimeHelper {
  /// Calculate time ago from DateTime
  static String getTimeAgo(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '${years}y ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  /// Convert duration string (00:01:23) to reading time format (21m read)
  static String getReadingTime(String? duration) {
    if (duration == null || duration.isEmpty) return '';

    try {
      // Parse duration format: 00:01:23 (HH:MM:SS)
      final parts = duration.split(':');
      if (parts.length != 3) return '';

      final hours = int.tryParse(parts[0]) ?? 0;
      final minutes = int.tryParse(parts[1]) ?? 0;
      final seconds = int.tryParse(parts[2]) ?? 0;

      // Calculate total minutes (rounded up)
      int totalMinutes = hours * 60 + minutes;
      if (seconds > 0) totalMinutes++; // Round up if there are seconds

      if (totalMinutes < 1) return '1m read';

      return '${totalMinutes}m read';
    } catch (e) {
      return '';
    }
  }
}