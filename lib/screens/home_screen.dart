import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/common-widgets/bottom_bar.dart';
import 'package:pharmacy_buddy/providers/user_provider.dart';
import 'package:provider/provider.dart';
// import 'package:pharmacy_buddy/providers/user_provider.dart';
// import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Center(
      child: Text(user.toString()),
    );
  }
}
