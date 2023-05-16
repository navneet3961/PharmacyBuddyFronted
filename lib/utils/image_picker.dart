import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

Future<File> pickImage() async {
  File? image;

  try {
    var file = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);

    if (file != null && file.files.isNotEmpty) {
      image = File(file.files.single.path!);
    }
  } catch (e) {
    debugPrint(e.toString());
  }

  return image!;
}
