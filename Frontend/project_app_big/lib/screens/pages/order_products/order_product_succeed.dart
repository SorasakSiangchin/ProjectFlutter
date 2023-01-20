// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, void_checks

import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project_app_big/constants/api.dart';
import 'package:project_app_big/constants/color.dart';
import 'package:project_app_big/models/order.dart';
import 'package:project_app_big/screens/pages/order_products/order_product_list.dart';
import 'package:project_app_big/services/network_servises.dart';

class Order_Product_Succeed extends StatefulWidget {
  const Order_Product_Succeed({ Key? key }) : super(key: key);

  @override
  _Order_Product_SucceedState createState() => _Order_Product_SucceedState();
}

class _Order_Product_SucceedState extends State<Order_Product_Succeed> {


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>>(
      // future คือเรียกการฟีดข้อมูล
      future: NetworkService().getOrder_Succeed(),
      // builder คือผลลัพธ์ที่จะส่งกลับมาให้เรา
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //var data = snapshot.data as List<Product>;
          List<Order>? data = snapshot.data;
          // ทำการดึงข้อมูลมาใหม่
          return RefreshIndicator(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: _listView(data),
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

  _listView(List<Order>? data) {
    return data!.isEmpty ? _showAlert() : ListView.builder(
      //scrollDirection: Axis.horizontal,
      itemCount: data.length,
      // itemBuilder ตัวแสดงข้อมูล
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            GestureDetector(
              onTap: ()async{
                await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Order_Product_List(data[index])),
  );
            
        
              },
              child: _Order_Data(data[index])
            ),
            // ignore: prefer_const_constructors

            // Divider คือ เส้นแบ่งแต่ละ layor
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Divider(
                color: Colors.black,
              ),
            )
          ],
        );
      },
    );
  }

  Widget _showAlert() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.browser_not_supported,color: kMain1Color,size: 100,),
          Text(
            "ไม่มีการสั่งซื้อ",
              style: TextStyle(
                color: Colors.black,
                fontSize: 30
              ),
            ),
          ],
      )
    );
  }

  Widget _Order_Data(Order data) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 5,
      ),
      width: MediaQuery.of(context).size.width / 1.1,
      height: 240,
      decoration: BoxDecoration(
          color: kMainColor, borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(7),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "ที่ต้องชำระ",
                  style: TextStyle(fontSize: 13, color: kMain1Color),
                ),
              ],
            ),
            Divider(),
            Row(
              children: [
                Text(
                  "รหัสใบสั่ง : ${data.id}",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "สินค้าทั้งหมด : ${data.list.length} รายการ",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "ยอดชำระเงินทั้งหมด : ",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "฿ ${data.priceTotal}",
                  style: TextStyle(
                    fontSize: 17,
                    color: kMain1Color,
                  ),
                ),
              ],
            ),
            Divider(),
            InkWell(
              onTap: (){
                Navigator.pushNamed(context, '/delivery_order_product' , arguments: data);
              },
              child: Container(
                height: 25,
                child: Row(
                  children: [
                    Icon(Icons.delivery_dining_sharp,color:Color(0xff389C82),size: 20,),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                    "พัสดุจัดส่งสำเร็จ",
                    style: TextStyle(
                      color: Color(0xff389C82),
                      fontSize: 13
                    ),
                  ),
                  
                  ],
                ),
              ),
            ),
            Divider(),
            _build_Button(data)
          ],
        ),
      ),
    );
  }

  Widget _build_Button(Order data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Text(
            "รีวิวเลยตอนนี้",
            style: TextStyle(fontWeight: FontWeight.w100),
          ),
        ),
        FlatButton(
          minWidth: 120,
          onPressed:  () {
            Navigator.pushNamed(context, '/review_order_product',arguments: data);
          },
          child: Text("รีวิว",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          color: kMain1Color,
        ),
      ],
    );
  }
}