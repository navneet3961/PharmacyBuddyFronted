import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/models/item.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pharmacy_buddy/services/shared_preferences.dart';
import 'package:pharmacy_buddy/utils/error_handling.dart';
import 'package:pharmacy_buddy/utils/snackbar.dart';
import 'package:http/http.dart' as http;

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

      // ignore: use_build_context_synchronously
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
    required String cartId,
    required String itemId,
  }) async {
    try {
      String? token = await PrefService.getCache();

      if (token == null) {
        await PrefService.createCache('', '');
        token = '';
      }

      http.Response res = await http.patch(
        Uri.parse('$uri/api/v1/cart/$cartId'),
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

      // ignore: use_build_context_synchronously
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
    required String cartId,
    required String itemId,
  }) async {
    try {
      String? token = await PrefService.getCache();

      if (token == null) {
        await PrefService.createCache('', '');
        token = '';
      }

      http.Response res = await http.patch(
        Uri.parse('$uri/api/v1/cart/$cartId'),
        body: jsonEncode({"items": itemId}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-access-token': token
        },
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Item removed from cart successfully!");
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<List<Item>> getCartItems({
    required BuildContext context,
    required String cartId,
  }) async {
    List<Item> itemList = [];

    try {
      String? token = await PrefService.getCache();

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

      // ignore: use_build_context_synchronously
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
}
