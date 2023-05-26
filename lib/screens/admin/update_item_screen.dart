import 'package:flutter/material.dart';
import 'package:pharmacy_buddy/common-widgets/custom_text.dart';
import 'package:pharmacy_buddy/common-widgets/custom_text_form_field.dart';
import 'package:pharmacy_buddy/models/item.dart';
import 'package:pharmacy_buddy/services/admin_service.dart';
import 'package:pharmacy_buddy/utils/constants.dart';
import 'package:pharmacy_buddy/utils/snackbar.dart';

class UpdateItemScreen extends StatefulWidget {
  final Item item;
  static const String routeName = '/update-item-screen';
  const UpdateItemScreen({super.key, required this.item});

  @override
  State<UpdateItemScreen> createState() => _UpdateItemScreenState();
}

class _UpdateItemScreenState extends State<UpdateItemScreen> {
  late final String _id;
  late final String _imageUrl;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final _addItemFromKey = GlobalKey<FormState>();
  final AdminService _adminService = AdminService();

  @override
  void initState() {
    Item item = widget.item;
    _id = item.id;
    _imageUrl = item.imageUrl;
    _nameController.text = item.name;
    _descriptionController.text = item.description;
    _priceController.text = item.price.toString();
    _quantityController.text = item.quantity.toString();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void updateItemToDatabase() {
    if (_addItemFromKey.currentState!.validate()) {
      _adminService.updateItem(
          context: context,
          id: _id,
          name: _nameController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          quantity: int.parse(_quantityController.text),
          imageUrl: _imageUrl);
    } else {
      showSnackBar(context, "Something went wrong");
    }
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
            str: "Update Medicine",
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
                Image.network(
                  _imageUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.fill,
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
                  maxLines: 10,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: updateItemToDatabase,
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                          const Size(25, 50),
                        ),
                      ),
                      child: const Text(
                        "Update Item",
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                          const Size(25, 50),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
