// ignore_for_file: unused_local_variable, camel_case_types, prefer_const_constructors, non_constant_identifier_names, prefer_const_literals_to_create_immutables

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project_app_big/constants/color.dart';
import 'package:project_app_big/models/deliverys/delivery.dart';
import 'package:project_app_big/models/deliverys/delivery_data.dart';
import 'package:project_app_big/models/order.dart';
import 'package:project_app_big/services/network_servises.dart';
class Delivery_Order_Product extends StatefulWidget {
  const Delivery_Order_Product({ Key? key }) : super(key: key);

  @override
  _Delivery_Order_ProductState createState() => _Delivery_Order_ProductState();
}

class _Delivery_Order_ProductState extends State<Delivery_Order_Product> {
 
  @override
  Widget build(BuildContext context) {
     //int indexs = 1;
   var now =  DateTime.now();
   var now_1w = now.subtract(Duration(days: 7)); 
    Order order = ModalRoute.of(context)?.settings.arguments as Order;
   

    
    return Scaffold(
      backgroundColor: kBGColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text("ที่ต้องได้รับ"),
      ),
      body: SafeArea(
        
        child: FutureBuilder<Delivery>(
          // future คือเรียกการฟีดข้อมูล
          future: NetworkService().getDelivery_Order(order.id),
          // builder คือผลลัพธ์ที่จะส่งกลับมาให้เรา
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //var data = snapshot.data as List<Product>;
              Delivery? data = snapshot.data;
              // ทำการดึงข้อมูลมาใหม่
              return RefreshIndicator(
                child: _DataView(data,now_1w),
                onRefresh: () async {
                  setState(() {});
                },
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Image.asset(
                  "assets/icons/error_404.png",
                  width: 120,
                  height: 120,
                  color: Colors.grey.shade500,
                ),
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

 Widget _DataView(Delivery? data, DateTime now_1w) {
   return Column(
     children: [
       Container(
         margin: EdgeInsets.only(top: 15 , right:10 , left: 10),
         width: MediaQuery.of(context).size.width,
         color: kBG1Color,
         child: Row(
          
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Container(
               margin: EdgeInsets.all(13),
                child: Row(
                  children: [
                    Text(
                  "จะได้รับในวันที่ ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14
                  ),
                ),
                Text(
                  "${data!.date}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: kMain1Color,
                  
                  ),
                ),
                  ],
                )
                
              ),
               
           ],
         ),
       ),
       Container(
         margin: EdgeInsets.only(top: 15 , right:10 , left: 10),
         width: MediaQuery.of(context).size.width,
         color: kBG1Color,
         child: Column(
           children: [
             Container(
               padding: EdgeInsets.all(10),
               child: Row(
                 
                 children: [
                    Text("การจัดส่ง"
                    ,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                    ),
                 ],
               ),
             ),
            
             Divider(),
             Container(
                child: feedData(data),
              ),
           ],
         ),
       )
     ],
   );
 }

 Widget feedData(Delivery data_Order){
   return FutureBuilder<List<DeliveryData>>(
          // future คือเรียกการฟีดข้อมูล
          future: NetworkService().getDelivery_Data(),
          // builder คือผลลัพธ์ที่จะส่งกลับมาให้เรา
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //var data = snapshot.data as List<Product>;
              List<DeliveryData>? data = snapshot.data;
              // ทำการดึงข้อมูลมาใหม่
              return RefreshIndicator(
                child: orderTimeLine(data,data_Order),
                onRefresh: () async {
                  setState(() {});
                },
              );
            }
            if (snapshot.hasError) {
            
              return Center(
                child: Text("err"),
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

 Widget orderTimeLine(List<DeliveryData>? data, Delivery data_order) {
    return Container(
      decoration: BoxDecoration(color: kBG1Color),
      child: Column(
        children: DataStatus_Delivery(data , data_order)
      ),
    );
  }

  Widget timelineRow(String title, var color, ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 18,
                height: 18,
                decoration: new BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Text(""),
              ),
              Container(
                width: 3,
                height: 50,
                decoration: new BoxDecoration(
                  color: color,
                  shape: BoxShape.rectangle,
                ),
                child: Text(""),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 9,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${title}',
                  style: TextStyle(
                      fontFamily: "regular",
                      fontSize: 14,
                      color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget timelineLastRow(String title, String subTile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 18,
                height: 18,
                decoration: new BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: Text(""),
              ),
              Container(
                width: 3,
                height: 20,
                decoration: new BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.rectangle,
                ),
                child: Text(""),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${title}\n ${subTile}',
                  style: TextStyle(
                      fontFamily: "regular",
                      fontSize: 14,
                      color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> DataStatus_Delivery(
      List<DeliveryData>? data, Delivery data_order) {
    var a = data!
        .map(
          (e) => timelineRow(
              e.statusName,
              data_order.idStatusDelivery == e.id
                  ? Color(0xffEF6F36)
                  : Colors.grey),
        )
        .toList();
    return a;
  }

  // void ID_Order() {
  //    setState(() {
  //       id_order = order.id;
  //     });
  // }
}