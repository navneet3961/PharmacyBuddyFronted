import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/common-widgets/custom_text.dart';
import 'package:pharmacy_buddy/models/item.dart';
import 'package:pharmacy_buddy/models/user.dart';
import 'package:pharmacy_buddy/providers/user_provider.dart';
import 'package:pharmacy_buddy/services/user_service.dart';
import 'package:provider/provider.dart';

Future<dynamic> showAbout(
  BuildContext context,
  Item item,
) {
  final User user = Provider.of<UserProvider>(context, listen: false).user;
  final UserService userService = UserService();

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("About"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                    str: "Name: ",
                    weight: FontWeight.bold,
                  ),
                  Flexible(child: CustomText(str: item.name))
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const CustomText(
                    str: "Price: ",
                    weight: FontWeight.bold,
                  ),
                  CustomText(str: "₹${item.price.toString()}")
                ],
              ),
              const SizedBox(height: 12),
              const CustomText(
                str: "Description: ",
                weight: FontWeight.bold,
              ),
              const SizedBox(height: 8),
              CustomText(str: item.description),
            ],
          ),
        ),
        actions: <Widget>[
          !user.isAdmin
              ? ElevatedButton(
                  onPressed: () {
                    (userService.addItemToCart(
                        context: context, itemId: item.id));
                    Navigator.of(context).pop(false);
                  },
                  child: const Text("Add to Cart"),
                )
              : Container(),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("CANCEL"),
          ),
        ],
      );
    },
  );
}
