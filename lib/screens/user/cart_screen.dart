import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/common-widgets/custom_text.dart';
import 'package:pharmacy_buddy/models/item.dart';
import 'package:pharmacy_buddy/models/user.dart';
import 'package:pharmacy_buddy/screens/user/address_screen.dart';
import 'package:pharmacy_buddy/screens/user/search_screen.dart';
import 'package:pharmacy_buddy/screens/user/user_bottom_bar.dart';
import 'package:pharmacy_buddy/screens/widgets/search_box.dart';
import 'package:pharmacy_buddy/services/user_service.dart';
import 'package:pharmacy_buddy/utils/constants.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class CartScreen extends StatefulWidget {
  static const String routeName = '/cart-screen';
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _searchController = TextEditingController();
  double totalCost = 0;
  List<Item>? itemList;
  final UserService _userService = UserService();

  @override
  void initState() {
    fetchAllItems();
    super.initState();
  }

  void fetchAllItems() async {
    itemList = await _userService.getCartItems(context: context);

    for (int idx = 0; idx < itemList!.length; idx++) {
      totalCost += itemList![idx].price * itemList![idx].quantity;
    }
    setState(() {});
  }

  void navigateToSearchScreen(String keyword) {
    Navigator.popAndPushNamed(context, SearchScreen.routeName,
        arguments: keyword);
  }

  void navigateToAddressScreen() {
    Navigator.pushNamed(context, AddressScreen.routeName);
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
              callback: navigateToSearchScreen,
              controller: _searchController,
              hintText: "Search Medicines",
            ),
          ),
        ),
      ),
      body: itemList == null
          ? const Center(child: CircularProgressIndicator())
          : itemList!.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 50,
                      ),
                      SizedBox(height: 12),
                      CustomText(str: "Your Cart is Empty", size: 20),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          const CustomText(
                            str: "Subtotal: ",
                            weight: FontWeight.w300,
                            size: 20,
                          ),
                          CustomText(
                            str: "₹ ${totalCost.toStringAsFixed(2)}",
                            weight: FontWeight.bold,
                            size: 20,
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: itemList!.length,
                        itemBuilder: (context, idx) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ItemCard(item: itemList![idx]),
                          );
                        },
                      ),
                    ),
                  ],
                ),
      floatingActionButton: Visibility(
        visible: itemList == null || itemList!.isNotEmpty,
        child: FloatingActionButton(
          onPressed: navigateToAddressScreen,
          tooltip: "Place Order",
          child: const Icon(Icons.shopping_bag_outlined),
        ),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.item,
  });

  final Item item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
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
                    str: "₹${item.price}",
                    weight: FontWeight.bold,
                    size: 18,
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.black12, width: 1.5),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
                        child: Row(
                          children: [
                            Container(
                              width: 35,
                              height: 32,
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () {
                                  final UserService userService = UserService();
                                  bool remove = false;

                                  if (item.quantity == 1) {
                                    remove = true;
                                  }

                                  userService.removeItemFromCart(
                                      context: context,
                                      itemId: item.id,
                                      remove: remove);
                                },
                                child: const Icon(
                                  Icons.remove,
                                  size: 18,
                                ),
                              ),
                            ),
                            Container(
                              width: 35,
                              height: 32,
                              alignment: Alignment.center,
                              color: Colors.white,
                              child: CustomText(
                                str: item.quantity.toString(),
                                size: 18,
                              ),
                            ),
                            Container(
                              width: 35,
                              height: 32,
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () {
                                  final UserService userService = UserService();

                                  userService.addItemToCart(
                                      context: context, itemId: item.id);

                                  Navigator.popAndPushNamed(
                                      context, UserBottomBar.routeName,
                                      arguments: 2);
                                },
                                child: const Icon(
                                  Icons.add,
                                  size: 18,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

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
              Row(
                children: [
                  const CustomText(
                    str: "Quantity: ",
                    weight: FontWeight.bold,
                  ),
                  CustomText(str: item.quantity.toString())
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
                    Navigator.of(context).pop(false);
                    (userService.removeItemFromCart(
                        context: context, itemId: item.id, remove: true));
                  },
                  child: const Text("Remove from Cart"),
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
