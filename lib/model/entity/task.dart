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
  Map<DateTime, DurationValue> workload;
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

  factory Task.fromJson(Map<String, dynamic> json) {
    final Map<DateTime, DurationValue> workloadMap = {};
    final rawWorkload = json['workload'] ?? {};

    (rawWorkload as Map<String, dynamic>).forEach((key, value) {
      final date = DateTime.parse(key);
      final duration = DurationValue.fromNumber(
        value is num ? value.toDouble() : (value['minutes'] as num).toDouble(),
      );
      workloadMap[date] = duration;
    });

    return Task(
      taskId: json['taskId'],
      taskName: Name.fromString(json['taskName']),
      description: Description.fromString(json['description']),
      priority: json['priority'],
      type: TaskType.fromString(json['type']),
      deadline: DateTime.parse(json['deadline']),
      weight: json['weight'].toDouble(),
      createdAt: Timestamp.fromDate(
        DateTime.parse(json['createdAt'].toString()),
      ),
      updatedAt: Timestamp.fromDate(
        DateTime.parse(json['updatedAt'].toString()),
      ),
      workload: workloadMap,
      estimatedDuration: DurationValue.fromNumber(
        (json['estimatedDuration'] ?? 0).toDouble(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> workloadMap = {};
    workload.forEach((key, value) {
      workloadMap[key.toIso8601String()] = value.toNumber();
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
    workload.forEach((_, duration) {
      total += duration.toNumber();
    });
    return total;
  }

  void addWorkload(DateTime date, DurationValue duration) {
    workload[date] = duration;
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
          final dateStr = DateFormat('yyyy-MM-dd').format(entry.key);
          return '$dateStr: ${entry.value.toNumber()} hrs';
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
Workload:
$workloadStr
Total Workload: ${getTotalWorkload()} hrs
''';
  }
}
