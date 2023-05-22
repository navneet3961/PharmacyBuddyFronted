import 'dart:convert';

import 'package:pharmacy_buddy/models/address.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String cart;
  final List<dynamic> orders;
  final List<Address> addresses;
  final bool isBlocked;
  final bool isAdmin;

  User({
    this.id = '',
    required this.name,
    required this.email,
    required this.password,
    this.cart = '',
    this.orders = const [],
    this.addresses = const [],
    this.isBlocked = false,
    this.isAdmin = false,
  });

  User.empty({
    this.id = '',
    this.name = '',
    this.email = '',
    this.password = '',
    this.cart = '',
    this.orders = const [],
    this.addresses = const [],
    this.isBlocked = true,
    this.isAdmin = false,
  });

  User.signUp({
    this.id = '',
    required this.name,
    required this.email,
    required this.password,
    this.cart = '',
    this.orders = const [],
    this.addresses = const [],
    this.isBlocked = false,
    this.isAdmin = false,
  });

  User.signIn({
    this.id = '',
    this.name = '',
    required this.email,
    required this.password,
    this.cart = '',
    this.orders = const [],
    this.addresses = const [],
    this.isBlocked = false,
    this.isAdmin = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'orders': orders,
      'cart': cart,
      'addresses': addresses,
      'isBlocked': isBlocked,
      'isAdmin': isAdmin,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    List<Address> list = [];
    for (int i = 0; i < map['addresses'].length; i++) {
      list.add(Address.fromJson(jsonEncode(map['addresses'][i])));
    }

    return User(
      id: map['_id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      orders: map['orders'],
      cart: map['cart'],
      addresses: list,
      isBlocked: map['isBlocked'],
      isAdmin: map['isAdmin'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source)["data"]);

  // Here added ["data"] because all the data about the user is in data key
  factory User.fromJsonData(String source) =>
      User.fromMap(json.decode(source)["data"]);

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, password: $password, cart: $cart, orders: $orders, addresses: $addresses, isBlocked: $isBlocked, isAdmin: $isAdmin)';
  }
}
