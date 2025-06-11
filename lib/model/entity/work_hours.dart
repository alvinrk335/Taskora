class WorkHours {
  final Map<String, List<Map<String, String>>> weeklyWorkIntervals;

  const WorkHours({required this.weeklyWorkIntervals});

  /// Membuat instance kosong dengan semua hari = []
  factory WorkHours.empty() {
    return WorkHours(
      weeklyWorkIntervals: {
        'Monday': [],
        'Tuesday': [],
        'Wednesday': [],
        'Thursday': [],
        'Friday': [],
        'Saturday': [],
        'Sunday': [],
      },
    );
  }

  /// Membuat instance dari JSON
  factory WorkHours.fromJson(Map<String, dynamic> json) {
    final Map<String, List<Map<String, String>>> parsed = {};
    for (final entry in json.entries) {
      parsed[entry.key] =
          (entry.value as List)
              .map(
                (interval) => {
                  'start': interval['start'] as String,
                  'end': interval['end'] as String,
                },
              )
              .toList();
    }
    return WorkHours(weeklyWorkIntervals: parsed);
  }

  /// Mengubah ke JSON
  Map<String, dynamic> toJson() {
    return weeklyWorkIntervals;
  }

  factory WorkHours.fromMap(Map<String, List<Map<String, String>>> map) {
    return WorkHours(
      weeklyWorkIntervals: Map<String, List<Map<String, String>>>.from(map),
    );
  }

  /// Update interval untuk hari tertentu
  WorkHours update(String dayName, List<Map<String, String>> newIntervals) {
    final updated = Map<String, List<Map<String, String>>>.from(
      weeklyWorkIntervals,
    )..[dayName] = newIntervals;
    return WorkHours(weeklyWorkIntervals: updated);
  }

  List<Map<String, String>> getIntervals(String dayName) {
    return weeklyWorkIntervals[dayName] ?? [];
  }

  @override
  String toString() {
    return weeklyWorkIntervals.entries
        .map(
          (e) =>
              '${e.key}: ${e.value.map((i) => '${i['start']}-${i['end']}').join(', ')}',
        )
        .join('; ');
  }
}
