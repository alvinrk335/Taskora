class Name {
  final String name;

  Name(this.name);

  factory Name.fromString(String str) {
    return Name(str);
  }

  @override
  String toString() {
    return name;
  }
}
