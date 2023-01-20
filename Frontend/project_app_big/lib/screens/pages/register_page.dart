// ignore_for_file: missing_return, unnecessary_statements, non_constant_identifier_names, unused_field, unused_import, prefer_const_constructors, camel_case_types, duplicate_ignore

import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project_app_big/constants/api.dart';
import 'package:project_app_big/models/users/user.dart';
import 'package:project_app_big/services/network_servises.dart';
import 'package:validators/validators.dart';
import 'package:image_picker/image_picker.dart';
class Register_Page extends StatefulWidget {
  const Register_Page({Key? key}) : super(key: key);

  @override
  _Register_PageState createState() => _Register_PageState();
}

class _Register_PageState extends State<Register_Page> {
  final _formKey = GlobalKey<FormState>();
  var isLogin = false;
  //---------- จัดการรูปภาพ -----------
  File _imageFile = File('');
  final _picker = ImagePicker();
  //---------------------------------
  var user = User();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade800,
                  Colors.blue.shade600,
                ],
                begin: Alignment.topLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 60),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  size: 40.0,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "สมัครสมาชิก",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 46.0,
                                    fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: ListView(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(40),
                                  topLeft: Radius.circular(40))),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _IDinput(),
                                SizedBox(
                                  height: 20.0,
                                ),
                                _Nameinput(),
                                SizedBox(
                                  height: 20.0,
                                ),
                                _Emailinput(),
                                SizedBox(
                                  height: 20.0,
                                ),
                                _Passwordinput(),
                                SizedBox(
                                  height: 20.0,
                                ),
                                _Telinput(),
                                  SizedBox(
                                  height: 20.0,
                                ),
                                _Imageinput(),
                                SizedBox(
                                  height: 50,
                                ),
                                _BuildButton(),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _BuildButton() {
    return Container(
      width: double.infinity,
      // ignore: deprecated_member_use
      child: RaisedButton(
        onPressed: _OnSubmit,
        color: Colors.blue[800],
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            "บันทึก",
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
        ),
      ),
    );
  }

  _OnSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(
        () {},
      );
      FocusScope.of(context).requestFocus(FocusNode());
      NetworkService()
          .register(user,imageFile: _imageFile)
          .then(
            (value) => _goToWeb(value),
          ).onError(
            (error, stackTrace) => {
              print(
                (error as DioError).message,
              ),
            },
          );

    }
  }

  _goToWeb(String value) {
    if (value == API.OK) {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: "บันทึกเรียบร้อย",
      ).then((value) => {
            Navigator.pop(context)
          });
    } else {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: value ,
      );
    }
  }

  Widget _IDinput() {
    return TextFormField(
      //initialValue: user.password,
      //obscureText: true,
      keyboardType: TextInputType.number,
      onSaved: (value) {
        user.id = int.parse(value!);
      },
      validator: (value) {
        if (value == null || value.isEmpty || !isInt(value)) {
          return 'กรุณกรอกข้อมูล';
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none),
        // เติมให้เต็ม
        filled: true,
        //และเติมสี
        fillColor: Color(0xFFe7edeb),
        hintText: "รหัสประจำตัว",
        // prefixIcon: Icon(
        //   Icons.password_sharp,
        //   color: Colors.grey[600],
        // ),
      ),
    );
  }

  Widget _Nameinput() {
    return TextFormField(
      //initialValue: user.email,
      keyboardType: TextInputType.name,
      onSaved: (value) {
        user.name = value!;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณกรอกข้อมูล';
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none),
        // เติมให้เต็ม
        filled: true,
        //และเติมสี
        fillColor: Color(0xFFe7edeb),
        hintText: "ชื่อ",
      ),
    );
  }

  Widget _Emailinput() {
    return TextFormField(
      initialValue: user.email,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        user.email = value!;
      },
      validator: (value) {
        if (!isEmail(value!)) {
          return "กรุณาพิมพ์ให้อยู่ในรูปแบบอีเมล";
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none),
        // เติมให้เต็ม
        filled: true,
        //และเติมสี
        fillColor: Color(0xFFe7edeb),
        hintText: "อีเมล",
      ),
    );
  }

  Widget _Passwordinput() {
    return TextFormField(
      //initialValue: user.password,
      // obscureText: true,
      keyboardType: TextInputType.number,
      onSaved: (value) {
        user.password = value!;
      },
      validator: (value) {
        if (value!.length < 5) {
          return "กรุณาใส่ข้อมูลให้ถูกต้อง";
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none),
        // เติมให้เต็ม
        filled: true,
        //และเติมสี
        fillColor: Color(0xFFe7edeb),
        hintText: "รหัสผ่าน",
      ),
    );
  }


  Widget _Telinput() {
    return TextFormField(
      //initialValue: user.email,
      keyboardType: TextInputType.number,
      onSaved: (value) {
        user.tel = value!;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณกรอกข้อมูล';
        }
       
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none),
        // เติมให้เต็ม
        filled: true,
        //และเติมสี
        fillColor: Color(0xFFe7edeb),
        hintText: "เบอร์โทร",
      ),
    );
  }

  Widget _Imageinput() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPickerImage(),
          _buildPreviewImage(),
        ],
      ),
    );
  }
    // ปุ่มใส่รูป
  OutlinedButton _buildPickerImage() => OutlinedButton.icon(
        onPressed: () {
          _modalPickerImage();
        },
        label: Text('image'),
        icon: Icon(Icons.image),
      );

  void _modalPickerImage() {
    //ignore: prefer_function_declarations_over_variables
    final buildListTile = (IconData icon, String title, ImageSource imageSource) => ListTile(
              leading: Icon(icon),
              title: Text(title),
              onTap: () {
                Navigator.pop(context);
                _pickImage(imageSource);
              },
              
            );
            showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            buildListTile(
              Icons.photo_camera,
              "Take a picture from camera",
              ImageSource.camera,
            ),
            buildListTile(
              Icons.photo_library,
              "Choose from photo library",
              ImageSource.gallery,
            ),
          ],
        ),
      ),
    );
  }

  
void _pickImage(ImageSource imageSource) {
    _picker
        .pickImage(
      source: imageSource,
      imageQuality: 70,
      maxHeight: 500,
      maxWidth: 500,
    )
        .then((file) {
      if (file != null) {
        setState(() {
          _imageFile = File(file.path);
        });
      }
    });
  }

  _buildPreviewImage() {
    dynamic _image;
    if (_imageFile.path.isNotEmpty) {
      _image = Image.file(_imageFile);
    } 
    return Container(
      color: Colors.grey[100],
      margin: EdgeInsets.only(top: 4),
      alignment: Alignment.center,
      height: 200,
      child: _image,
    );
  }
}
