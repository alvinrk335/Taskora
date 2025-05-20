import 'package:taskora/model/value%20object/description.dart';
import 'package:taskora/model/value%20object/name.dart';
import 'package:taskora/model/value%20object/tasktype.dart';

class InitialTask {
  String taskId;
  Name taskName;
  Description description;
  int priority;
  TaskType type;
  DateTime? deadline;

  InitialTask(
    this.taskId,
    this.taskName,
    this.description,
    this.priority,
    this.type, {
    this.deadline,
  });

  /// Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'taskName': taskName.toString(),
      'description': description.toString(),
      'priority': priority,
      'taskType': type.toString(),
      'deadline': deadline?.toIso8601String(),
    };
  }

  factory InitialTask.empty() {
    return InitialTask(
      '', // taskId default
      Name(''), // Assuming Name has a constructor that takes a String
      Description(
        '',
      ), // Assuming Description has a constructor that takes a String
      1, // Default priority (e.g., LOW)
      TaskType.other, // Assuming TaskType has a constructor that takes a String
      deadline: null, // No deadline
    );
  }

  /// Deserialize from JSON
  factory InitialTask.fromJson(Map<String, dynamic> json) {
    return InitialTask(
      json['taskId'] as String,
      Name.fromString(json['taskName'] as String),
      Description.fromString(json['description'] as String),
      json['priority'] as int,
      TaskType.fromString(json['taskType'] as String),
      deadline:
          json['deadline'] != null
              ? DateTime.parse(json['deadline'] as String)
              : null,
    );
  }

  String priorityToString() {
    switch (priority) {
      case 1:
        return "LOW";
      case 2:
        return "MEDIUM";
      case 3:
        return "HIGH";
      default:
        return "priority must be either 1, 2 or 3";
    }
  }
}
