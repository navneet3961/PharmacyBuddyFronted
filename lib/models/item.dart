import 'dart:convert';

class Item {
  final String id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String imageUrl;
  Item({
    this.id = "",
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  Item.empty({
    this.id = "",
    this.name = "",
    this.description = "",
    this.price = 0,
    this.quantity = 0,
    this.imageUrl = "",
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['_id'],
      name: map['name'],
      description: map['description'],
      price: double.parse(map['price'].toString()),
      quantity: map['quantity'],
      imageUrl: map['imageUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) => Item.fromMap(json.decode(source));

  // Here added ["data"] because all the data about the user is in data key
  factory Item.fromJsonData(String source) =>
      Item.fromMap(json.decode(source)["data"]);

  // Here added ["data"]["listOfItems"] because the list of items is in the data key of the user
  factory Item.fromJsonDataList(String source) =>
      Item.fromMap(json.decode(source)["data"]["listOfItems"]);

  @override
  String toString() {
    return '$name (₹$price, Qty: $quantity)';
  }
}
