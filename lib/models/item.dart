import 'dart:convert';

class Item {
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String imageUrl;
  Item({
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      name: map['name'],
      description: map['description'],
      price: map['price'],
      quantity: map['quantity'],
      imageUrl: map['imageUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  // Here added ["data"] because all the data about the user is in data key
  factory Item.fromJson(String source) =>
      Item.fromMap(json.decode(source)["data"]);
}
