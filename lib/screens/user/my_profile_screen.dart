import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/common-widgets/custom_password_text_form_field.dart';
import 'package:pharmacy_buddy/common-widgets/custom_text.dart';
import 'package:pharmacy_buddy/common-widgets/custom_text_form_field.dart';
import 'package:pharmacy_buddy/models/user.dart';
import 'package:pharmacy_buddy/services/auth_service.dart';
import 'package:pharmacy_buddy/utils/constants.dart';
import 'package:pharmacy_buddy/utils/snackbar.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';

enum Profile { details, password }

class MyProfileScreen extends StatefulWidget {
  static const String routeName = '/my-profile-screen';
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  Profile _profile = Profile.details;
  final _detailsFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  User user = User.empty();
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() {
    user = Provider.of<UserProvider>(context, listen: false).user;

    _nameController.text = user.name;
    _emailController.text = user.email;

    setState(() {});
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void updateUserInDatabase(String name, String email, String password) {
    _auth.updateUser(
      context: context,
      userId: user.id,
      name: name,
      email: email,
      password: password,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          centerTitle: true,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: const CustomText(
            str: "My Profile",
            size: 24,
            weight: FontWeight.w400,
          ),
        ),
      ),
      backgroundColor: GlobalVariables.greyBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: RadioListTile(
                        tileColor: _profile == Profile.details
                            ? GlobalVariables.backgroundColor
                            : GlobalVariables.greyBackgroundColor,
                        activeColor: GlobalVariables.secondaryColor,
                        title: const CustomText(
                          str: "Update Profile",
                          weight: FontWeight.bold,
                        ),
                        value: Profile.details,
                        groupValue: _profile,
                        onChanged: (Profile? val) {
                          setState(() {
                            _profile = val!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        tileColor: _profile == Profile.password
                            ? GlobalVariables.backgroundColor
                            : GlobalVariables.greyBackgroundColor,
                        activeColor: GlobalVariables.secondaryColor,
                        title: const CustomText(
                          str: "Change Password",
                          weight: FontWeight.bold,
                        ),
                        value: Profile.password,
                        groupValue: _profile,
                        onChanged: (Profile? val) {
                          setState(() {
                            _profile = val!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                  color: GlobalVariables.backgroundColor,
                  padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
                  child: _profile == Profile.details
                      ? Form(
                          key: _detailsFormKey,
                          child: Column(
                            children: [
                              CustomTextFormField(
                                controller: _nameController,
                                hintText: "Name",
                              ),
                              const SizedBox(height: 12),
                              CustomTextFormField(
                                controller: _emailController,
                                hintText: "Email",
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () async {
                                  if (_detailsFormKey.currentState!
                                      .validate()) {
                                    updateUserInDatabase(_nameController.text,
                                        _emailController.text, "");
                                  }
                                },
                                style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all(
                                    const Size(25, 50),
                                  ),
                                ),
                                child: const Text(
                                  "Update Profile",
                                ),
                              ),
                            ],
                          ),
                        )
                      : Form(
                          key: _passwordFormKey,
                          child: Column(
                            children: [
                              CustomPasswordTextFormField(
                                controller: _passwordController,
                                hintText: "Password",
                              ),
                              const SizedBox(height: 12),
                              CustomPasswordTextFormField(
                                controller: _confirmPasswordController,
                                hintText: "Confirm Password",
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () async {
                                  if (_passwordController.text.compareTo(
                                          _confirmPasswordController.text) !=
                                      0) {
                                    showSnackBar(
                                      context,
                                      "Password and Confirm Password are not same.",
                                    );
                                  } else if (_passwordFormKey.currentState!
                                      .validate()) {
                                    updateUserInDatabase(
                                        "", "", _passwordController.text);
                                  }
                                },
                                style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all(
                                    const Size(25, 50),
                                  ),
                                ),
                                child: const Text(
                                  "Change Password",
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                const SizedBox(height: 12),
                if (_profile == Profile.password) ...const [
                  CustomText(str: "* Pasword must be between 8-12 digits"),
                  CustomText(str: "* Pasword must have a special character"),
                  CustomText(str: "* Pasword must have a lowercase character"),
                  CustomText(str: "* Pasword must have a uppercase character"),
                  CustomText(str: "* Pasword must have a digit"),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
