// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/models/address.dart';
import 'package:pharmacy_buddy/models/item.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pharmacy_buddy/models/order.dart';
import 'package:pharmacy_buddy/providers/user_provider.dart';
import 'package:pharmacy_buddy/screens/user/confirm_order_screen.dart';
import 'package:pharmacy_buddy/screens/user/user_bottom_bar.dart';
import 'package:pharmacy_buddy/services/shared_preferences.dart';
import 'package:pharmacy_buddy/utils/error_handling.dart';
import 'package:pharmacy_buddy/utils/snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

final String uri = dotenv.env['URI']!;

class UserService {
  Future<List<Item>> fetchAllItems({
    required BuildContext context,
    required String keyword,
  }) async {
    List<Item> itemList = [];

    try {
      String? token = await PrefService.getCache();

      if (token == null) {
        await PrefService.createCache('', '');
        token = '';
      }

      http.Response res = await http.get(
        Uri.parse('$uri/api/v1/item/?name=$keyword'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-access-token': token
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var data = jsonDecode(res.body)["data"];

          for (int i = 0; i < data.length; i++) {
            itemList.add((Item.fromJson(jsonEncode(data[i]))));
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }

    return itemList;
  }

  void addItemToCart({
    required BuildContext context,
    required String itemId,
  }) async {
    try {
      String? token = await PrefService.getCache();
      String? cartId = await PrefService.getCartId();

      if (token == null) {
        await PrefService.createCache('', '');
        token = '';
      }

      http.Response res = await http.patch(
        Uri.parse('$uri/api/v1/cart/add/$cartId'),
        body: jsonEncode({
          "items": [
            {"itemId": itemId, "quantity": 1}
          ]
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-access-token': token
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Item added to cart successfully!");
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void removeItemFromCart({
    required BuildContext context,
    required String itemId,
    required bool remove,
  }) async {
    try {
      String? token = await PrefService.getCache();
      String? cartId = await PrefService.getCartId();

      if (token == null) {
        await PrefService.createCache('', '');
        token = '';
      }

      http.Response res = await http.patch(
        Uri.parse('$uri/api/v1/cart/remove/$cartId'),
        body: jsonEncode({"itemId": itemId, "remove": remove}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-access-token': token
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Item removed from cart successfully!");
          Navigator.popAndPushNamed(context, UserBottomBar.routeName,
              arguments: 2);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<List<Item>> getCartItems({
    required BuildContext context,
  }) async {
    List<Item> itemList = [];

    try {
      String? token = await PrefService.getCache();
      String? cartId = await PrefService.getCartId();

      if (token == null) {
        await PrefService.createCache('', '');
        token = '';
      }

      http.Response res = await http.get(
        Uri.parse('$uri/api/v1/cart/$cartId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-access-token': token
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var items = jsonDecode(res.body)["data"]["items"];
          var listOfItems = jsonDecode(res.body)["data"]["listOfItems"];

          for (int i = 0; i < items.length; i++) {
            listOfItems[i]["quantity"] = items[i]["quantity"];
            itemList.add((Item.fromJson(jsonEncode(listOfItems[i]))));
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }

    return itemList;
  }

  void addNewAddress({
    required BuildContext context,
    required String userId,
    required Address address,
  }) async {
    try {
      String? token = await PrefService.getCache();

      if (token == null) {
        await PrefService.createCache('', '');
        token = '';
      }

      http.Response res = await http.post(
        Uri.parse('$uri/api/v1/address/'),
        body: address.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-access-token': token
        },
      );

      var response = jsonDecode(res.body);

      if (response["status"] == true) {
        String addressId = Address.fromJsonData(res.body).id;

        res = await http.patch(
          Uri.parse('$uri/api/v1/user/$userId'),
          body: jsonEncode({"addressId": addressId}),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-access-token': token
          },
        );

        response = jsonDecode(res.body);

        if (response["status"] == true) {
          var userProvider = Provider.of<UserProvider>(context, listen: false);
          userProvider.setUser(res.body);
        }
      }

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          Navigator.pushNamed(context, ConfirmOrderScreen.routeName,
              arguments: address.toString());
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void confirmOrder({
    required BuildContext context,
    required String userId,
    required Order order,
  }) async {
    try {
      String? token = await PrefService.getCache();

      if (token == null) {
        await PrefService.createCache('', '');
        token = '';
      }

      List<String> items = [];

      for (int i = 0; i < order.items.length; i++) {
        items.add(order.items[i].id);
      }

      http.Response res = await http.post(
        Uri.parse('$uri/api/v1/order/'),
        body: jsonEncode({
          "items": items,
          "totalCost": order.totalCost,
          "address": order.address,
          "phone": order.phone
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-access-token': token
        },
      );

      var response = jsonDecode(res.body);

      if (response["status"] == true) {
        String orderId = Order.fromJsonData(res.body).id;

        res = await http.patch(
          Uri.parse('$uri/api/v1/user/$userId'),
          body: jsonEncode({"orderId": orderId}),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-access-token': token
          },
        );

        response = jsonDecode(res.body);

        if (response["status"] == true) {
          var userProvider = Provider.of<UserProvider>(context, listen: false);
          userProvider.setUser(res.body);

          String? cartId = await PrefService.getCartId();

          res = await http.patch(
            Uri.parse('$uri/api/v1/cart/empty/$cartId'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'x-access-token': token
            },
          );

          response = jsonDecode(res.body);
        }
      }

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Order Confirmed");
          Navigator.pushNamedAndRemoveUntil(
              context, UserBottomBar.routeName, (route) => false);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
