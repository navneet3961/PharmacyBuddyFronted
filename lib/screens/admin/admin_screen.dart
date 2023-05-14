import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/common-widgets/bottom_bar_item.dart';
import 'package:pharmacy_buddy/screens/admin/posts_screen.dart';
import 'package:pharmacy_buddy/utils/constants.dart';

enum BarItem { posts, analytics, inbox }

class AdminScreen extends StatefulWidget {
  static const String routeName = '/admin-screen';
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _page = BarItem.posts.index;

  List<Widget> pages = [
    const PostsScreen(),
    const Center(
      child: Text("Analytics Page"),
    ),
    const Center(
      child: Text("Inbox Page"),
    ),
  ];

  void updatePages(int page) {
    setState(() {
      _page = page;
    });
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.network(
                'assets/images/logo.png',
                height: 50,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: const Text(
                  "Admin",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
        onTap: updatePages,
        items: [
          barItems(_page, BarItem.posts.index, Icons.home_outlined),
          barItems(_page, BarItem.analytics.index, Icons.analytics_outlined),
          barItems(_page, BarItem.inbox.index, Icons.all_inbox_outlined),
        ],
      ),
    );
  }
}
