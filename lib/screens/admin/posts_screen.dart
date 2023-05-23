import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/models/item.dart';
import 'package:pharmacy_buddy/screens/admin/add_item_screen.dart';
import 'package:pharmacy_buddy/screens/admin/update_item_screen.dart';
import 'package:pharmacy_buddy/screens/widgets/item_card.dart';
import 'package:pharmacy_buddy/services/admin_service.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final AdminService _adminService = AdminService();
  static const List<String> _options = ["All", "Out of Stock", "In Stock"];
  int _value = 0;
  List<Item>? itemList;

  void navigateToAddItemScreen() {
    Navigator.pushNamed(
      context,
      AddItemScreen.routeName,
    );
  }

  void navigateToUpdateItemScreen(Item item) {
    Navigator.popAndPushNamed(
      context,
      UpdateItemScreen.routeName,
      arguments: item,
    );
  }

  @override
  void initState() {
    fetchAllItems();
    super.initState();
  }

  void fetchAllItems() async {
    itemList = await _adminService.fetchAllItems(context: context);
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
              const Text("Show results by stock: "),
              DropdownButton(
                  value: _value,
                  items: [0, 1, 2]
                      .map((e) =>
                          DropdownMenuItem(value: e, child: Text(_options[e])))
                      .toList(),
                  onChanged: (value) async {
                    _value = value!;
                    itemList = value == 0
                        ? await _adminService.fetchAllItems(context: context)
                        : await _adminService.fetchAllItems(
                            context: context, inStock: value - 1);

                    setState(() {});
                  }),
            ],
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
                  child: Dismissible(
                    confirmDismiss: (DismissDirection direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirm"),
                            content: direction == DismissDirection.startToEnd
                                ? const Text(
                                    "Are you sure you want to edit this item?")
                                : const Text(
                                    "Are you sure you want to delete this item?"),
                            actions: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  direction == DismissDirection.startToEnd
                                      ? navigateToUpdateItemScreen(
                                          itemList![idx])
                                      : Navigator.of(context).pop(true);
                                },
                                child: direction == DismissDirection.startToEnd
                                    ? const Text("EDIT")
                                    : const Text("DELETE"),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("CANCEL"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    background: Container(
                      alignment: Alignment.centerLeft,
                      color: Colors.blue,
                      child: const Icon(
                        Icons.edit_document,
                        size: 50,
                      ),
                    ),
                    secondaryBackground: Container(
                      alignment: Alignment.centerRight,
                      color: Colors.red,
                      child: const Icon(
                        Icons.delete_forever,
                        size: 50,
                      ),
                    ),
                    onDismissed: (direction) {
                      // DELETE
                      if (direction == DismissDirection.endToStart) {
                        _adminService.deleteItem(
                            context: context, id: itemList![idx].id);

                        itemList!.removeAt(idx);
                      }

                      setState(() {});
                    },
                    key: Key(itemList![idx].id),
                    child: ItemCard(item: itemList![idx]),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddItemScreen,
        tooltip: "Add a medicine",
        child: const Icon(Icons.add),
      ),
    );
  }
}
