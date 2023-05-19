import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/models/item.dart';
import 'package:pharmacy_buddy/screens/admin/add_item_screen.dart';
import 'package:pharmacy_buddy/screens/admin/update_item_screen.dart';
import 'package:pharmacy_buddy/screens/auth_screen.dart';
import 'package:pharmacy_buddy/screens/user/cart_screen.dart';
import 'package:pharmacy_buddy/screens/user/home_screen.dart';
import 'package:pharmacy_buddy/screens/admin/admin_screen.dart';
import 'package:pharmacy_buddy/screens/user/search_screen.dart';
import 'package:pharmacy_buddy/screens/user/user_bottom_bar.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const AuthScreen());
    case HomeScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const HomeScreen());
    case UserBottomBar.routeName:
      if (routeSettings.arguments == null) {
        return MaterialPageRoute(
            settings: routeSettings, builder: (_) => const UserBottomBar());
      } else {
        int page = routeSettings.arguments as int;
        return MaterialPageRoute(
            settings: routeSettings, builder: (_) => UserBottomBar(page: page));
      }
    case AdminScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const AdminScreen());
    case AddItemScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const AddItemScreen());
    case UpdateItemScreen.routeName:
      Item item = routeSettings.arguments as Item;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => UpdateItemScreen(
          item: item,
        ),
      );
    case SearchScreen.routeName:
      String keyword = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SearchScreen(
          keyword: keyword,
        ),
      );
    case CartScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const CartScreen());
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text("Page Not Found"),
          ),
        ),
      );
  }
}
