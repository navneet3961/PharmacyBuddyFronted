// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/common-widgets/account_button.dart';
import 'package:pharmacy_buddy/providers/user_provider.dart';
import 'package:pharmacy_buddy/screens/auth_screen.dart';
import 'package:pharmacy_buddy/screens/user/my_order_screen.dart';
import 'package:pharmacy_buddy/screens/user/my_profile_screen.dart';
import 'package:pharmacy_buddy/screens/user/user_info_appbar.dart';
import 'package:pharmacy_buddy/services/shared_preferences.dart';
import 'package:pharmacy_buddy/utils/constants.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 50,
              ),
              const UserInfoBar()
            ],
          ),
        ),
      ),
      body: const Column(
        children: [
          SizedBox(height: 15),
          Buttons(),
        ],
      ),
    );
  }
}

class Buttons extends StatelessWidget {
  const Buttons({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> logout() async {
      await PrefService.destroyCache();

      Provider.of<UserProvider>(context, listen: false).emptyUser();

      Navigator.pushNamedAndRemoveUntil(
        context,
        AuthScreen.routeName,
        (route) => false,
      );
    }

    void navigateToMyOrdersScreen() {
      Navigator.pushNamed(context, MyOrderScreen.routeName);
    }

    void navigateToMyProgileScreen() {
      Navigator.pushNamed(context, MyProfileScreen.routeName);
    }

    return Column(
      children: [
        Row(
          children: [
            AccountButton(text: "My Profile", onTap: navigateToMyProgileScreen),
            AccountButton(text: "My Orders", onTap: navigateToMyOrdersScreen),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            AccountButton(text: "Log Out", onTap: logout),
          ],
        ),
      ],
    );
  }
}
