import 'dart:convert';

class Address {
  final String id;
  final String addressLine;
  final String city;
  final String state;
  final String pincode;
  Address({
    this.id = '',
    required this.addressLine,
    required this.city,
    required this.state,
    required this.pincode,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'addressLine': addressLine,
      'city': city,
      'state': state,
      'pincode': pincode,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['_id'],
      addressLine: map['addressLine'],
      city: map['city'],
      state: map['state'],
      pincode: map['pincode'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Address.fromJson(String source) =>
      Address.fromMap(json.decode(source));

  // Here added ["data"] because all the data about the address is in data key
  factory Address.fromJsonData(String source) =>
      Address.fromMap(json.decode(source)["data"]);

  @override
  String toString() {
    return '$addressLine,\n$city, $state-$pincode';
  }
}
