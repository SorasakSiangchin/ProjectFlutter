// ignore_for_file: prefer_const_constructors, unused_local_variable, non_constant_identifier_names, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, unused_field, prefer_final_fields, unused_element, unnecessary_null_comparison, deprecated_member_use

import 'dart:io';
import 'dart:typed_data';

import 'package:cool_alert/cool_alert.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:project_app_big/constants/api.dart';
import 'package:project_app_big/constants/color.dart';
import 'package:project_app_big/models/order.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_app_big/services/network_servises.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
class Payment_Data extends StatefulWidget {
  const Payment_Data({Key? key}) : super(key: key);

  @override
  State<Payment_Data> createState() => _Payment_DataState();
}

class _Payment_DataState extends State<Payment_Data> {
  // File สำหรับเก็บไฟล์ เป็นไฟล์ธรรมดา
  // '' หลอกมันว่ามีชื่อไฟล์แล้วนะ เพื่อให้มันเป็น object
  File _imageFile = File('');
  final _picker = ImagePicker();
    final url =
      "assets/images/qrCode.png";
  _save() async {
    var status = await Permission.storage.request();
    if(status.isGranted){
 var response = await Dio()
        .get(
        "https://i.ibb.co/ysVC5K3/S-2088970.jpg",
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: "qr-code-sorasak");
    }
   
  }
  @override
  Widget build(BuildContext context) {
    Order data_order = ModalRoute.of(context)?.settings.arguments as Order;
    return Scaffold(
      backgroundColor: kBGColor,
      appBar: AppBar(
        title: Text("ข้อมูลการชำระเงิน"),
        backgroundColor: kMainColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: _SheetQR_Code,
            icon: Image.asset(
              "assets/icons/qr-code.png",
              color: Colors.white,
              width: 90,
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: Column(
        children: [
          buildTitle_PriceTotal(data_order),
          buildBankData(data_order),
          buildUpload_Title(),
          _imageFile.path.isEmpty ? buildUpload_Data() : _buildPreviewImage(),
          Spacer(),
          buildButton_Confirm(data_order),
          SizedBox(
            height: 10,
          )
        ],
      )),
    );
  }

  _modalPickerImage() {
    //ignore: prefer_function_declarations_over_variables
    final buildListTile =
        (IconData icon, String title, ImageSource imageSource) => ListTile(
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
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.green[700],
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: Colors.green[700],
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

  // ที่ show รูป
  _buildPreviewImage() {
    dynamic _image;
    if (_imageFile.path.isNotEmpty) {
      _image = Container(
        padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
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

  // ราคารวมที่ต้องจ่าย
  Widget buildTitle_PriceTotal(Order data_order) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      color: kBG1Color,
      child: Row(
        children: [
          Text(
            "ยอดชำระเงินทั้งหมด",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Text(
            "฿ ${data_order.priceTotal}",
            style: TextStyle(
              fontSize: 17,
              color: kMain1Color,
            ),
          ),
        ],
      ),
    );
  }

  // ข้อมูลบัญชีธนาคาร
  Widget buildBankData(Order data_order) {
    return Container(
      color: kBG1Color,
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 60),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(),
                child: Text(
                  "ออมสิน (Government Savings Bank)",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(),
                child: Text(
                  "ชื่อบัญชี : สรศักดิ์ เซี่ยงฉิน",
                ),
              )
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Container(
                child: Text(
                  "เลขที่บัญชี : ",
                ),
              ),
              Container(
                child: Text(
                  "020094178215",
                  style: TextStyle(color: kMain1Color, fontSize: 20),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  // ข้อความ upload
  Widget buildUpload_Title() {
    return Container(
      margin: EdgeInsets.only(top: 25),
      child: Row(
        children: [
          SizedBox(
            width: 6,
          ),
          Text(
            "อัพโหลดหลักฐานการชำระเงิน :",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Spacer(),
          _imageFile.path.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    _modalPickerImage();
                  },
                  child: Icon(Icons.mode_edit_sharp),
                )
              : SizedBox(),
          SizedBox(
            width: 6,
          ),
        ],
      ),
    );
  }

  // ปุ่มส่งหลักฐาน
  Widget buildButton_Confirm(Order data_order) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      color: kBG1Color,
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          primary: kMain1Color,
        ),
        child: Text(
          'ส่ง',
          style: TextStyle(fontSize: 18),
        ),
        onPressed: () async {
          if(_imageFile.path.isNotEmpty){
 var result = await NetworkService()
              .putOrder_Upload(data_order, imageFile: _imageFile);
          if (result == API.OK) {
            CoolAlert.show(
              context: context,
              type: CoolAlertType.success,
              title: "ส่งหลักฐานเรียบร้อย",
              confirmBtnText: "ตกลง"
            ).then((value) => Navigator.pop(context));
          } else {
            CoolAlert.show(
              context: context,
              type: CoolAlertType.error,
              title: result,
              confirmBtnText: "ตกลง"
            );
          }
          }else{
           CoolAlert.show(
              context: context,
              type: CoolAlertType.warning,
              title: "กรุณาเพิ่มหลักฐานการชำระเงิน",
              confirmBtnText: "ตกลง"
            );
          }
         
        },
      ),
    );
  }

  // ที่ Upload หลังฐานการชำระเงิน
  Widget buildUpload_Data() {
    return Container(
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 60),
      child: DottedBorder(
        child: InkWell(
          onTap: () {
            _modalPickerImage();
          },
          child: Container(
            width: 150,
            height: 150,
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

  _SheetQR_Code() {
    showSlidingBottomSheet(
      context,
      builder: (context) => SlidingSheetDialog(
          // กรอบโค้ง
          cornerRadius: 16,
          avoidStatusBar: true,
          snapSpec: SnapSpec(initialSnap: 0.7, snappings: [0.7]),
          builder: buildBodySheet,
          headerBuilder: buildHeaderSheet),
    );
  }

  Widget buildBodySheet(BuildContext context, SheetState state) {
    return Material(
      child: ListView(
        padding: EdgeInsets.all(16),
        shrinkWrap: true,
        primary: false,
        children: [
          Image.asset(
            "assets/images/qrCode.png",
            width: 350,
            height: 350,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 131),
            child: FlatButton(
              color: kBG1Color,
              onPressed: () {
                _save();
              },
              child: Row(
                children: [
                  Text(
                    "บันทึก",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Image.asset(
                    "assets/icons/download.png",
                    width: 25,
                    height: 25,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeaderSheet(BuildContext context, SheetState state) {
    return Container(
      width: double.infinity,
      color: kMainColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 16,
          ),
          Container(
            width: 32,
            height: 8,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.white),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

}
