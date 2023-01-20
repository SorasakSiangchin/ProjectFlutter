// ignore_for_file: prefer_const_constructors, camel_case_types, unused_field, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_app_big/constants/api.dart';
import 'package:project_app_big/constants/color.dart';
import 'package:project_app_big/models/list.dart';
import 'package:project_app_big/services/network_servises.dart';

class Review_Product extends StatefulWidget {
  const Review_Product({ Key? key }) : super(key: key);

  @override
  _Review_ProductState createState() => _Review_ProductState();
}

class _Review_ProductState extends State<Review_Product> {
  final _formKey = GlobalKey<FormState>();
    File _imageFile = File('');
    String data_Review = "";
  final _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    Lists list_data = ModalRoute.of(context)?.settings.arguments as Lists;
    return Scaffold(
      backgroundColor: kBGColor,
      appBar: AppBar(
        title: Text("เพิ่มข้อมูล"),
        backgroundColor: kMainColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: (){
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    setState(
                      () {},
                    );
                    FocusScope.of(context).requestFocus(
                      FocusNode(),
                    );
                    
                     NetworkService()
                        .postReviewProduct(
                            List: list_data,
                            imageFile: _imageFile,
                            dataReview: data_Review)
                        .then((value) {
                      if (value == API.OK) {
                        CoolAlert.show(
                          context: context,
                          type: CoolAlertType.success,
                          text: "บันทึกเรียบร้อย",
                        ).then(
                          (value) => Navigator.pop(context),
                        );
                      }else{
                        CoolAlert.show(
                          context: context,
                          type: CoolAlertType.error,
                          text: value ,
                        );
                      }
                    }
                        );
                  }
                },
                child: Text(
                  "ยืนยัน",
                  style: TextStyle(
                    color: kMain1Color,
                    fontSize: 15
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
                    padding: EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                    _imageFile.path.isEmpty? _upload_Image() : 
                     _buildPreviewImage(),
                     SizedBox(
                       height: 20,
                     ),
                    TextFormField(
                       keyboardType: TextInputType.multiline,
      maxLines: 5,
                        decoration: InputDecoration(
                          
                          labelText: 'ข้อมูล',
                          border: OutlineInputBorder(),
                          // errorBorder:
                          //     OutlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
                          // focusedErrorBorder:
                          //     OutlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
                          // errorStyle: TextStyle(color: Colors.purple),
                        ),
                        validator: (value) {
                          if (value!.length < 4) {
                            return 'กรุณากรอกข้อมูล';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) => setState(() {
                          data_Review = value!;
                        }),),
                  ],
                ),
            ),
          ),
        ),
      )
    );
  }
  
  _pickImage(ImageSource imageSource) async {
    final pickedFile = await _picker.getImage(source: imageSource);
    if (pickedFile != null) {
      File? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'แก้ไขรูปภาพ',
          toolbarColor: kBG1Color,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: kBG1Color,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      );
      if (croppedFile != null) {
        setState(() {
          _imageFile = File(croppedFile.path);
        });
      }
    }
  }
  _modalPickerImage() {
    //ignore: prefer_function_declarations_over_variables
    final buildListTile =
        (IconData icon, String title, ImageSource imageSource) => ListTile(
              style:ListTileStyle.list ,
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
  
    // ที่ show รูป
  _buildPreviewImage() {
    dynamic _image;
    if (_imageFile.path.isNotEmpty) {
      _image = DottedBorder(
        color: Colors.blue,
        strokeWidth: 4,
        borderType: BorderType.RRect,
        dashPattern: [12, 9],
        strokeCap: StrokeCap.round,
        child: Image.file(
          _imageFile,
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width / 1.5,
          height: MediaQuery.of(context).size.height / 2.5,
        ),
      );
    }
    return _image;
  }

  Widget _upload_Image() {
    return Container(
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 60),
      child: DottedBorder(
        child: InkWell(
          onTap: () {
           _modalPickerImage();
          },
          child:  Container(
            width: 150,
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_upload_sharp,
                  color: Colors.blue,
                  size: 60,
                ),
                Text(
                  "กดเพื่อเพิ่ม",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
        color: Colors.blue,
        strokeWidth: 4,
        borderType: BorderType.RRect,
        dashPattern: [12, 9],
        strokeCap: StrokeCap.round,
      ),
    );
  }
  
}