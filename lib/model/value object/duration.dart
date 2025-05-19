class DurationValue {
  final int minutes;

  DurationValue(this.minutes) {
    if (minutes < 0) {
      throw ArgumentError("Duration must be a non-negative integer.");
    }
  }

  factory DurationValue.fromNumber(double num) {
    return DurationValue(num.toInt());
  }

  factory DurationValue.fromHours(double hours) {
    return DurationValue((hours * 60).round());
  }

  factory DurationValue.fromMinutes(int minutes) {
    return DurationValue(minutes);
  }

  int getInMinutes() => minutes;

  double getInHours() => minutes / 60;

  String toFormattedString() {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours > 0 && mins > 0) return '${hours}h ${mins}m';
    if (hours > 0) return '${hours}h';
    return '$mins hrs';
  }

  bool equals(DurationValue other) {
    return minutes == other.minutes;
  }

  int toNumber() => minutes;

  @override
  String toString() => toFormattedString();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DurationValue && runtimeType == other.runtimeType && minutes == other.minutes;

  @override
  int get hashCode => minutes.hashCode;
}
