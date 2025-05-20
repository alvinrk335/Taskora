class Description {
  final String value;

  Description(this.value) {
<<<<<<< HEAD
=======
    if (value.trim().isEmpty) {
      throw ArgumentError("Description cannot be empty or blank");
    }
>>>>>>> 19e03416083a52dbc55c65818d121799ce284671
    if (value.length > 500) {
      throw ArgumentError("Description is too long (max 500 characters)");
    }
  }

  factory Description.fromString(String desc) {
    return Description(desc);
  }

  @override
  String toString() {
    return value;
  }
}
