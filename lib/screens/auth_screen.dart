import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/common-widgets/custom_password_text_form_field.dart';
import 'package:pharmacy_buddy/common-widgets/custom_text.dart';
import 'package:pharmacy_buddy/common-widgets/custom_text_form_field.dart';
import 'package:pharmacy_buddy/services/auth_service.dart';
import 'package:pharmacy_buddy/utils/constants.dart';
import 'package:pharmacy_buddy/utils/snackbar.dart';

enum Auth { signIn, signUp }

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Auth _auth = Auth.signIn;
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AuthService auth = AuthService();

  void singUpUser() {
    auth.signUpUser(
      context: context,
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  void singInUser() {
    auth.signInUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.greyBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const CustomText(
                  str: "Welcome",
                  size: 30,
                  weight: FontWeight.w600,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: RadioListTile(
                        tileColor: _auth == Auth.signUp
                            ? GlobalVariables.backgroundColor
                            : GlobalVariables.greyBackgroundColor,
                        activeColor: GlobalVariables.secondaryColor,
                        title: const CustomText(
                          str: "Create Account",
                          weight: FontWeight.bold,
                        ),
                        value: Auth.signUp,
                        groupValue: _auth,
                        onChanged: (Auth? val) {
                          setState(() {
                            _auth = val!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        tileColor: _auth == Auth.signIn
                            ? GlobalVariables.backgroundColor
                            : GlobalVariables.greyBackgroundColor,
                        activeColor: GlobalVariables.secondaryColor,
                        title: const CustomText(
                          str: "Sign-In",
                          weight: FontWeight.bold,
                        ),
                        value: Auth.signIn,
                        groupValue: _auth,
                        onChanged: (Auth? val) {
                          setState(() {
                            _auth = val!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                  color: GlobalVariables.backgroundColor,
                  padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
                  child: _auth == Auth.signUp
                      ? Form(
                          key: _signUpFormKey,
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
                                  } else if (_signUpFormKey.currentState!
                                      .validate()) {
                                    singUpUser();
                                  }
                                },
                                style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all(
                                    const Size(25, 50),
                                  ),
                                ),
                                child: const Text(
                                  "Sign-Up",
                                ),
                              ),
                            ],
                          ),
                        )
                      : Form(
                          key: _signInFormKey,
                          child: Column(
                            children: [
                              CustomTextFormField(
                                controller: _emailController,
                                hintText: "Email",
                              ),
                              const SizedBox(height: 12),
                              CustomPasswordTextFormField(
                                controller: _passwordController,
                                hintText: "Password",
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () {
                                  if (_signInFormKey.currentState!.validate()) {
                                    singInUser();
                                  }
                                },
                                style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all(
                                    const Size(25, 50),
                                  ),
                                ),
                                child: const Text(
                                  "Sign-In",
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
