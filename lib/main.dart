import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pharmacy_buddy/providers/user_provider.dart';
import 'package:pharmacy_buddy/router.dart';
import 'package:pharmacy_buddy/screens/auth_screen.dart';
import 'package:pharmacy_buddy/screens/admin/admin_screen.dart';
import 'package:pharmacy_buddy/screens/user/user_bottom_bar.dart';
import 'package:pharmacy_buddy/services/auth_service.dart';
import 'package:pharmacy_buddy/utils/constants.dart';
import 'package:provider/provider.dart';

Future main() async {
  await dotenv.load();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  bool load = true;
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    setUser();
  }

  void setUser() async {
    var res = await authService.getUser(context: context);

    setState(() {
      load = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pharmacy Buddy',
        theme: ThemeData(
          scaffoldBackgroundColor: GlobalVariables.backgroundColor,
          colorScheme: const ColorScheme.light(
            primary: GlobalVariables.secondaryColor,
          ),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
          ),
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: (settings) => generateRoute(settings),
        home: load
            ? const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              )
            : Provider.of<UserProvider>(context).user.id.isNotEmpty
                ? Provider.of<UserProvider>(context).user.isAdmin
                    ? const AdminScreen()
                    : const UserBottomBar()
                : const AuthScreen());
  }
}
