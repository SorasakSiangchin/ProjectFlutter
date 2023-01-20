// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:project_app_big/constants/color.dart';

class Edit_Image_Page extends StatefulWidget {
  const Edit_Image_Page({ Key? key }) : super(key: key);

  @override
  State<Edit_Image_Page> createState() => _Edit_Image_PageState();
}

class _Edit_Image_PageState extends State<Edit_Image_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBGColor,
      appBar: AppBar(
         leading: BackButton(),
          backgroundColor: kMainColor,
          title: Text("เปลี่ยนรหัสผ่าน"),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: _OnSubmit,
              child: Text(
                "บันทึก",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
      ),
      body: SafeArea(
        child: Text("Edit_Image_Page"),
      ),
    );
  }

  void _OnSubmit() {
  }
}