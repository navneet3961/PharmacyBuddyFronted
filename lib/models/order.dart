import 'dart:convert';

import 'package:pharmacy_buddy/models/item.dart';

class Order {
  final String id;
  final int qty;
  final String details;
  final dynamic orderedDate;
  final List<Item> items;
  final double totalCost;
  final String address;
  final String phone;
  final int status;
  final int deliveredDate;

  Order({
    this.id = '',
    this.qty = 0,
    this.details = '',
    this.orderedDate = '',
    required this.items,
    required this.totalCost,
    required this.address,
    required this.phone,
    this.status = 0,
    this.deliveredDate = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'qty': qty,
      'details': details,
      'orderedDate': orderedDate,
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
      qty: list.length,
      details: map['details'],
      orderedDate: map['orderedDate'],
      items: list,
      totalCost: map['totalCost'],
      address: map['address'],
      phone: map['phone'],
      status: map['status'],
      deliveredDate: map['deliveredDate'],
    );
  }

  factory Order.fromMapWithoutItems(Map<String, dynamic> map) {
    return Order(
      id: map['_id'],
      qty: map['items'].length,
      details: map['details'],
      orderedDate: map['orderedDate'],
      items: [],
      totalCost: map['totalCost'],
      address: map['address'],
      phone: map['phone'],
      status: map['status'],
      deliveredDate: map['deliveredDate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));

  // Here getting order without items
  factory Order.fromJsonWithoutItems(String source) =>
      Order.fromMapWithoutItems(json.decode(source));

  // Here added ["data"] because all the data about the order is in data key
  factory Order.fromJsonData(String source) =>
      Order.fromMap(json.decode(source)["data"]);

  @override
  String toString() {
    return 'Order(id: $id, details: $details, items: $items, totalCost: $totalCost, address: $address, phone: $phone, status: $status, deliveredDate: $deliveredDate)';
  }
}
