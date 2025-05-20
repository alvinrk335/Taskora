class CardType {
  final String value;
  const CardType._({required this.value});

  static const CardType regular = CardType._(value: "regular");
  static const CardType button = CardType._(value: "button");

  @override
  String toString() => value;

  static CardType fromString(String value) {
    switch (value) {
      case 'regular':
        return CardType.regular;
      case 'button':
        return CardType.button;
      default:
        throw ArgumentError('Unknown CardType: $value');
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is CardType && other.value == value);

  @override
  int get hashCode => value.hashCode;
}
