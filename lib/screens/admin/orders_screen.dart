import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/common-widgets/custom_text.dart';
import 'package:pharmacy_buddy/models/order.dart';
import 'package:pharmacy_buddy/screens/widgets/order_card.dart';
import 'package:pharmacy_buddy/services/admin_service.dart';

const List<String> status = [
  "All",
  "Pending",
  "Shipped",
  "Delivered",
  "Return In Process",
  "Returned",
  "Cancelled",
];

class OrdersScreen extends StatefulWidget {
  static const String routeName = '/orders-screen';
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order>? orderList;
  int _value = 0;
  final AdminService _adminService = AdminService();

  @override
  void initState() {
    fetchAllOrders();
    super.initState();
  }

  void fetchAllOrders() async {
    orderList = await _adminService.fetchOrders(context: context);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text("Show results by status: "),
              DropdownButton(
                  value: _value,
                  items: [0, 1, 2, 3, 4, 5, 6]
                      .map((e) =>
                          DropdownMenuItem(value: e, child: Text(status[e])))
                      .toList(),
                  onChanged: (value) async {
                    _value = value!;
                    orderList = value == 0
                        ? await _adminService.fetchOrders(context: context)
                        : await _adminService.fetchOrders(
                            context: context, status: value - 1);

                    setState(() {});
                  }),
            ],
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
                      CustomText(str: "No orders to show", size: 20),
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
