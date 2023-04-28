import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/screens/home_screen.dart';
import 'package:pharmacy_buddy/utils/constants.dart';

enum BarItem { home, profile, cart }

class BottomBar extends StatefulWidget {
  static const String routeName = '/bottomBar-screen';
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = BarItem.home.index;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  List<Widget> pages = [
    const HomeScreen(),
    const Center(
      child: Text("Account Page"),
    ),
    const Center(
      child: Text("Cart Page"),
    ),
  ];

  void updatePages(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
        onTap: updatePages,
        items: [
          barItems(_page, BarItem.home.index, Icons.home_outlined),
          barItems(_page, BarItem.profile.index, Icons.person_outlined),
          barItems(_page, BarItem.cart.index, Icons.shopping_cart_outlined),
        ],
      ),
    );
  }

  BottomNavigationBarItem barItems(int page, int idx, IconData icon) {
    return BottomNavigationBarItem(
      icon: Container(
        width: bottomBarWidth,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: page == idx
                  ? GlobalVariables.selectedNavBarColor
                  : GlobalVariables.unselectedNavBarColor,
              width: bottomBarBorderWidth,
            ),
          ),
        ),
        child: Icon(icon),
      ),
      label: "",
    );
  }
}
