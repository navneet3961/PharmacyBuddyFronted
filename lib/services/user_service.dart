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
        await PrefService.createCache('');
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
}
