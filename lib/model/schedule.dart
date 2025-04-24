import 'package:cloud_firestore/cloud_firestore.dart';
import 'task.dart'; // Pastikan file ini berisi class Task yang sudah kita buat sebelumnya

class Schedule {
  final String scheduleId;
  List<Task> tasks;
  Timestamp scheduleStart;
  Timestamp scheduleEnd;

  Schedule({
    required this.scheduleId,
    required this.tasks,
    required this.scheduleStart,
    required this.scheduleEnd,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      scheduleId: json['scheduleId'],
      tasks: (json['tasks'] as List).map((e) => Task.fromJson(e)).toList(),
      scheduleStart: Timestamp.fromDate(DateTime.parse(json['scheduleStart'])),
      scheduleEnd: Timestamp.fromDate(DateTime.parse(json['scheduleEnd'])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scheduleId': scheduleId,
      'tasks': tasks.map((task) => task.toJson()).toList(),
      'scheduleStart': scheduleStart.toDate().toIso8601String(),
      'scheduleEnd': scheduleEnd.toDate().toIso8601String(),
    };
  }

  // Getter-Setter jika perlu (opsional karena Dart mendukung akses langsung ke field)

  String get getScheduleId => scheduleId;
  List<Task> get getTasks => tasks;
  Timestamp get getScheduleStart => scheduleStart;
  Timestamp get getScheduleEnd => scheduleEnd;

  void setTasksList(List<Task> updatedTasks) {
    tasks = updatedTasks;
  }

  void setScheduleStart(Timestamp start) {
    scheduleStart = start;
  }

  void setScheduleEnd(Timestamp end) {
    scheduleEnd = end;
  }
}
