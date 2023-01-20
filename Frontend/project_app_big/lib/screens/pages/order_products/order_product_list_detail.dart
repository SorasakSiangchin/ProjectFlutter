// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project_app_big/constants/api.dart';
import 'package:project_app_big/constants/color.dart';
import 'package:project_app_big/models/addresses/data_address.dart';
import 'package:project_app_big/models/products/categor_product.dart';
import 'package:project_app_big/models/products/product.dart';
import 'package:project_app_big/services/network_servises.dart';

class Order_Product_List_Detail extends StatefulWidget {
  late CategoryProducts data_seller;
  late int idProduct;
  Order_Product_List_Detail(
      {Key? key, required this.data_seller, required this.idProduct})
      : super(key: key);

  @override
  State<Order_Product_List_Detail> createState() =>
      _Order_Product_List_DetailState();
}

class _Order_Product_List_DetailState extends State<Order_Product_List_Detail> {
  late Product product;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBGColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: kMainColor,
        title: Text(
          "รายละเอียดสินค้า",
          style: TextStyle(fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _show_data(widget.idProduct),
      ),
    );
  }

  Widget _show_data(int id_product) {
    return FutureBuilder<Product>(
      // future คือเรียกการฟีดข้อมูล
      future: NetworkService().getProductID(id_product),
      // builder คือผลลัพธ์ที่จะส่งกลับมาให้เรา
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //var data = snapshot.data as List<Product>;
          product = snapshot.data!;
          // ทำการดึงข้อมูลมาใหม่
          return RefreshIndicator(
            child: Stack(
              children: [
                Column(
                  children: [
                    ShowImage_Product(),
                    ShowData_Product(),
                  ],
                )
              ],
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
    );
  }

  Widget ShowImage_Product() {
    Size size = MediaQuery.of(context).size;
    return Expanded(
      child: Container(
        child: Stack(
          children: [
            Container(
              height: size.height * 0.5,
              width: size.width,
              color: Color(0xFFD6EAF8),
              child: Image.network(
                "${API.BASE_URL}${product.image}",
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ShowData_Product() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFD6EAF8),
        ),
        child: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                    _Name_Product(),
                  SizedBox(
                    height: 10,
                  ),
                  _PriceAndColor_Product()
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            _Show_data_seller()
          ]),
        ),
      ),
    );
  }

  Widget _Show_data_seller() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(3),
      color: kBG1Color,
      child: Column(
        children: [
         _Title_Seller(),
          Divider(
            color: Colors.black38,
          ),
          Padding(
            padding:  EdgeInsets.all(8.0),
            child: Column(
              children: [
              _Name_Seller(),
              _Tel_Seller(),
               _Email_Seller(),
              _Address_Sellwe()
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _Title_Seller() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/icons/shop.png",
          width: 22,
          cacheWidth: 90,
          color: kMain1Color,
        ),
        SizedBox(
          width: 3,
        ),
        Text(
          "ผู้ขาย",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _Name_Seller() {
    return Row(
      children: [
        Text(
          "ชื่อ",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        Spacer(),
        Text("${widget.data_seller.idSellerNavigation01.name}")
      ],
    );
  }

  Widget _Tel_Seller() {
    return Row(
      children: [
        Text(
          "เบอร์โทร",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        Spacer(),
        Text("${widget.data_seller.idSellerNavigation01.tel}")
      ],
    );
  }

  Widget _Email_Seller() {
    return Row(
      children: [
        Text(
          "อีเมล",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        Spacer(),
        Text("${widget.data_seller.idSellerNavigation01.email}")
      ],
    );
  }

  Widget _Address_Sellwe() {
    return Row(
      children: [
        Text(
          "ที่อยู่",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        Spacer(),
        Text("${widget.data_seller.idSellerNavigation01.address}")
      ],
    );
  }

  Widget _Name_Product() {
    return Row(
      children: [
        Text(
          "${product.name}",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        )
      ],
    );
  }

  Widget _PriceAndColor_Product() {
    return Row(
      children: [
        Text.rich(
          TextSpan(
            text: "฿",
            style: TextStyle(fontSize: 25, color: kMain1Color),
            children: [
              TextSpan(
                  text: "${product.price}",
                  style: TextStyle(fontSize: 25, color: Colors.black))
            ],
          ),
        ),
        Spacer(),
        Text(
          "${product.color}",
          style: TextStyle(fontSize: 25),
        ),
      ],
    );
  }
}
