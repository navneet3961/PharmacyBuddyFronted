import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/providers/user_provider.dart';
import 'package:pharmacy_buddy/utils/constants.dart';
import 'package:provider/provider.dart';

class UserInfoBar extends StatelessWidget {
  const UserInfoBar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: RichText(
          text: TextSpan(
        text: "Hello, ",
        style: const TextStyle(
          fontSize: 20,
        ),
        children: [
          TextSpan(
            text: user.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      )),
    );
  }
}
