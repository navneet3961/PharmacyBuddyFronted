import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/common-widgets/custom_text.dart';
import 'package:pharmacy_buddy/models/order.dart';
import 'package:pharmacy_buddy/screens/widgets/order_card.dart';
import 'package:pharmacy_buddy/services/user_service.dart';
import 'package:pharmacy_buddy/utils/constants.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

const List<String> status = [
  "Pending",
  "Shipped",
  "Delivered",
  "Return In Process",
  "Returned",
  "Cancelled",
];

class MyOrderScreen extends StatefulWidget {
  static const String routeName = '/my-order-screen';
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  List<Order>? orderList;
  final UserService _userService = UserService();

  @override
  void initState() {
    fetchUserOrderList();
    super.initState();
  }

  void fetchUserOrderList() async {
    List<dynamic> orders =
        Provider.of<UserProvider>(context, listen: false).user.orders;
    orderList = [];

    for (int i = 0; i < orders.length; i++) {
      var order =
          await _userService.fetchOrder(context: context, orderId: orders[i]);
      orderList!.add(order as Order);
    }

    setState(() {});
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
