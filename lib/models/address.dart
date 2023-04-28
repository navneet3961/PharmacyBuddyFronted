import 'dart:convert';

class Address {
  final String addressLine;
  final String city;
  final String state;
  final String pincode;
  Address({
    required this.addressLine,
    required this.city,
    required this.state,
    required this.pincode,
  });

  Map<String, dynamic> toMap() {
    return {
      'addressLine': addressLine,
      'city': city,
      'state': state,
      'pincode': pincode,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      addressLine: map['addressLine'],
      city: map['city'],
      state: map['state'],
      pincode: map['pincode'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Address.fromJson(String source) =>
      Address.fromMap(json.decode(source));
}
