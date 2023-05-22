import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/common-widgets/custom_text.dart';
import 'package:pharmacy_buddy/models/order.dart';
import 'package:pharmacy_buddy/screens/user/search_screen.dart';
import 'package:pharmacy_buddy/screens/widgets/search_box.dart';
import 'package:pharmacy_buddy/services/user_service.dart';
import 'package:pharmacy_buddy/utils/constants.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class MyOrderScreen extends StatefulWidget {
  static const String routeName = '/my-order-screen';
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Order>? orderList;
  List<dynamic>? orders;
  final UserService _userService = UserService();

  @override
  void initState() {
    fetchUserOrderList();
    super.initState();
  }

  void fetchUserOrderList() async {
    orders = Provider.of<UserProvider>(context, listen: false).user.orders;
    orderList = [];

    for (int i = 0; i < orders!.length; i++) {
      var order =
          await _userService.fetchOrder(context: context, orderId: orders![0]);
      orderList!.add(order as Order);
    }

    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
        ),
      ),
      body: orderList == null
          ? const Center(child: CircularProgressIndicator())
          : orderList!.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 50,
                      ),
                      SizedBox(height: 12),
                      CustomText(str: "You never ordered", size: 20),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: orderList!.length,
                  itemBuilder: (context, idx) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OrderCard(order: orderList![idx]),
                    );
                  },
                ),
    );
  }
}

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
        Order order = this.order;
        showAbout(context, order);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        color: GlobalVariables.greyBackgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  str: "Cost: ₹${order.totalCost}",
                  weight: FontWeight.bold,
                ),
                CustomText(
                  str: "Qty: ${order.items.length}",
                  weight: FontWeight.bold,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  str: "Ordered Date: $orderedDate",
                  weight: FontWeight.bold,
                ),
                CustomText(
                  str: "Status: ${order.status}",
                  weight: FontWeight.bold,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<dynamic> showAbout(
  BuildContext context,
  Order order,
) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Order Details"),
        content: SingleChildScrollView(
          child: CustomText(
            str: order.details,
            weight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("CANCEL"),
          ),
        ],
      );
    },
  );
}
