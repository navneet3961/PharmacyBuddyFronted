import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/common-widgets/custom_text.dart';
import 'package:pharmacy_buddy/common-widgets/custom_text_form_field.dart';
import 'package:pharmacy_buddy/utils/constants.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = '/add-product-screen';
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
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
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    print("Hello");
                  },
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
