import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/screens/auth_screen.dart';
import 'package:pharmacy_buddy/screens/home_screen.dart';
import 'package:pharmacy_buddy/screens/widgets/user_bottom_bar.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const AuthScreen());
    case HomeScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const HomeScreen());
    case UserBottomBar.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const UserBottomBar());
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
