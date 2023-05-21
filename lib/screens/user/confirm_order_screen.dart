// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/common-widgets/custom_text.dart';
import 'package:pharmacy_buddy/common-widgets/custom_text_form_field.dart';
import 'package:pharmacy_buddy/models/item.dart';
import 'package:pharmacy_buddy/models/order.dart';
import 'package:pharmacy_buddy/providers/user_provider.dart';
import 'package:pharmacy_buddy/services/user_service.dart';
import 'package:pharmacy_buddy/utils/constants.dart';
import 'package:provider/provider.dart';

class ConfirmOrderScreen extends StatefulWidget {
  static const String routeName = '/confirm-order-screen';
  final String address;
  const ConfirmOrderScreen(
      {super.key, this.address = "Goolar Road, Aligarh, Uttar Pradesh-202001"});

  @override
  State<ConfirmOrderScreen> createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  List<Item>? itemList;
  double totalCost = 0;
  late final String userId;
  final UserService _userService = UserService();

  final _newPhoneFormKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  void fetchAllData() async {
    itemList = await _userService.getCartItems(context: context);

    for (int idx = 0; idx < itemList!.length; idx++) {
      totalCost += itemList![idx].price * itemList![idx].quantity;
    }

    userId = Provider.of<UserProvider>(context, listen: false).user.id;
    setState(() {});
  }

  @override
  void dispose() {
    _phoneController.dispose();
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
      body: itemList == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DisplayListTIle(
                      leading: "Address:",
                      title: widget.address,
                      trailing: "",
                    ),
                    const SizedBox(height: 12),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            str: "Items:",
                            weight: FontWeight.w700,
                          ),
                          for (int i = 0; i < itemList!.length; i++) ...[
                            DisplayListTIle(
                              leading: (i + 1).toString(),
                              title: itemList![i].toString(),
                              trailing:
                                  "₹${(itemList![i].price * itemList![i].quantity).toStringAsFixed(2)}",
                            ),
                          ],
                          DisplayListTIle(
                            leading: "Total Cost",
                            trailing: "₹${totalCost.toStringAsFixed(2)}",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Form(
                      key: _newPhoneFormKey,
                      child: Column(
                        children: [
                          CustomTextFormField(
                            controller: _phoneController,
                            hintText: "Phone",
                            maxLength: 10,
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              if (_newPhoneFormKey.currentState!.validate()) {
                                Order order = Order(
                                    items: itemList!,
                                    totalCost: totalCost,
                                    address: widget.address.toString(),
                                    phone: _phoneController.text);
                                _userService.confirmOrder(
                                    context: context,
                                    userId: userId,
                                    order: order);
                              }
                            },
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all(
                                const Size(25, 50),
                              ),
                            ),
                            child: const Text(
                              "Confirm Order",
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

class DisplayListTIle extends StatelessWidget {
  const DisplayListTIle({
    super.key,
    this.leading = "",
    this.title = "",
    this.trailing = "",
  });

  final String leading;
  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      leading: CustomText(
        str: "$leading",
        weight: FontWeight.w700,
      ),
      title: CustomText(str: title),
      trailing: CustomText(str: trailing),
    );
  }
}
