class SummaryType {
  final String value;
  const SummaryType._({required this.value});

  static const SummaryType compact = SummaryType._(value: "compact");
  static const SummaryType full = SummaryType._(value: "full");

  /// Convert SummaryType to string
  @override
  String toString() => value;

  /// Convert string to SummaryType
  static SummaryType fromString(String value) {
    switch (value) {
      case 'compact':
        return SummaryType.compact;
      case 'full':
        return SummaryType.full;
      default:
        throw ArgumentError('Unknown SummaryType: $value');
    }
  }

  /// Equality override
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is SummaryType && other.value == value);

  @override
  int get hashCode => value.hashCode;
}
