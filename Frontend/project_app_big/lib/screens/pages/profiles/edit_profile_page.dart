// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, curly_braces_in_flow_control_structures

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:project_app_big/constants/color.dart';
import 'package:project_app_big/models/users/user.dart';
import 'package:project_app_big/services/network_servises.dart';

class Edit_Product_Page extends StatefulWidget {
  const Edit_Product_Page({Key? key}) : super(key: key);

  @override
  State<Edit_Product_Page> createState() => _Edit_Product_PageState();
}

class _Edit_Product_PageState extends State<Edit_Product_Page> {
 late List<String> data;
String dataNew = "" ;
 final _formKey = GlobalKey<FormState>();
 bool status = false;
  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)?.settings.arguments as List<String>;
    
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: kBGColor,
        appBar: AppBar(
          leading: BackButton(),
          backgroundColor: kMainColor,
          title: Text("แก้ไข${data[1]}"),
          centerTitle: true,
          actions: [
              TextButton(
                onPressed: status?_OnSubmit:(){},
                child: Text(
                  "บันทึก",
                  style: TextStyle(color: status?Colors.white:Colors.black45),
                  
                ),
              ),
            ],
        ),
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.all(10),
            child: TextFormField(
              initialValue: '${data[0]}',
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                
              ),
              onSaved: (value){
               dataNew = value!;
              },
              validator: (value){
                 if(value!.isEmpty){
                  return "กรุณากรอกข้อมูล";
                 }else{
                   return null;
                 }
              },
              onChanged: (value) {
                if (value != data[0]) {
                  setState(() {
                    status = true;
                  });
                }else{
                  setState(() {
                    status = false;
                  });
                }
              },
            ),
          ),
        ),
      ),
    );
  }

   _OnSubmit() {
    if (_formKey.currentState!.validate()){
     _formKey.currentState?.save();
    setState(() {});
    FocusScope.of(context).requestFocus(FocusNode());
    }

    CoolAlert.show(
      context: context,
      type: CoolAlertType.warning,
      title: "เปลี่ยน${data[1]}หรือไม่",
      showCancelBtn: true,
      onConfirmBtnTap: () async{
       await NetworkService()
            .putUser(int.parse(data[3]), data[2], dataNew)
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
