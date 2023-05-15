import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String str;
  final double size;
  final FontWeight weight;
  final Color color;
  const CustomText({
    Key? key,
    required this.str,
    this.size = 15,
    this.weight = FontWeight.normal,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      str,
      style: TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: color,
      ),
    );
  }
}
