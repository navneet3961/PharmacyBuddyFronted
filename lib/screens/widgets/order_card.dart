import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/common-widgets/custom_text.dart';
import 'package:pharmacy_buddy/models/order.dart';
import 'package:pharmacy_buddy/screens/widgets/order_details_screen.dart';
import 'package:pharmacy_buddy/utils/constants.dart';

const List<String> months = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "Sepetember",
  "October",
  "November",
  "December"
];

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
  });

  final Order order;

  @override
  Widget build(BuildContext context) {
    var date = DateTime.fromMillisecondsSinceEpoch(order.orderedDate);
    String orderedDate = "${months[date.month - 1]} ${date.day}, ${date.year}";

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, OrderDetailsScreen.routeName,
            arguments: order);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        color: GlobalVariables.greyBackgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              str: "Order Id: ${order.id.toUpperCase()}",
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  str: "Cost: ₹${order.totalCost}",
                ),
                CustomText(
                  str: "Items Qty: ${order.qty}",
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  str: "Ordered Date: $orderedDate",
                ),
                CustomText(
                  str: "Status: ${status[order.status]}",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
