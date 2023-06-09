import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/screens/user/account_screen.dart';
import 'package:pharmacy_buddy/screens/user/cart_screen.dart';
import 'package:pharmacy_buddy/screens/user/home_screen.dart';
import 'package:pharmacy_buddy/common-widgets/bottom_bar_item.dart';
import 'package:pharmacy_buddy/utils/constants.dart';

enum BarItem { home, profile, cart }

class UserBottomBar extends StatefulWidget {
  static const String routeName = '/user-bottomBar-screen';
  final int page;
  const UserBottomBar({super.key, this.page = 0});

  @override
  State<UserBottomBar> createState() => _UserBottomBarState();
}

class _UserBottomBarState extends State<UserBottomBar> {
  late int _page;

  List<Widget> pages = [
    const HomeScreen(),
    const AccountScreen(),
    const CartScreen(),
  ];

  @override
  void initState() {
    _page = widget.page;
    super.initState();
  }

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
          barItems(_page, BarItem.home.index, Icons.home_outlined, "Home Page"),
          barItems(_page, BarItem.profile.index, Icons.person_outlined,
              "Profile Page"),
          barItems(_page, BarItem.cart.index, Icons.shopping_cart_outlined,
              "Cart Page"),
        ],
      ),
    );
  }
}
