// ignore_for_file: camel_case_types, prefer_const_constructors, unnecessary_string_interpolations, prefer_const_literals_to_create_immutables, unused_import, non_constant_identifier_names, prefer_function_declarations_over_variables, unnecessary_brace_in_string_interps, avoid_unnecessary_containers, prefer_final_fields, unused_field

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_app_big/constants/api.dart';
import 'package:project_app_big/constants/color.dart';
import 'package:project_app_big/models/users/user.dart';
import 'package:project_app_big/services/network_servises.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class Profile_Page extends StatefulWidget {
  const Profile_Page({Key? key}) : super(key: key);

  @override
  _Profile_PageState createState() => _Profile_PageState();
}

class _Profile_PageState extends State<Profile_Page> {
  var user = User();
  late int user_id;
  // File สำหรับเก็บไฟล์ เป็นไฟล์ธรรมดา
  // '' หลอกมันว่ามีชื่อไฟล์แล้วนะ เพื่อให้มันเป็น object
  File _imageFile = File('');

  final _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    user_id = ModalRoute.of(context)?.settings.arguments as int;
    return Scaffold(
        backgroundColor: kBGColor,
        appBar: AppBar(
          leading: BackButton(),
          backgroundColor: kMainColor,
          title: Text("แก้ไขข้อมูลส่วนตัว"),
          centerTitle: true,
        ),
        body: FutureBuilder<User>(
          // future คือเรียกการฟีดข้อมูล
          future: NetworkService().getUser_ID(user_id),
          // builder คือผลลัพธ์ที่จะส่งกลับมาให้เรา
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //var data = snapshot.data as List<Product>;
              user = snapshot.data!;
              // ทำการดึงข้อมูลมาใหม่
              return RefreshIndicator(
                child: Container(
                  margin: EdgeInsets.only(
                    top: 10,
                  ),
                  child: _Show_Profile(),
                ),
                onRefresh: () async {
                  setState(() {});
                },
              );
            }
            if (snapshot.hasError) {
              var err = (snapshot.error as DioError).message;
              return Center(
                child: Text(err),
              );
            }
            // คือตัวโหลดตอนเวลาข้อมูลไม่มา
            return Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      backgroundColor: kMainColor,
                      strokeWidth: 8,
                    ),
                  )
                ],
              ),
            );
          },
        ));
  }

  // ชื่อกับอีเมล
  Widget _buildName() => Column(
        children: [
          Text(
            "${user.name}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            "${user.email}",
            style: TextStyle(color: Colors.grey),
          )
        ],
      );

  // ข้อมูลส่วนตัว
  Widget _buildData_Profile() => Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ข้อมูลส่วนตัว',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDataProfile(
              title_Thai: "ชื่อ",
              data: "${user.name}",
              title_En: "name",
            ),
            Divider(
              indent: 6,
              endIndent: 6,
            ),
            _buildDataProfile(
                title_Thai: "อีเมล", data: user.email, title_En: "email"),
            Divider(
              indent: 6,
              endIndent: 6,
            ),
            _buildDataProfile(
                title_Thai: "เบอร์โทร", data: user.tel, title_En: "tel"),
          ],
        ),
      );

  // icon แก้ไขตรงรูปโปรไฟล์
  Widget _buildEditIcon(Color color) => InkWell(
        onTap: () {
          final buildListTile = (String title, dynamic function) => InkWell(
                onTap: function,
                child: Container(
                  margin: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${title}",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              );
          showModalBottomSheet(
            context: context,
            builder: (context) => SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 5,
                  ),
                  //buildListTile("แก้ไข",(){},ImageSource),
                  buildListTile(
                    "ถ่ายภาพ",
                    () {
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  Divider(),
                  buildListTile(
                    "เลือกจากที่มีอยู่",
                    () {
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          );
        },
        child: _buildCircle(
          color: Colors.white,
          all: 3,
          child: _buildCircle(
            color: color,
            all: 8,
            child: Icon(
              Icons.edit,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      );

  Widget _buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );

  // เส่นแบ่งของปุ่มต่างๆ
  Widget _buildDivider() => Container(
        height: 24,
        child: VerticalDivider(),
      );

  // ปุ่มต่างๆ
  Widget _buildButton(BuildContext context, String value, String text) =>
      MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 4),
        onPressed: () {},
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            SizedBox(height: 2),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );

  // ข้อมูลส่วนตัวต่างๆ
  Widget _buildDataProfile(
      {required String title_Thai,
      required String data,
      required String title_En}) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/edit_profile_page",
            arguments: [data, title_Thai, title_En, user.id.toString()]).then(
          (value) => setState(() {}),
        );
      },
      child: Container(
        margin: EdgeInsets.all(3),
        child: Row(
          children: [
            Text(
              title_Thai,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            Spacer(),
            Text(data),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20,
              color: Colors.black54,
            )
          ],
        ),
      ),
    );
  }

  //ส่วนตัวของ sheet
  Widget _buildBodySheet(BuildContext context, SheetState state) {
    return Material(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${user.password}",
                  style: TextStyle(fontSize: 25),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                padding: EdgeInsets.symmetric(
                  horizontal: 40,
                )),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/edit_password', arguments: user)
                  .then((value) => setState(() {}));
            },
            child: Text(
              "เปลี่ยนรหัสผ่าน",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // ส่วนหัวของ sheet
  Widget _buildHeaderSheet(BuildContext context, SheetState state) {
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

  // หน้าโปรไฟล์ทั้งหมด
  Widget _Show_Profile() {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        _bulidImage(),
        const SizedBox(height: 24),
        _buildName(),
        const SizedBox(height: 24),
        _buildButton_Password(),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildButton(context, '4.8', 'Ranking'),
            _buildDivider(),
            _buildButton(context, '35', 'Following'),
            _buildDivider(),
            _buildButton(context, '50', 'Followers'),
          ],
        ),
        const SizedBox(height: 48),
        _buildData_Profile(),
      ],
    );
  }

  // รูปภาพของ User
  Widget _bulidImage() {
    return Center(
      child: Stack(
        children: [
          ClipOval(
            child: Material(
              color: Colors.transparent,
              child: Ink.image(
                image: NetworkImage("${API.BASE_URL}${user.image}"),
                fit: BoxFit.cover,
                width: 128,
                height: 128,
                child: InkWell(onTap: () {}),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 4,
            child: _buildEditIcon(Colors.blue),
          ),
        ],
      ),
    );
  }

  // ปุ่มดูรหัสผ่าน
  Widget _buildButton_Password() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: StadiumBorder(),
          onPrimary: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        ),
        child: Text(
          "ดูรหัสผ่าน",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
        onPressed: () {
          // Sheet แสดงรหัสผ่าน
          showSlidingBottomSheet(
            context,
            builder: (context) => SlidingSheetDialog(
                // กรอบโค้ง
                cornerRadius: 16,
                avoidStatusBar: true,
                snapSpec: SnapSpec(initialSnap: 0.5, snappings: [0.5]),
                builder: _buildBodySheet,
                headerBuilder: _buildHeaderSheet),
          );
        },
      ),
    );
  }

  _pickImage(ImageSource imageSource) async {
    final pickedFile = await _picker.getImage(source: imageSource);
    if (pickedFile != null) {
      File? croppedFile = await ImageCropper()
          .cropImage(
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
      )
          .then((value) async {
        if (value != null) {
          setState(() {
            _imageFile = File(value.path);
          });
          await NetworkService()
              .putUser_image(user_id: user_id, imageFile: _imageFile)
              .then(
                (value) {
                  setState(() {})
                  Navigator.pop(context)
                }
              );
        }
        },
      );
    }
  }
}
