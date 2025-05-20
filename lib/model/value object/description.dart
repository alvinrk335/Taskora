class Description {
  final String value;

  Description(this.value) {
    if (value.length > 500) {
      throw ArgumentError("Description is too long (max 500 characters)");
    }
  }

  factory Description.fromString(String desc) {
    return Description(desc);
  }
  bool get isNotEmpty => value.isNotEmpty;
  bool get isEmpty => value.isEmpty;
  
  @override
  String toString() {
    return value;
  }
}
