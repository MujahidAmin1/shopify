class User {
  String username;
  String email;
  String id;
  String? profilePic;
  String address;
  User(
      {required this.email,
      required this.username,
      required this.id,
      required this.address,
      this.profilePic,
      });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'id': id,
      'profilePic': profilePic,
      'address': address,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      id: map['id'] ?? '',
      profilePic: map['profilePic'] ?? '',
      address: map['address'] ?? '',
    );
  }
}
