import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/utils/snackbar.dart';

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  final dynamic res = jsonDecode(response.body);
  switch (response.statusCode) {
    case 200:
    case 201:
      onSuccess();
      break;
    case 400:
      showSnackBar(context, res['message']);
      break;
    case 500:
      showSnackBar(context, res['error']);
      break;
    default:
      showSnackBar(context, response.body);
  }
}
