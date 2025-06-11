import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:taskora/model/value%20object/description.dart';
import 'package:taskora/model/value%20object/duration.dart';
import 'package:taskora/model/value%20object/name.dart';
import 'package:taskora/model/value%20object/tasktype.dart';

class Task {
  final String taskId;
  Name taskName;
  Description description;
  int priority;
  TaskType type;
  DateTime? deadline;
  double weight;
  Timestamp createdAt;
  Timestamp updatedAt;
  Map<String, List<Map<String, dynamic>>>
  workload; // date string -> list of {interval, workload}
  DurationValue? estimatedDuration;

  Task({
    required this.taskId,
    required this.taskName,
    required this.description,
    required this.priority,
    required this.type,
    required this.deadline,
    required this.weight,
    required this.createdAt,
    required this.updatedAt,
    required this.workload,
    this.estimatedDuration,
  });

  Task copyWith({
    String? taskId,
    Name? taskName,
    Description? description,
    int? priority,
    TaskType? type,
    DateTime? deadline,
    double? weight,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    Map<String, List<Map<String, dynamic>>>? workload,
    DurationValue? estimatedDuration,
  }) {
    return Task(
      taskId: taskId ?? this.taskId,
      taskName: taskName ?? this.taskName,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      updatedAt: updatedAt ?? this.updatedAt,
      weight: weight ?? this.weight,
      workload: workload ?? this.workload,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    final rawWorkload = json['workload'] ?? {};
    final Map<String, List<Map<String, dynamic>>> parsedWorkload = {};
    rawWorkload.forEach((date, intervals) {
      if (intervals is List) {
        parsedWorkload[date] = List<Map<String, dynamic>>.from(
          intervals.map(
            (iw) => {
              'interval': List<String>.from(iw['interval']),
              'workload': iw['workload'],
            },
          ),
        );
      }
    });
    final deadlineJson = json['deadline'];
    DateTime? deadline;
    if (deadlineJson != null && deadlineJson != "No deadline") {
      deadline = DateTime.tryParse(deadlineJson);
    } else {
      deadline = null;
    }
    return Task(
      taskId: json['taskId'],
      taskName: Name.fromString(json['taskName']),
      description: Description.fromString(json['description']),
      priority: json['priority'],
      type: TaskType.fromString(json['type']),
      deadline: deadline,
      weight: (json['weight'] as num).toDouble(),
      createdAt: Timestamp.fromDate(
        DateTime.parse(json['createdAt'].toString()),
      ),
      updatedAt: Timestamp.fromDate(
        DateTime.parse(json['updatedAt'].toString()),
      ),
      workload: parsedWorkload,
      estimatedDuration: DurationValue.fromNumber(
        (json['estimatedDuration'] ?? 0).toDouble(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> workloadMap = {};
    workload.forEach((date, intervals) {
      workloadMap[date] =
          intervals
              .map(
                (iw) => {
                  'interval': iw['interval'],
                  'workload': iw['workload'],
                },
              )
              .toList();
    });
    return {
      'taskId': taskId,
      'taskName': taskName.toString(),
      'description': description.toString(),
      'priority': priority,
      'type': type.toString(),
      'deadline': deadline?.toIso8601String() ?? "No deadline",
      'estimatedDuration': estimatedDuration?.toNumber() ?? 0,
      'weight': weight,
      'createdAt': createdAt.toDate().toIso8601String(),
      'updatedAt': updatedAt.toDate().toIso8601String(),
      'workload': workloadMap,
    };
  }

  double getTotalWorkload() {
    double total = 0;
    workload.forEach((_, intervals) {
      for (final iw in intervals) {
        total += (iw['workload'] as num).toDouble();
      }
    });
    return total;
  }

  void addWorkload(String date, List<Map<String, dynamic>> intervals) {
    workload[date] = intervals;
  }

  String toShortSummaryStringS() {
    final deadlineStr =
        deadline != null
            ? DateFormat('yyyy-MM-dd').format(deadline!)
            : 'No deadline';
    // final workloadStr = workload.entries
    //     .map((e) {
    //       final dateStr = DateFormat('yyyy-MM-dd').format(e.key);
    //       return '$dateStr: ${e.value}';
    //     })
    //     .join(', ');

    return '''
    Deadline: $deadlineStr
    Description: ${description.value}
    Type: ${type.toString().split('.').last}
    Priority: $priority
          ''';
  }

  String toSummaryString() {
    final deadlineStr =
        deadline != null
            ? DateFormat('yyyy-MM-dd').format(deadline!)
            : 'No deadline';

    final estDurationStr =
        estimatedDuration != null
            ? '${estimatedDuration!.toNumber()} mins'
            : 'Unknown';

    final workloadStr = workload.entries
        .map((entry) {
          final dateStr = entry.key;
          final intervals = entry.value;
          final intervalsStr = intervals
              .map(
                (iw) =>
                    '[${iw['interval'][0]}-${iw['interval'][1]}: ${iw['workload']} hrs]',
              )
              .join(', ');
          return '$dateStr: $intervalsStr';
        })
        .join('\n');

    return '''
ID: $taskId
Name: ${taskName.toString()}
Description: ${description.value}
Type: ${type.toString().split('.').last}
Priority: $priority
Deadline: $deadlineStr
Estimated Duration: $estDurationStr
Weight: $weight
Created At: ${createdAt.toDate().toIso8601String()}
Updated At: ${updatedAt.toDate().toIso8601String()}
Workload:\n$workloadStr\nTotal Workload: ${getTotalWorkload()} hrs
''';
  }

  // Checks if a workload duration can fit within the provided intervals for a given date
  static bool isWorkloadWithinIntervals(
    DateTime date,
    DurationValue duration,
    List<Map<String, String>> intervals,
  ) {
    if (intervals.isEmpty) return false;
    final totalAvailableMinutes = intervals.fold<int>(0, (sum, interval) {
      final startParts = interval['start']!.split(":");
      final endParts = interval['end']!.split(":");
      final start = DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(startParts[0]),
        int.parse(startParts[1]),
      );
      final end = DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(endParts[0]),
        int.parse(endParts[1]),
      );
      return sum + end.difference(start).inMinutes;
    });
    return duration.toNumber() * 60 <= totalAvailableMinutes;
  }

  // Optionally, filter workload map to only include dates that fit intervals
  static Map<DateTime, DurationValue> filterWorkloadByIntervals(
    Map<DateTime, DurationValue> workload,
    Map<String, List<Map<String, String>>> weeklyIntervals,
  ) {
    final filtered = <DateTime, DurationValue>{};
    workload.forEach((date, duration) {
      final weekday =
          [
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday",
            "Sunday",
          ][date.weekday - 1];
      final intervals = weeklyIntervals[weekday] ?? [];
      if (isWorkloadWithinIntervals(date, duration, intervals)) {
        filtered[date] = duration;
      }
    });
    return filtered;
  }
}
