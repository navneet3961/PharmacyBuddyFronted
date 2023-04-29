import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/common-widgets/account_button.dart';
import 'package:pharmacy_buddy/common-widgets/user_info_appbar.dart';
import 'package:pharmacy_buddy/screens/auth_screen.dart';
import 'package:pharmacy_buddy/services/shared_preferences.dart';
import 'package:pharmacy_buddy/utils/constants.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
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
              Image.network(
                'assets/images/logo.png',
                height: 40,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Row(
                  children: const [
                    Icon(Icons.notifications_outlined),
                    SizedBox(width: 5),
                    Icon(Icons.search_outlined),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: const [
          UserInfoBar(),
          SizedBox(height: 10),
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
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(
        context,
        AuthScreen.routeName,
        (route) => false,
      );
    }

    return Column(
      children: [
        Row(
          children: [
            AccountButton(text: "My Profile", onTap: () {}),
            AccountButton(text: "My Orders", onTap: () {}),
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
