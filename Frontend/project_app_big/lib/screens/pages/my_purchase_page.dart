// ignore_for_file: camel_case_types, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project_app_big/constants/color.dart';
import 'package:project_app_big/models/order.dart';
import 'package:project_app_big/screens/pages/order_products/order_product_cancel.dart';
import 'package:project_app_big/screens/pages/order_products/order_product_payment.dart';
import 'package:project_app_big/screens/pages/order_products/order_product_list.dart';
import 'package:project_app_big/screens/pages/order_products/order_product_succeed.dart';
import 'package:project_app_big/screens/pages/order_products/order_product_toget.dart';
import 'package:project_app_big/services/network_servises.dart';
import 'package:project_app_big/models/list.dart';

class My_Purchase_Page extends StatefulWidget {
  const My_Purchase_Page({Key? key}) : super(key: key);

  @override
  _My_Purchase_PageState createState() => _My_Purchase_PageState();
}

class _My_Purchase_PageState extends State<My_Purchase_Page> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: kBGColor,
        appBar: AppBar(
          backgroundColor: kMainColor,
          title: Text(
            "การซื้อของฉัน",
            style: TextStyle(fontSize: 22),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 4,
            tabs: [
              Tab(
                  icon: ImageIcon(
                  AssetImage("assets/icons/payment.png"),
                ),
                text: "ที่ต้องชำระเงิน",
              ),
              Tab(
                icon: ImageIcon(
                  AssetImage("assets/icons/delivery.png"),
                ),
                text: "ที่ต้องได้รับ",
              ),
              Tab(
                icon: ImageIcon(
                  AssetImage("assets/icons/success.png"),
                ),
                text: "สำเร็จ",
              ),
               Tab(
                icon: ImageIcon(
                  AssetImage("assets/icons/cancel.png"),
                ),
                text: "ยกเลิก",
              )
            ],
          ),
        ),
        body: SafeArea(
            child: TabBarView(
          children: [
            Order_Product(),
            Order_Product_ToGet(),
            Order_Product_Succeed(),
            Order_Product_Cancel()
          ],
        )),
      ),
    );
  }
}
