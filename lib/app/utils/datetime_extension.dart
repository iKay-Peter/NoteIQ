extension DateTimeExtension on DateTime {
  bool get isOverdue {
    final now = DateTime.now();
    return isBefore(DateTime(now.year, now.month, now.day));
  }

  bool get isDueToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
}