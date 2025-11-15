/// Utility class for checking if we're in the BijbelQuiz Gen period (December 31 - January 7)
class BijbelQuizGenPeriod {
  /// Check if the current date falls within the BijbelQuiz Gen period (December 31 - January 7)
  static bool isGenPeriod([DateTime? date]) {
    final now = date ?? DateTime.now();

    // Define the start and end of the Gen period
// December 31
// January 7 of next year

    // Handle year transition: if current date is after December 31 in the same year
    if (now.month == 12 && now.day >= 31) {
      return true;
    }

    // Handle year transition: if current date is before January 8 in the next year
    if (now.month == 1 && now.day <= 7) {
      return true;
    }

    return false;
  }

  /// Get the start date of the current Gen period
  static DateTime getGenStartDate([DateTime? date]) {
    final now = date ?? DateTime.now();
    final currentYear = now.month == 1 ? now.year - 1 : now.year;
    return DateTime(currentYear, 12, 31);
  }

  /// Get the end date of the current Gen period
  static DateTime getGenEndDate([DateTime? date]) {
    final now = date ?? DateTime.now();
    final currentYear = now.month == 1 ? now.year : now.year + 1;
    return DateTime(currentYear, 1, 7);
  }

  /// Get the year for which the stats are being calculated
  static int getStatsYear([DateTime? date]) {
    final now = date ?? DateTime.now();
    // Stats are for the previous year if we're in January
    return now.month == 1 ? now.year - 1 : now.year;
  }
}
