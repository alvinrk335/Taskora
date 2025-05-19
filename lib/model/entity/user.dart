class User {
  final String uid;
  final String username;
  final String email;
  final String profilePicture;

  const User({
    required this.uid,
    required this.username,
    this.email = '',
    this.profilePicture = '',
  });

  static const empty = User(
    uid: '',
    username: '',
    email: '',
    profilePicture: '',
  );

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'profilePicture': profilePicture,
    };
  }

  User copyWith({
    String? uid,
    String? username,
    String? email,
    String? profilePicture,
  }) {
    return User(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }
}
