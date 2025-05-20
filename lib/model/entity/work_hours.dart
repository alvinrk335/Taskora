class WorkHours {
  final Map<String, double> weeklyWorkHours;

  const WorkHours({required this.weeklyWorkHours});

  /// Membuat instance kosong dengan semua hari = 0 jam
  factory WorkHours.empty() {
    return WorkHours(
      weeklyWorkHours: {
        'Monday': 0,
        'Tuesday': 0,
        'Wednesday': 0,
        'Thursday': 0,
        'Friday': 0,
        'Saturday': 0,
        'Sunday': 0,
      },
    );
  }

  /// Membuat instance dari JSON
  factory WorkHours.fromJson(Map<String, dynamic> json) {
    final Map<String, double> parsed = {};
    for (final entry in json.entries) {
      parsed[entry.key] = (entry.value as num).toDouble();
    }
    return WorkHours(weeklyWorkHours: parsed);
  }

  /// Mengubah ke JSON
  Map<String, dynamic> toJson() {
    return weeklyWorkHours;
  }

  factory WorkHours.fromMap(Map<String, double> map) {
    return WorkHours(weeklyWorkHours: Map<String, double>.from(map));
  }

  /// Update jam kerja untuk hari tertentu
  WorkHours update(String dayName, double newHours) {
    final updated = Map<String, double>.from(weeklyWorkHours)
      ..[dayName] = newHours;
    return WorkHours(weeklyWorkHours: updated);
  }

  Map<String, double> toMap() {
    return Map<String, double>.from(weeklyWorkHours);
  }

  /// Mengambil jam kerja untuk hari tertentu
  double getHours(String dayName) {
    return weeklyWorkHours[dayName] ?? 0;
  }

  @override
  String toString() {
    return weeklyWorkHours.entries
        .map((e) => '${e.key}: ${e.value}h')
        .join(', ');
  }
}
