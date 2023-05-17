// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pharmacy_buddy/providers/user_provider.dart';
import 'package:pharmacy_buddy/screens/admin/admin_screen.dart';
import 'package:pharmacy_buddy/screens/user/user_bottom_bar.dart';
import 'package:pharmacy_buddy/services/shared_preferences.dart';
import 'package:pharmacy_buddy/utils/error_handling.dart';
import 'package:pharmacy_buddy/utils/snackbar.dart';
import 'package:provider/provider.dart';

final String uri = dotenv.env['URI']!;

class AuthService {
  void signUpUser({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/v1/user/signup'),
        body: jsonEncode({"name": name, "email": email, "password": password}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Account created successfully!");
        },
      );
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }

  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/v1/user/signin'),
        body: jsonEncode({"email": email, "password": password}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          showSnackBar(context, "Sign-In successful!");
          final String token = res.headers["x-access-token"]!;

          await PrefService.createCache(token);

          Provider.of<UserProvider>(context, listen: false).setUser(res.body);

          bool isAdmin =
              Provider.of<UserProvider>(context, listen: false).user.isAdmin;

          Navigator.pushNamedAndRemoveUntil(
            context,
            isAdmin ? AdminScreen.routeName : UserBottomBar.routeName,
            (route) => false,
          );
        },
      );
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }

  void getUser({
    required BuildContext context,
  }) async {
    try {
      String? token = await PrefService.getCache();

      if (token == null) {
        await PrefService.createCache('');
        token = '';
      }

      http.Response res = await http.post(
        Uri.parse('$uri/api/v1/user/isValidToken'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-access-token': token
        },
      );

      var response = jsonDecode(res.body);

      if (response["status"] == true) {
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(res.body);
      }
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }
}
