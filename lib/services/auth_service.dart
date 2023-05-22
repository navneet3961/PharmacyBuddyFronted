// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pharmacy_buddy/models/user.dart';
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
      User user = User.signUp(name: name, email: email, password: password);

      http.Response res = await http.post(
        Uri.parse('$uri/api/v1/user/signup'),
        body: user.toJson(),
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
      User user = User.signIn(email: email, password: password);

      http.Response res = await http.post(
        Uri.parse('$uri/api/v1/user/signin'),
        body: user.toJson(),
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

          Provider.of<UserProvider>(context, listen: false).setUser(res.body);

          User user = Provider.of<UserProvider>(context, listen: false).user;

          await PrefService.createCache(token, user.cart);

          Navigator.pushNamedAndRemoveUntil(
            context,
            user.isAdmin ? AdminScreen.routeName : UserBottomBar.routeName,
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
        await PrefService.createCache('', '');
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

  void updateUser({
    required BuildContext context,
    required String userId,
    String name = "",
    String email = "",
    String password = "",
  }) async {
    try {
      String? token = await PrefService.getCache();

      if (token == null) {
        await PrefService.createCache('', '');
        token = '';
      }

      http.Response res = await http.patch(
        Uri.parse('$uri/api/v1/user/$userId'),
        body: jsonEncode({"name": name, "email": email, "password": password}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-access-token': token
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          showSnackBar(context, "Update successfully!");

          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          User user = Provider.of<UserProvider>(context, listen: false).user;

          if (password.isEmpty) {
            final String token = res.headers["x-access-token"]!;
            await PrefService.createCache(token, user.cart);
          }

          Navigator.pushNamedAndRemoveUntil(
            context,
            UserBottomBar.routeName,
            (route) => false,
          );
        },
      );
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }
}
