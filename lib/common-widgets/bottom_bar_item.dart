import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/utils/constants.dart';

BottomNavigationBarItem barItems(int page, int idx, IconData icon) {
  return BottomNavigationBarItem(
    icon: Container(
      width: 42,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: page == idx
                ? GlobalVariables.selectedNavBarColor
                : GlobalVariables.unselectedNavBarColor,
            width: 5,
          ),
        ),
      ),
      child: Icon(icon),
    ),
    label: "",
  );
}
