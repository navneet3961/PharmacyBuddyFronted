import 'dart:convert';
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/models/item.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pharmacy_buddy/screens/admin/admin_screen.dart';
import 'package:pharmacy_buddy/services/shared_preferences.dart';
import 'package:pharmacy_buddy/utils/error_handling.dart';
import 'package:pharmacy_buddy/utils/snackbar.dart';
import 'package:http/http.dart' as http;

final String uri = dotenv.env['URI']!;

class AdminService {
  void addItem({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required int quantity,
    required File image,
  }) async {
    try {
      final cloudinary = CloudinaryPublic('dgsw32hy4', 'w77q0zvx');

      String imageUrl = "";

      var result = await cloudinary
          .uploadFile(CloudinaryFile.fromFile(image.path, folder: name));

      imageUrl = result.secureUrl;

      Item item = Item(
        name: name,
        description: description,
        price: price,
        quantity: quantity,
        imageUrl: imageUrl,
      );

      String? token = await PrefService.getCache();

      if (token == null) {
        await PrefService.createCache('');
        token = '';
      }

      http.Response res = await http.post(
        Uri.parse('$uri/api/v1/item/'),
        body: item.toJson(),
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
          showSnackBar(context, "Item added successfully!");
          Navigator.pop(context);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void updateItem({
    required BuildContext context,
    required String id,
    required String name,
    required String description,
    required double price,
    required int quantity,
    required String imageUrl,
  }) async {
    try {
      Item item = Item(
        id: id,
        name: name,
        description: description,
        price: price,
        quantity: quantity,
        imageUrl: imageUrl,
      );

      String? token = await PrefService.getCache();

      if (token == null) {
        await PrefService.createCache('');
        token = '';
      }

      http.Response res = await http.patch(
        Uri.parse('$uri/api/v1/item/$id'),
        body: item.toJson(),
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
          showSnackBar(context, "Item updated successfully!");
          Navigator.pushNamedAndRemoveUntil(
              context, AdminScreen.routeName, (route) => false);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<List<Item>> fetchAllItems({
    required BuildContext context,
  }) async {
    List<Item> itemList = [];

    try {
      String? token = await PrefService.getCache();

      if (token == null) {
        await PrefService.createCache('');
        token = '';
      }

      http.Response res = await http.get(
        Uri.parse('$uri/api/v1/item/'),
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

  void deleteItem({
    required BuildContext context,
    required String id,
  }) async {
    try {
      String? token = await PrefService.getCache();

      if (token == null) {
        await PrefService.createCache('');
        token = '';
      }

      http.Response res = await http.delete(
        Uri.parse('$uri/api/v1/item/$id'),
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
          showSnackBar(context, "Item deleted Succesfully");
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
