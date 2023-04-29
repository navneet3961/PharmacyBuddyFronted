import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const SearchBar({
    Key? key,
    required this.controller,
    this.hintText = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(7),
      elevation: 1,
      child: TextFormField(
        controller: controller,
        cursorColor: Colors.black38,
        cursorHeight: 20,
        cursorWidth: 1,
        decoration: InputDecoration(
          prefixIcon: InkWell(
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.only(left: 6),
              child: Icon(
                Icons.search,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.only(top: 10),
          hintText: hintText,
          counterText: "",
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(7)),
            borderSide: BorderSide.none,
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(7)),
            borderSide: BorderSide(color: Colors.black38, width: 1),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Enter your ${hintText.toLowerCase()}";
          }
          return null;
        },
      ),
    );
  }
}
