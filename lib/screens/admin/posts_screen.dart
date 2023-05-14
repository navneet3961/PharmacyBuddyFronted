import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/screens/admin/add_product_screen.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  void navigateToAddPrdouctScreen() {
    Navigator.pushNamed(
      context,
      AddProductScreen.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Medicines'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddPrdouctScreen,
        tooltip: "Add a medicine",
        child: const Icon(Icons.add),
      ),
    );
  }
}
