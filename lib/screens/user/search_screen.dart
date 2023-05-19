import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/models/item.dart';
import 'package:pharmacy_buddy/screens/widgets/item_card.dart';
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
