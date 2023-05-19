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

  if (res["message"].runtimeType.toString() == "_JsonMap") {
    res["message"] = "Invalid data sent in the request";
  }

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
