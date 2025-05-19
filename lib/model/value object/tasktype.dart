class TaskType {
  final String _value;

  const TaskType._(this._value);

  static const TaskType weekly = TaskType._("weekly");
  static const TaskType daily = TaskType._("daily");
  static const TaskType project = TaskType._("project");
  static const TaskType work = TaskType._("work");
  static const TaskType other = TaskType._("other");

  static const List<TaskType> values = [
    weekly,
    daily,
    project,
    work,
    other,
  ];

  static TaskType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'weekly':
        return weekly;
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
