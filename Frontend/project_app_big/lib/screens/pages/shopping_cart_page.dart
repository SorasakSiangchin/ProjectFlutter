// ignore_for_file: camel_case_types, prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, unnecessary_string_escapes, constant_identifier_names, unused_local_variable, non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_this, await_only_futures, prefer_is_empty
import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_app_big/constants/api.dart';
import 'package:project_app_big/constants/color.dart';
import 'package:project_app_big/models/sqflites/cart_product_sqflite.dart';
import 'package:project_app_big/services/network_servises.dart';
import 'package:project_app_big/sqflites/db/cart_database.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'order_products/order_product_confirm/order_product_comfirm.dart';

class Shopping_Cart_Page extends StatefulWidget {
  const Shopping_Cart_Page({Key? key}) : super(key: key);

  @override
  _Shopping_Cart_PageState createState() => _Shopping_Cart_PageState();
}

class _Shopping_Cart_PageState extends State<Shopping_Cart_Page> {
  late List<Cart_Product_Sqflite> data_shopping_cart;
  int num_shopping_cart = 0;
  int priceProduct_total = 0;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  Future refreshNotes() async {
    // เปิดปิดข้อมูล
    setState(() => isLoading = true);
    data_shopping_cart = await NotesDatabase.instance.readAllNotes();
    this.priceProduct_total = await NotesDatabase.instance.totalPrice();
    num_shopping_cart = data_shopping_cart.length;
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    const double delivery_price = 35.0;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: kMainColor,
        title: Text(
          "ตะกร้าสินค้า",
          style: TextStyle(
              fontSize: 30.0, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          num_shopping_cart == 0
              ? SizedBox()
              : Container(
                  alignment: Alignment.center,
                  child: Text(
                    "${data_shopping_cart.length}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      backgroundColor: kBGColor,
      body: isLoading
          ? CircularProgressIndicator()
          : data_shopping_cart.isEmpty
              ? AlertData()
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: Column(
                      children: [
                        data_shopping_cart.isEmpty
                            ? AlertData()
                            : Expanded(
                                flex: 2,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 18.0,
                                      ),
                                      // -------- ข้อมูลที่แสดง -------------------
                                      Column(
                                        children: CartItem(),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                        //this.data_shopping_cart == 0.0 ? SizedBox() :
                        data_shopping_cart.isEmpty
                            ? SizedBox()
                            : Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 85,
                                    ),
                                    Divider(),
                                    SubTotal(delivery_price),
                                    Spacer(),
                                    Button_Confilm(this.data_shopping_cart),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
    );
  }

// ปุ่มยืนยันสินค้า
  MaterialButton Button_Confilm(List<Cart_Product_Sqflite> data_shopping_cart) {
    return MaterialButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Order_Product_Comfirm(
              data_shopping_cart: data_shopping_cart,
              total_price: priceProduct_total,
            ),
          ),
        );
      },
      color: kMainColor,
      height: 50.0,
      minWidth: double.infinity,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Text(
        "ยืนยันการสั่งซื้อ",
        style: TextStyle(
            color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Row SubTotal(double delivery_price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "ราคารวมทั้งหมด",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        Text(
          "฿ ${priceProduct_total}",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Row TotalPrice_Product() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "ราคารวมสินค้า",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        Text(
          "฿ ${priceProduct_total}",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
      ],
    );
  }

// ตัวแสดงข้อมูล
  List<Widget> CartItem() {
    var a = data_shopping_cart
        .map((e) => Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: kMainColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                      child: Container(
                        width: 78.0,
                        height: 78.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.scaleDown,
                            image: NetworkImage(
                              "${API.BASE_URL}${e.image}",
                            ),
                          ),
                          borderRadius: BorderRadius.circular(
                            20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Container(
                            width: 100.0,
                            child: Text(
                              "${e.name}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {
                              CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.warning,
                                  title: "ลบสินค้าหรือไม่",
                                  showCancelBtn: true,
                                  onCancelBtnTap: () {
                                    Navigator.pop(context);
                                  },
                                  onConfirmBtnTap: () async {
                                    await NotesDatabase.instance
                                        .delete(e.id)
                                        .then((value) {
                                          refreshNotes();
                                          Navigator.pop(context);
                                        });
                                  },
                                  cancelBtnText: "ยกเลิก",
                                  confirmBtnText: "ตกลง");
                            },
                            icon: Icon(Icons.delete_forever),
                            color: Colors.red.shade600,
                          ),
                        ]),
                        Row(
                          children: [
                            GestureDetector(
                              //เพิ่่มสินค้า
                              onTap: () async {
                                setState(() {
                                  e.number_product++;
                                });
                                await NotesDatabase.instance.update(e);
                                refreshNotes();
                              },
                              child: Container(
                                width: 20.0,
                                height: 20.0,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 15.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Text(
                                "${e.number_product}",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            GestureDetector(
                              // ลบสินค้า
                              onTap: () {
                                setState(() async {
                                  if (e.number_product == 1) {
                                    e.number_product = 1;
                                  } else {
                                    e.number_product--;
                                  }
                                  await NotesDatabase.instance.update(e);
                                  refreshNotes();
                                });
                              },
                              child: Container(
                                width: 20.0,
                                height: 20.0,
                                decoration: BoxDecoration(
                                  color: Colors.blue[300],
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                  size: 15.0,
                                ),
                              ),
                            ),
                            Spacer(),
                            Text(
                              "฿${e.price * e.number_product} ",
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ))
        .toList();
    return a;
  }

// แสดงข้อความไม่มีสินค้า
  Widget AlertData() {
    return Container(
      alignment: Alignment.center,
      child: Center(
          child: Column(
        children: [
          SizedBox(
            height:MediaQuery.of(context).size.height /3,
          ),
            Image.asset(
              "assets/icons/cartnot.png",
              color: Colors.grey,
              width:90,
            ),
            SizedBox(
            height:2,
          ),
            Text(
              "ไม่มีสินค้าในตะกร้า",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 30
              ),
            )
          ],
        ),
      ),
    );
  }
}
