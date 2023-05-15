import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/common-widgets/custom_text.dart';
import 'package:pharmacy_buddy/common-widgets/custom_text_form_field.dart';
import 'package:pharmacy_buddy/services/admin_service.dart';
import 'package:pharmacy_buddy/utils/constants.dart';
import 'package:pharmacy_buddy/utils/image_picker.dart';
import 'package:pharmacy_buddy/utils/snackbar.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = '/add-product-screen';
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  File? image;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final _addItemFromKey = GlobalKey<FormState>();
  final AdminService _adminService = AdminService();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void addItemToDatabase() {
    if (_addItemFromKey.currentState!.validate() && image != null) {
      _adminService.addItem(
          context: context,
          name: _nameController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          quantity: int.parse(_quantityController.text),
          image: image!);
    } else {
      showSnackBar(context, "Something went wrong");
    }
  }

  void selectImage() async {
    var res = await pickImage();

    setState(() {
      image = res;
    });
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
            str: "Add Medicine",
            size: 24,
            weight: FontWeight.w400,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _addItemFromKey,
            child: Column(
              children: [
                image != null
                    ? Image.file(
                        image!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.fill,
                      )
                    : GestureDetector(
                        onTap: selectImage,
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.folder_open,
                                size: 30,
                              ),
                              SizedBox(height: 12),
                              Text("Select Medicine Image"),
                            ],
                          ),
                        ),
                      ),
                const SizedBox(height: 12),
                CustomTextFormField(
                  controller: _nameController,
                  hintText: "Name",
                ),
                const SizedBox(height: 12),
                CustomTextFormField(
                  controller: _descriptionController,
                  hintText: "Description",
                  maxLines: 5,
                  maxLength: 250,
                  counterText: null,
                ),
                const SizedBox(height: 12),
                CustomTextFormField(
                  controller: _priceController,
                  hintText: "Price",
                ),
                const SizedBox(height: 12),
                CustomTextFormField(
                  controller: _quantityController,
                  hintText: "Quantity",
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: addItemToDatabase,
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                      const Size(25, 50),
                    ),
                  ),
                  child: const Text(
                    "Add Item",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
