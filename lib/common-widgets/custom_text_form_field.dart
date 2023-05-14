import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final TextInputType? keyBoardType;
  final int? maxLength;
  final String? counterText;
  const CustomTextFormField(
      {Key? key,
      required this.controller,
      this.hintText = "",
      this.maxLines = 1,
      this.keyBoardType,
      this.maxLength,
      this.counterText = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyBoardType,
      maxLines: maxLines,
      cursorColor: Colors.black38,
      cursorWidth: 1,
      maxLength: maxLength,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: hintText,
        hintText: hintText,
        counterText: counterText,
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black38,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black38,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Enter your ${hintText.toLowerCase()}";
        }
        return null;
      },
    );
  }
}
