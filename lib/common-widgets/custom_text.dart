import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String str;
  final double size;
  final FontWeight weight;
  const CustomText({
    Key? key,
    required this.str,
    this.size = 12,
    this.weight = FontWeight.normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      str,
      style: TextStyle(
        fontSize: size,
        fontWeight: weight,
      ),
    );
  }
}
