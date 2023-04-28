import 'package:flutter/material.dart';

class CustomPasswordTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  const CustomPasswordTextFormField({
    Key? key,
    required this.controller,
    this.hintText = "",
  }) : super(key: key);

  @override
  State<CustomPasswordTextFormField> createState() =>
      _CustomPasswordTextFormFieldState();
}

class _CustomPasswordTextFormFieldState
    extends State<CustomPasswordTextFormField> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: obscureText,
      maxLength: 12,
      decoration: InputDecoration(
        labelText: widget.hintText,
        hintText: widget.hintText,
        counterText: "",
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
        ),
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
          return "Enter your ${widget.hintText.toLowerCase()}";
        }
        return null;
      },
    );
  }
}
