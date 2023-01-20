// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project_app_big/constants/api.dart';
import 'package:project_app_big/constants/color.dart';
import 'package:project_app_big/models/list.dart';
import 'package:project_app_big/models/order.dart';
import 'package:project_app_big/services/network_servises.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Review_Order_Product extends StatefulWidget {
  const Review_Order_Product({Key? key}) : super(key: key);

  @override
  _Review_Order_ProductState createState() => _Review_Order_ProductState();
}

class _Review_Order_ProductState extends State<Review_Order_Product> {
  @override
  Widget build(BuildContext context) {
    var order = ModalRoute.of(context)?.settings.arguments as Order;
    return Scaffold(
      backgroundColor: kBGColor,
      appBar: AppBar(
        title: Text("รีวิวสินค้า"),
        backgroundColor: kMainColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Lists>>(
          // future คือเรียกการฟีดข้อมูล
          future: NetworkService().getList_IDOrder(order.id),
          // builder คือผลลัพธ์ที่จะส่งกลับมาให้เรา
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //var data = snapshot.data as List<Product>;
              List<Lists>? data = snapshot.data;
              // ทำการดึงข้อมูลมาใหม่
              return RefreshIndicator(
                child: _DataView(data),
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
        ),
      ),
    );
  }

  _DataView(List<Lists>? data) {
    return ListView.builder(
      //scrollDirection: Axis.horizontal,
      itemCount: data!.length,
      // itemBuilder ตัวแสดงข้อมูล
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.only(top: 6),
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              _Show_product(data, index),
              // ignore: prefer_const_constructors

              // Divider คือ เส้นแบ่งแต่ละ layor
              SizedBox(
                height: 6,
              )
            ],
          ),
        );
      },
    );
  }

  Widget _Show_product(List<Lists> data, int index) {
    return Card(
      child: ListTile(
          onTap: () {
            Navigator.pushNamed(context, "/review_product",
                arguments: data[index]);
          },
          hoverColor: Colors.amber,
          leading: InkWell(
            onTap: () {
              Alert(
                      context: context,
                      // title: "Sorasak",
                      // desc: "Siangchin",
                      closeIcon: Container(
                        margin: EdgeInsets.all(9),
                        child: Image.asset(
                          "assets/icons/close.png",
                          width: 25,
                          height: 25,
                          color: Colors.white,
                        ),
                      ),
                      buttons: [
                        DialogButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "ตกลง",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        )
                      ],
                      image: Image.network(
                          "${API.BASE_URL}${data[index].idProductNavigation.image}"),
                      style: AlertStyle(
                          titleStyle: TextStyle(), backgroundColor: kBG1Color))
                  .show();
            },
            child: Image.network(
              "${API.BASE_URL}${data[index].idProductNavigation.image}",
              width: 50,
              height: 150,
              fit: BoxFit.fill,
            ),
          ),
          // ignore: unnecessary_string_interpolations
          title: Text(
            "${data[index].idProductNavigation.name}",
            style: TextStyle(color: kMain1Color),
          ),
          subtitle: Text("รหัสสินค้า : ${data[index].idProductNavigation.id}"),
          // ignore: prefer_const_constructors
          trailing: Image.asset(
            "assets/icons/comment.png",
            color: Colors.black,
            width: 25,
            height: 25,
          )),
    );
  }
}
