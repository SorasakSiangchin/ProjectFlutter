// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, curly_braces_in_flow_control_structures, camel_case_types

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:project_app_big/constants/color.dart';
import 'package:project_app_big/models/users/user.dart';
import 'package:project_app_big/services/network_servises.dart';
import 'package:validators/validators.dart';



class Edit_Password_Page extends StatefulWidget {
  const Edit_Password_Page({Key? key}) : super(key: key);

  @override
  State<Edit_Password_Page> createState() => _Edit_Password_PageState();
}

class _Edit_Password_PageState extends State<Edit_Password_Page> {
  final _formKey = GlobalKey<FormState>();
  String new_password = "";
  late User data;
  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)?.settings.arguments as User;
    return Form(
      key: _formKey,
      child: Scaffold(
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
            child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                _old_Password(),
                SizedBox(
                  height: 28,
                ),
                _new_Password()
              ],
            ),
          ),
        )),
      ),
    );
  }

  Widget _old_Password() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "รหัสผ่านเดิม",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          keyboardType: TextInputType.text,
          onSaved: (value) {},
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            // suffixIcon: Icon(
            //   Icons.error,
            // ),
            helperText: 'ใส่รหัสผ่านเดิม',
          ),
          validator: (value) {
            if (value == data.password) {
              return null;
            } else {
              return "รหัสผ่านไม่ถูกต้อง";
            }
          },
        ),
      ],
    );
  }

  Widget _new_Password() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "รหัสผ่านใหม่",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          // onSaved: (value) {
          //   new_password = value!;
          // },
          decoration: InputDecoration(
            helperText: 'ใส่รหัสผ่านใหม่',
            border: OutlineInputBorder(),
            // suffixIcon: Icon(
            //   Icons.error,
            // ),
          ),
          onChanged: (value) {
            setState(() {
              new_password = value;
            });
          },
          validator: (value) {
            if (value!.isEmpty) {
              return "กรุณากรอกข้อมูล";
            } else {
              return null;
            }
          },
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          onSaved: (value) {
            setState(() {
              new_password = value!;
            });
          },
          decoration: InputDecoration(
            helperText: 'ยืนยันรหัสผ่าน',
            border: OutlineInputBorder(),
            // suffixIcon: Icon(
            //   Icons.error,
            // ),
          ),
          validator: (value) {
            if (value == new_password) {
              return null;
            } else {
              return "รหัสผ่านไม่ถูกต้อง";
            }
          },
        ),
      ],
    );
  }

  _OnSubmit() {
    if (!_formKey.currentState!.validate())
      return _formKey.currentState?.save();
    setState(() {});
    FocusScope.of(context).requestFocus(FocusNode());
    CoolAlert.show(
      context: context,
      type: CoolAlertType.warning,
      title: "เปลี่ยนรหัสผ่านหรือไม่",
      showCancelBtn: true,
      onConfirmBtnTap: () async{
       await NetworkService()
            .putUser(data.id, "password", new_password)
            .then((value) => {
              setState(() {
                
              }),
              Navigator.pop(context),
              Navigator.pop(context)
            });
        
      },
    );

    // ถ้าเป็นจริงให้เอาแป้นพิมพ์ออก
    //Navigator.pushNamed(context, '/product');
  }
}
