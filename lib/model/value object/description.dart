class Description {
  final String value;

  Description(this.value) {
<<<<<<< HEAD
<<<<<<< HEAD
=======
    if (value.trim().isEmpty) {
      throw ArgumentError("Description cannot be empty or blank");
    }
>>>>>>> 19e03416083a52dbc55c65818d121799ce284671
=======
>>>>>>> master
    if (value.length > 500) {
      throw ArgumentError("Description is too long (max 500 characters)");
    }
  }

  factory Description.fromString(String desc) {
    return Description(desc);
  }
<<<<<<< HEAD

=======
  bool get isNotEmpty => value.isNotEmpty;
  bool get isEmpty => value.isEmpty;
  
>>>>>>> master
  @override
  String toString() {
    return value;
  }
}
