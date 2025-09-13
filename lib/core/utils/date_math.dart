class SdtDateMath {
  static DateTime dateOnlyLocal(DateTime d) => DateTime(d.year, d.month, d.day);
  static DateTime dateOnlyUtc(DateTime d) =>
      DateTime.utc(d.year, d.month, d.day);

  static DateTime clamp(DateTime d) {
    final firstDate = DateTime(1900);
    final lastDate = DateTime.now().add(const Duration(days: 365 * 100));
    if (d.isBefore(firstDate)) return firstDate;
    if (d.isAfter(lastDate)) return lastDate;
    return d;
  }

  // Calendar-day difference, DST-safe, matching inclusivity rules.
  static int daysBetweenToday(
    DateTime target, {
    bool includeToday = false, // include start date
    bool includeLastDay = true, // include end date
  }) {
    final a = dateOnlyUtc(DateTime.now());
    final b = dateOnlyUtc(target);
    final n = (b.difference(a).inDays).abs(); // pure calendar gap
    if (n == 0) return 0;

    // adj = -1 (exclusive both), 0 (include exactly one end), +1 (include both)
    final adj = (includeToday ? 1 : 0) + (includeLastDay ? 1 : 0) - 1;
    return n + adj;
  }

  static bool isFuture(DateTime target) {
    final a = dateOnlyLocal(DateTime.now());
    final b = dateOnlyLocal(target);
    return b.isAfter(a);
  }

  static DateTime addDaysFromToday(
    int days, {
    required bool future,
    bool includeToday = false, // include start date
    bool includeLastDay = true, // include end date
  }) {
    final base = dateOnlyLocal(DateTime.now()); // local midnight
    var x = days.abs();

    // Invert the same adjustment so the displayed value equals the entered X.
    // If adj = -1 (exclusive both) → need base gap n = X + 1
    // If adj = 0  (one end)        → n = X
    // If adj = +1 (both ends)      → n = X - 1 (but never below 0)
    final adj = (includeToday ? 1 : 0) + (includeLastDay ? 1 : 0) - 1;
    final delta = (x - adj).clamp(0, 1000000000);

    // Do calendar arithmetic to avoid DST hour shifts.
    final target = future
        ? DateTime(base.year, base.month, base.day + delta)
        : DateTime(base.year, base.month, base.day - delta);

    return clamp(target);
  }
}
