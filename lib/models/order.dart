import 'dart:convert';

import 'package:pharmacy_buddy/models/item.dart';

class Order {
  final String id;
  final List<Item> items;
  final double totalCost;
  final String address;
  final String phone;
  final String status;
  final int deliveredDate;

  Order({
    this.id = '',
    required this.items,
    required this.totalCost,
    required this.address,
    required this.phone,
    this.status = 'CONFIRMED',
    this.deliveredDate = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': items,
      'totalCost': totalCost,
      'address': address,
      'phone': phone,
      'status': status,
      'deliveredDate': deliveredDate,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    List<Item> list = [];
    for (int i = 0; i < map['items'].length; i++) {
      list.add(Item.fromJson(jsonEncode(map['items'][i])));
    }

    return Order(
      id: map['_id'],
      items: list,
      totalCost: map['totalCost'],
      address: map['address'],
      phone: map['phone'],
      status: map['status'],
      deliveredDate: map['deliveredDate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));

  // Here added ["data"] because all the data about the order is in data key
  factory Order.fromJsonData(String source) =>
      Order.fromMap(json.decode(source)["data"]);

  @override
  String toString() {
    return 'Order(id: $id, items: $items, totalCost: $totalCost, address: $address, phone: $phone, status: $status, deliveredDate: $deliveredDate)';
  }
}
