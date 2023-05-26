import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/common-widgets/custom_text.dart';
import 'package:pharmacy_buddy/common-widgets/custom_text_form_field.dart';
import 'package:pharmacy_buddy/models/address.dart';
import 'package:pharmacy_buddy/providers/user_provider.dart';
import 'package:pharmacy_buddy/screens/user/confirm_order_screen.dart';
import 'package:pharmacy_buddy/services/user_service.dart';
import 'package:pharmacy_buddy/utils/constants.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address-screen';
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  List<Address>? addressList;
  late final String userId;
  final UserService _userService = UserService();

  final _newAddressFormKey = GlobalKey<FormState>();
  final TextEditingController _addressLineController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAllAddresses();
  }

  void fetchAllAddresses() async {
    addressList =
        Provider.of<UserProvider>(context, listen: false).user.addresses;
    userId = Provider.of<UserProvider>(context, listen: false).user.id;
    setState(() {});
  }

  @override
  void dispose() {
    _addressLineController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
        ),
      ),
      body: addressList == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (int i = 0; i < addressList!.length; i++) ...[
                      InkWell(
                        onTap: () {
                          showAbout(context, addressList![i]);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: GlobalVariables.secondaryColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: CustomText(
                            str: addressList![i].toString(),
                            weight: FontWeight.w500,
                            size: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (addressList!.isNotEmpty) ...const [
                      CustomText(
                        str: "OR",
                        weight: FontWeight.bold,
                        size: 20,
                      ),
                    ],
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Column(
                        children: [
                          const CustomText(
                            str: "Add new address",
                            weight: FontWeight.bold,
                            size: 16,
                          ),
                          const SizedBox(height: 12),
                          Form(
                            key: _newAddressFormKey,
                            child: Column(
                              children: [
                                CustomTextFormField(
                                  controller: _addressLineController,
                                  hintText: "Address Line",
                                  maxLines: 3,
                                ),
                                const SizedBox(height: 12),
                                CustomTextFormField(
                                  controller: _cityController,
                                  hintText: "City",
                                ),
                                const SizedBox(height: 12),
                                CustomTextFormField(
                                  controller: _stateController,
                                  hintText: "State",
                                ),
                                const SizedBox(height: 12),
                                CustomTextFormField(
                                  controller: _pincodeController,
                                  hintText: "Pincode",
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_newAddressFormKey.currentState!
                                        .validate()) {
                                      Address address = Address(
                                          addressLine:
                                              _addressLineController.text,
                                          city: _cityController.text,
                                          state: _stateController.text,
                                          pincode: _pincodeController.text);
                                      _userService.addNewAddress(
                                          context: context,
                                          userId: userId,
                                          address: address);
                                    }
                                  },
                                  style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(
                                      const Size(25, 50),
                                    ),
                                  ),
                                  child: const Text(
                                    "Proceed",
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

Future<dynamic> showAbout(
  BuildContext context,
  Address address,
) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Address"),
        content: SingleChildScrollView(
          child: CustomText(
            str: address.toString(),
            weight: FontWeight.w500,
            size: 16,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, ConfirmOrderScreen.routeName,
                  arguments: address.toString());
            },
            child: const Text("Proceed"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("CANCEL"),
          ),
        ],
      );
    },
  );
}
