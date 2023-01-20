// ignore_for_file: prefer_const_declarations

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Utils {
  static Future<File?> pickMedia({
    required Future<File?> Function(File file) cropImage,
  }) async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile == null) return File('');

    if (cropImage == null) {
      return File(pickedFile.path);
    } else {
      final file = File(pickedFile.path);

      return cropImage(file);
    }
  }
}

