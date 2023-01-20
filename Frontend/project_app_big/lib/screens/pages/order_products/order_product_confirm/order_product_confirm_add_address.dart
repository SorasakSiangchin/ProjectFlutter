// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:project_app_big/constants/api.dart';
import 'package:project_app_big/constants/color.dart';
import 'package:project_app_big/models/addresses/data_address.dart';
import 'package:project_app_big/services/network_servises.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validators/validators.dart';

class Order_Product_Confirm_Add_Address extends StatefulWidget {
  const Order_Product_Confirm_Add_Address({ Key? key }) : super(key: key);

  @override
  State<Order_Product_Confirm_Add_Address> createState() => _Order_Product_Confirm_Add_AddressState();
}

class _Order_Product_Confirm_Add_AddressState extends State<Order_Product_Confirm_Add_Address> {
  final _formKey = GlobalKey<FormState>();
  var data_address = DataAddress();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: kBGColor,
        appBar: AppBar(
          backgroundColor: kMainColor,
          title: Text("เพิ่มที่อยู่ใหม่"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            TextButton(
              onPressed: _onAdd_Address,
              child: Text(
                "บันทึก",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
            )
          ],
        ),
        body: SafeArea(
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("ช่องทางการติดต่อ")
                      ],
                    ),
                    SizedBox(height: 13,),
                    _Input_Name(),
                    SizedBox(height: 9,),
                    _Input_Tel(),
                    
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("ที่อยู่")
                      ],
                    ),
                    SizedBox(height: 13,),
                    _Input_Address(),
                    SizedBox(height: 9,),
                    _Input_DetailAddress()
                  ],
                ),
              ),
    
            ],
          ),
        ),
      ),
    );
  }

   _onAdd_Address() async{
       if (!_formKey.currentState!.validate()) return;
    // ถ้า validate ถูกให้แป้นพิมพ์มันหายไป
    FocusScope.of(context).requestFocus(FocusNode());
    _formKey.currentState!.save();
    //---------- ดึงไอดี user ที่ login เข้ามา --------
     var prefs = await SharedPreferences.getInstance();
     int id_user = prefs.get(API.USER_ID) as int;
     //--------------------------------------------
   
    await NetworkService().post_DataAddress(data_address: data_address, id_user: id_user).then((value) {
 if (value == API.OK) {
         CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        title: "เพิ่มข้อมูลสำเร็จ",
      ).then((value) {
        Navigator.pop(context);
      });
      } else {
          CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: "$value",
        confirmBtnText: "ตกลง"
      );
      }
    });
   
  }

  Widget _Input_Name() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (value) {
        data_address.userName = value!;
      },
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'กรุณกรอกข้อมูล';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'ชื่อ-นามสกุล',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _Input_Tel() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onSaved: (value) {
        data_address.telUser = value!;
      },
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'กรุณกรอกข้อมูล';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'หมายเลขโทรศัพท์',
        border: OutlineInputBorder(),
      ),
      maxLength: 10,
    );
  }

  Widget _Input_Address() {
    return TextFormField(
      onSaved: (value) {
        data_address.addressData = value!;
      },
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'กรุณกรอกข้อมูล';
        }
        return null;
      },
      keyboardType: TextInputType.multiline,
      maxLines: 5,
      decoration: InputDecoration(
        labelText: 'ที่อยู่',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _Input_DetailAddress() {
    return TextFormField(
      onSaved: (value) {
        data_address.addressDetail = value!;
      },
      keyboardType: TextInputType.multiline,
      maxLines: 5,
      decoration: InputDecoration(
        labelText: 'รายละเอียดที่อยู่',
        border: OutlineInputBorder(),
      ),
    );
  }

  
}