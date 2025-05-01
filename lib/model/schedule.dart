import 'package:cloud_firestore/cloud_firestore.dart';
import 'task.dart'; // Pastikan file ini berisi class Task yang sudah kita buat sebelumnya

class Schedule {
  String scheduleId;
  List<Task> tasks;
  Timestamp? scheduleStart;
  Timestamp? scheduleEnd;

  Schedule({
    required this.scheduleId,
    required this.tasks,
    this.scheduleStart,
    this.scheduleEnd,
  });

  factory Schedule.empty() {
    return Schedule(
      scheduleId: '',
      tasks: [],
      scheduleStart: null,
      scheduleEnd: null,
    );
  }
  bool isEmpty() {
    return scheduleId.isEmpty && tasks.isEmpty;
  }

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      scheduleId: json['scheduleId'],
      tasks: (json['tasks'] as List).map((e) => Task.fromJson(e)).toList(),
      scheduleStart:
          json['scheduleStart'] != null
              ? Timestamp.fromDate(DateTime.parse(json['scheduleStart']))
              : null,
      scheduleEnd:
          json['scheduleEnd'] != null
              ? Timestamp.fromDate(DateTime.parse(json['scheduleEnd']))
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scheduleId': scheduleId,
      'tasks': tasks.map((task) => task.toJson()).toList(),
      'scheduleStart': scheduleStart?.toDate().toIso8601String() ?? '',
      'scheduleEnd': scheduleEnd?.toDate().toIso8601String() ?? '',
    };
  }

  // Getter and Setter for scheduleId
  String get getScheduleId => scheduleId;

  set setScheduleId(String scheduleId) {
    this.scheduleId = scheduleId;
  }

  // Getter and Setter for tasks
  List<Task> get getTasks => tasks;

  set setTasks(List<Task> tasks) {
    this.tasks = tasks;
  }

  // Getter and Setter for scheduleStart
  Timestamp? get getScheduleStart => scheduleStart;
  set setScheduleStart(Timestamp? scheduleStart) {
    this.scheduleStart = scheduleStart;
  }

  // Getter and Setter for scheduleEnd
  Timestamp? get getScheduleEnd => scheduleEnd;
  set setScheduleEnd(Timestamp? scheduleEnd) {
    this.scheduleEnd = scheduleEnd;
  }
}
