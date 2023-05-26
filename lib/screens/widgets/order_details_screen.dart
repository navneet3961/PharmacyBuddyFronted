// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/common-widgets/custom_text.dart';
import 'package:pharmacy_buddy/models/order.dart';
import 'package:pharmacy_buddy/providers/user_provider.dart';
import 'package:pharmacy_buddy/screens/admin/admin_screen.dart';
import 'package:pharmacy_buddy/screens/user/my_order_screen.dart';
import 'package:pharmacy_buddy/services/admin_service.dart';
import 'package:pharmacy_buddy/utils/constants.dart';
import 'package:provider/provider.dart';

const List<String> status = [
  "Pending",
  "Shipped",
  "Delivered",
  "Return In Process",
  "Returned",
  "Cancelled",
];

class OrderDetailsScreen extends StatefulWidget {
  static const String routeName = '/order-screen';
  final Order order;
  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  int currentStep = 0;
  bool cancelled = false;

  @override
  void initState() {
    currentStep = widget.order.status;

    if (currentStep == 5) {
      cancelled = true;
      currentStep = 0;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AdminService adminService = AdminService();

    bool isAdmin =
        Provider.of<UserProvider>(context, listen: false).user.isAdmin;

    void updateOrderStatus() async {
      int status = widget.order.status;

      if (!isAdmin && status < 2) {
        status = 4;
      }

      bool changed = await adminService.updateOrderStatus(
          context: context, orderId: widget.order.id, status: status + 1);

      if (changed) {
        if (isAdmin) {
          Navigator.pushNamedAndRemoveUntil(
              context, AdminScreen.routeName, (route) => false,
              arguments: 1);
        } else {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pushNamed(context, MyOrderScreen.routeName);
        }
      }
    }

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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(border: Border.all()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CustomText(
                          str: "Order Id: ",
                          weight: FontWeight.bold,
                        ),
                        CustomText(
                          str: widget.order.id.toUpperCase(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const CustomText(
                      str: "Items:",
                      weight: FontWeight.bold,
                    ),
                    CustomText(
                      str: widget.order.details,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const CustomText(
                          str: "Total Cost: ",
                          weight: FontWeight.bold,
                        ),
                        CustomText(
                          str: "₹${widget.order.totalCost}",
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const CustomText(
                          str: "Phone: ",
                          weight: FontWeight.bold,
                        ),
                        CustomText(
                          str: widget.order.phone,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          str: "Address: ",
                          weight: FontWeight.bold,
                        ),
                        CustomText(
                          str: widget.order.address,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const CustomText(
                str: "Tracking",
                weight: FontWeight.w700,
              ),
              const SizedBox(height: 12),
              Stepper(
                physics: const ClampingScrollPhysics(),
                currentStep: currentStep,
                controlsBuilder: (context, details) {
                  if (isAdmin &&
                      currentStep != 2 &&
                      currentStep != 4 &&
                      currentStep != 5 &&
                      !cancelled) {
                    return UpdateStatusButton(
                        callback: updateOrderStatus, str: "Update Status");
                  }

                  if (!isAdmin) {
                    if (!cancelled && currentStep < 2) {
                      return UpdateStatusButton(
                          callback: updateOrderStatus, str: "Cancel Order");
                    } else if (currentStep == 2) {
                      DateTime returnedDate =
                          DateTime.fromMillisecondsSinceEpoch(
                              widget.order.orderedDate + 604800000);
                      DateTime todayDate = DateTime.now();

                      if (todayDate.year < returnedDate.year ||
                          (todayDate.year == returnedDate.year &&
                              todayDate.month < returnedDate.month) ||
                          (todayDate.year == returnedDate.year &&
                              todayDate.month == returnedDate.month &&
                              todayDate.day <= returnedDate.day)) {
                        return Column(
                          children: [
                            UpdateStatusButton(
                                callback: updateOrderStatus,
                                str: "Return Order"),
                            const SizedBox(height: 12),
                            const CustomText(
                                str:
                                    "* 10% of the cost of order will be deduct if you return the order"),
                          ],
                        );
                      }
                    }
                  }

                  return const SizedBox();
                },
                steps: cancelled
                    ? <Step>[
                        const Step(
                          title: Text("Cancelled"),
                          content: Text("Your order has been cancelled"),
                          isActive: true,
                          state: StepState.complete,
                        ),
                      ]
                    : <Step>[
                        Step(
                          title: const Text("Pending"),
                          content:
                              const Text("Your order is yet to be shipped"),
                          isActive: currentStep >= 0,
                          state: currentStep >= 0
                              ? StepState.complete
                              : StepState.indexed,
                        ),
                        Step(
                          title: const Text("Shipped"),
                          content:
                              const Text("Your order is yet to be delivered"),
                          isActive: currentStep >= 1,
                          state: currentStep >= 1
                              ? StepState.complete
                              : StepState.indexed,
                        ),
                        Step(
                          title: const Text("Delivered"),
                          content: const Text("Your order has been delivered"),
                          isActive: currentStep >= 2,
                          state: currentStep >= 2
                              ? StepState.complete
                              : StepState.indexed,
                        ),
                        if (currentStep > 2) ...<Step>[
                          Step(
                            title: const Text("Return in progress"),
                            content: const Text(
                                "Your order return is in progress and 10% of the cost of order will be deducted"),
                            isActive: currentStep >= 3,
                            state: currentStep >= 3
                                ? StepState.complete
                                : StepState.indexed,
                          ),
                          Step(
                            title: const Text("Returned"),
                            content: const Text("Your order has been returned"),
                            isActive: currentStep >= 4,
                            state: currentStep >= 4
                                ? StepState.complete
                                : StepState.indexed,
                          ),
                        ],
                      ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UpdateStatusButton extends StatelessWidget {
  const UpdateStatusButton({
    super.key,
    required this.callback,
    required this.str,
  });

  final void Function() callback;
  final String str;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: ElevatedButton(
        onPressed: callback,
        style: ButtonStyle(
            minimumSize:
                MaterialStateProperty.all(const Size(double.infinity / 2, 50))),
        child: Text(str),
      ),
    );
  }
}
