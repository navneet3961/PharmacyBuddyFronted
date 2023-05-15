import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/models/item.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

      http.Response res = await http.post(
        Uri.parse('$uri/api/v1/item/'),
        body: item.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
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
}
