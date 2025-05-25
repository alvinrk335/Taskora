class TaskType {
  final String _value;

  const TaskType._(this._value);

  static const TaskType assignment = TaskType._("assignment");
  static const TaskType daily = TaskType._("daily");
  static const TaskType project = TaskType._("project");
  static const TaskType work = TaskType._("work");
  static const TaskType other = TaskType._("other");

  static const List<TaskType> values = [
    assignment,
    daily,
    project,
    work,
    other,
  ];

  static TaskType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'assignment':
        return assignment;
      case 'daily':
        return daily;
      case 'project':
        return project;
      case 'work':
        return work;
      case 'other':
        return other;
      default:
        throw ArgumentError('Invalid TaskType: $value');
    }
  }

  @override
  String toString() => _value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskType && runtimeType == other.runtimeType && _value == other._value;

  @override
  int get hashCode => _value.hashCode;
}
