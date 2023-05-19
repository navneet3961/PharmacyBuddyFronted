import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/models/item.dart';
import 'package:pharmacy_buddy/screens/user/search_screen.dart';
import 'package:pharmacy_buddy/screens/widgets/item_card.dart';
import 'package:pharmacy_buddy/screens/widgets/search_box.dart';
import 'package:pharmacy_buddy/services/user_service.dart';
import 'package:pharmacy_buddy/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Item>? itemList;
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    fetchAllItems();
  }

  void fetchAllItems() async {
    itemList = await _userService.fetchAllItems(context: context, keyword: "");
    setState(() {});
  }

  void navigateToSearchScreen(String keyword) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: keyword);
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
              ? const Center(child: Text("No items found"))
              : ListView.builder(
                  itemCount: itemList!.length,
                  itemBuilder: (context, idx) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ItemCard(item: itemList![idx]),
                    );
                  },
                ),
    );
  }
}
