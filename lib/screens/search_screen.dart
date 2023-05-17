import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/common-widgets/custom_text.dart';
import 'package:pharmacy_buddy/models/item.dart';
import 'package:pharmacy_buddy/screens/widgets/search_box.dart';
import 'package:pharmacy_buddy/services/user_service.dart';
import 'package:pharmacy_buddy/utils/constants.dart';

class SearchScreen extends StatefulWidget {
  final String keyword;
  static const String routeName = '/search-screen';
  const SearchScreen({super.key, required this.keyword});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Item>? itemList;
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.keyword;
    fetchAllItems(widget.keyword);
  }

  void fetchAllItems(String keyword) async {
    itemList =
        await _userService.fetchAllItems(context: context, keyword: keyword);
    setState(() {});
  }

  void navigateToSearchScreen(String keyword) {
    Navigator.popAndPushNamed(context, SearchScreen.routeName,
        arguments: keyword);
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
          : ListView.builder(
              itemCount: itemList!.length,
              itemBuilder: (context, idx) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onDoubleTap: () {
                      Item item = itemList![idx];
                      showDescription(
                          context, item.name, item.price, item.description);
                    },
                    child: Container(
                      height: 150,
                      padding: const EdgeInsets.all(8),
                      color: GlobalVariables.greyBackgroundColor,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            itemList![idx].imageUrl,
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
                                  str: itemList![idx].name,
                                  weight: FontWeight.bold,
                                ),
                                const SizedBox(height: 8),
                                CustomText(
                                  str: "₹ ${itemList![idx].price}",
                                  weight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<dynamic> showDescription(
    BuildContext context,
    String name,
    double price,
    String description,
  ) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("About"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      str: "Name: ",
                      weight: FontWeight.bold,
                    ),
                    Flexible(child: CustomText(str: name))
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const CustomText(
                      str: "Price: ",
                      weight: FontWeight.bold,
                    ),
                    CustomText(str: "₹ ${price.toString()}")
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      str: "Description: ",
                      weight: FontWeight.bold,
                    ),
                    Flexible(child: CustomText(str: description))
                  ],
                ),
              ],
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
}
