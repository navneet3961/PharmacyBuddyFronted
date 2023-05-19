import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/common-widgets/custom_text.dart';
import 'package:pharmacy_buddy/models/item.dart';
import 'package:pharmacy_buddy/screens/widgets/show_about.dart';
import 'package:pharmacy_buddy/utils/constants.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.item,
  });

  final Item item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        Item item = this.item;
        showAbout(context, item);
      },
      child: Container(
        height: 150,
        padding: const EdgeInsets.all(8),
        color: GlobalVariables.greyBackgroundColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              item.imageUrl,
              width: MediaQuery.of(context).size.width / 2,
              height: 150,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    str: item.name,
                    weight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),
                  CustomText(
                    str: "₹ ${item.price}",
                    weight: FontWeight.bold,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
