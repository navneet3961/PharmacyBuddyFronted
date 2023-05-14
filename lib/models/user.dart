import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final String password;
  // final List<Address> address = [];
  final bool isBlocked;
  final bool isAdmin;
  // final String token;
  User({
    this.id = '',
    required this.name,
    required this.email,
    required this.password,
    this.isBlocked = false,
    this.isAdmin = false,
    // this.token = "",
  });

  User.empty({
    this.id = '',
    this.name = '',
    this.email = '',
    this.password = '',
    this.isBlocked = true,
    this.isAdmin = false,
    // this.token = "",
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      // 'address': address,
      'isBlocked': isBlocked,
      'isAdmin': isAdmin,
      // 'token': token,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      isBlocked: map['isBlocked'],
      isAdmin: map['isAdmin'],
      // token: map['token'],
    );
  }

  String toJson() => json.encode(toMap());

// Here added ["data"] because all the data about the user is in data key
  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source)["data"]);

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, password: $password, isBlocked: $isBlocked, isAdmin: $isAdmin)';
  }
}
