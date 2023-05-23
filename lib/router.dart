import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/models/item.dart';
import 'package:pharmacy_buddy/models/order.dart';
import 'package:pharmacy_buddy/screens/admin/add_item_screen.dart';
import 'package:pharmacy_buddy/screens/admin/orders_screen.dart';
import 'package:pharmacy_buddy/screens/admin/update_item_screen.dart';
import 'package:pharmacy_buddy/screens/auth_screen.dart';
import 'package:pharmacy_buddy/screens/user/address_screen.dart';
import 'package:pharmacy_buddy/screens/user/cart_screen.dart';
import 'package:pharmacy_buddy/screens/user/confirm_order_screen.dart';
import 'package:pharmacy_buddy/screens/user/home_screen.dart';
import 'package:pharmacy_buddy/screens/admin/admin_screen.dart';
import 'package:pharmacy_buddy/screens/user/my_order_screen.dart';
import 'package:pharmacy_buddy/screens/user/my_profile_screen.dart';
import 'package:pharmacy_buddy/screens/widgets/order_details_screen.dart';
import 'package:pharmacy_buddy/screens/user/search_screen.dart';
import 'package:pharmacy_buddy/screens/user/user_bottom_bar.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );
    case UserBottomBar.routeName:
      int page = 0;

      if (routeSettings.arguments != null) {
        page = routeSettings.arguments as int;
      }

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => UserBottomBar(page: page),
      );
    case AdminScreen.routeName:
      int page = 0;

      if (routeSettings.arguments != null) {
        page = routeSettings.arguments as int;
      }

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AdminScreen(page: page),
      );
    case AddItemScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddItemScreen(),
      );
    case UpdateItemScreen.routeName:
      Item item = routeSettings.arguments as Item;

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => UpdateItemScreen(item: item),
      );
    case SearchScreen.routeName:
      String keyword = routeSettings.arguments as String;

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SearchScreen(keyword: keyword),
      );
    case CartScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const CartScreen(),
      );
    case AddressScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddressScreen(),
      );
    case ConfirmOrderScreen.routeName:
      String address = routeSettings.arguments as String;

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ConfirmOrderScreen(address: address),
      );
    case MyOrderScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const MyOrderScreen(),
      );
    case MyProfileScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const MyProfileScreen(),
      );
    case OrderDetailsScreen.routeName:
      Order order = routeSettings.arguments as Order;

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OrderDetailsScreen(order: order),
      );
    case OrdersScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const OrdersScreen(),
      );
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
