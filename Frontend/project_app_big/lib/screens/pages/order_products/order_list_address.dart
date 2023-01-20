// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:project_app_big/constants/api.dart';
import 'package:project_app_big/constants/color.dart';
import 'package:project_app_big/models/addresses/address.dart';
import 'package:project_app_big/services/network_servises.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Order_List_Address extends StatefulWidget {
  const Order_List_Address({Key? key}) : super(key: key);

  @override
  State<Order_List_Address> createState() => _Order_List_AddressState();
}

class _Order_List_AddressState extends State<Order_List_Address> {
  List<Address> data_address = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _FeedData_Address();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBGColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: Text("เลือกที่อยู่"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/order_product_confirm_add_address').then((value) {
               _FeedData_Address();
              });
            },
            icon: Icon(
              Icons.add,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return _Show_Address(index);
          },
          itemCount: data_address.length,
        ),
      ),
    );
  }

   _FeedData_Address() async {
    var prefs = await SharedPreferences.getInstance();
    int id = prefs.get(API.USER_ID) as int;
    await NetworkService().getAddressByID(id).then(
          (value) => {
            setState(
              () {
                data_address = value as List<Address>;
              },
            ),
          },
        );
  }

  Widget _Show_Address(int index) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
           ListTile(
            leading: Image.asset(
              "assets/icons/location.png",
              color:kMain1Color,
              width: 30,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(
                  '${data_address[index].idDataAddressNavigation.userName}',
                  style: TextStyle(fontSize: 17),
                ),
                Spacer(),

                index == 0
                        ? Text(
                            "เริ่มต้น",
                            style: TextStyle(color: kMain1Color),
                          )
                        : InkWell(
                            onTap: () async {
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.warning,
                                title: "ลบที่อยู่หรือไม่",
                                onConfirmBtnTap: () async {
                                  await NetworkService()
                                      .delete_DataAddress(
                                          data_address[index].idDataAddress)
                                      .then((value) {
                                    Navigator.pop(context);
                                    _FeedData_Address();
                                  });
                                },
      confirmBtnText: "ตกลง",
      cancelBtnTextStyle: TextStyle(),
      cancelBtnText: 'ยกเลิก',
      onCancelBtnTap: () {
        Navigator.pop(context);
      },
      showCancelBtn: true,
    );
                           
                          },
                          child: Image.asset(
                              "assets/icons/close.png",
                              width: 11,color: Colors.red,),
                        )
                ],),
                SizedBox(
                  height: 6,
                ),
                Row(
                  
                  children: [
                    Image.asset(
                      "assets/icons/telephone.png",
                      color: kMain1Color,
                      width: 13,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      '${data_address[index].idDataAddressNavigation.telUser}',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                Text("${data_address[index].idDataAddressNavigation.addressData}")
              ],
            ),
            subtitle: Text('${data_address[index].idDataAddressNavigation.addressDetail}.'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ElevatedButton.icon(
                onPressed: () {
                   Navigator.pop(context,data_address[index]);
                },
                icon: Image.asset(
                  "assets/icons/check.png",
                  width: 30,
                  color: Colors.white,
                ),
                label: Text(
                  "เลือก",
                  style: TextStyle(
                    fontSize: 19
                  ),
                ),
              ),
               SizedBox(width: 8),
              
            ],
          ),
        ],
      ),
    );
  }
}
