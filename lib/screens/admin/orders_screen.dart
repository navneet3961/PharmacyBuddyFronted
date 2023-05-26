import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/common-widgets/custom_text.dart';
import 'package:pharmacy_buddy/models/order.dart';
import 'package:pharmacy_buddy/screens/widgets/order_card.dart';
import 'package:pharmacy_buddy/screens/widgets/search_box.dart';
import 'package:pharmacy_buddy/services/admin_service.dart';
import 'package:pharmacy_buddy/utils/constants.dart';

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
  final TextEditingController _searchController = TextEditingController();
  List<Order>? allOrdersList;
  List<Order>? orderList;
  int _value = 0;
  final AdminService _adminService = AdminService();

  @override
  void initState() {
    fetchAllOrders();
    super.initState();
  }

  void fetchAllOrders() async {
    allOrdersList = await _adminService.fetchOrders(context: context);
    orderList = allOrdersList;

    setState(() {});
  }

  void fetchOrderById(String orderId) {
    orderList = [];

    for (int i = 0; i < allOrdersList!.length; i++) {
      if (allOrdersList![i].id == orderId) {
        orderList!.add(allOrdersList![i]);
        break;
      }
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
        preferredSize: const Size.fromHeight(120),
        child: Column(
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: GlobalVariables.appBarGradient,
                ),
              ),
              title: Container(
                width: double.infinity,
                height: 40,
                margin: const EdgeInsets.all(10),
                child: SearchBox(
                  callback: fetchOrderById,
                  controller: _searchController,
                  hintText: "Search Orders By Id",
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text("Show results by status: "),
                    DropdownButton(
                        value: _value,
                        items: [0, 1, 2, 3, 4, 5, 6]
                            .map((e) => DropdownMenuItem(
                                value: e, child: Text(status[e])))
                            .toList(),
                        onChanged: (value) async {
                          _value = value!;
                          orderList = value == 0
                              ? await _adminService.fetchOrders(
                                  context: context)
                              : await _adminService.fetchOrders(
                                  context: context, status: value - 1);

                          setState(() {});
                        }),
                  ],
                ),
              ),
            ),
          ],
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
