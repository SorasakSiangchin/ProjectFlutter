// ignore_for_file: prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project_app_big/constants/api.dart';
import 'package:project_app_big/constants/color.dart';
import 'package:project_app_big/models/review.dart';
import 'package:project_app_big/models/users/user.dart';
import 'package:project_app_big/services/network_servises.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Review_Product_Data extends StatefulWidget {
  const Review_Product_Data({ Key? key }) : super(key: key);

  @override
  _Review_Product_DataState createState() => _Review_Product_DataState();
}

class _Review_Product_DataState extends State<Review_Product_Data> {
  @override
  Widget build(BuildContext context) {
    int idProduct = ModalRoute.of(context)?.settings.arguments as int;
    return Scaffold(
      backgroundColor: kBGColor,
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          backgroundColor: kMainColor,
          title: Text(
            "รีวิว",
            style: TextStyle(fontSize: 22),
          ),
          centerTitle: true,
        ),
      body: SafeArea(
        child: Container(
          child: FutureBuilder<List<Review>>(
          // future คือเรียกการฟีดข้อมูล
          future: NetworkService().getReview_Data_id(idProduct),
          // builder คือผลลัพธ์ที่จะส่งกลับมาให้เรา
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //var data = snapshot.data as List<Product>;
              List<Review>? data = snapshot.data;
              // ทำการดึงข้อมูลมาใหม่
              return RefreshIndicator(
                child: data!.length == 0 ? Show_Alert(): _DataView(data),
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
      ),
    );
  }

 Widget _DataView(List<Review>? data) {
   return ListView.builder(
      //scrollDirection: Axis.horizontal,
      itemCount: data!.length,
      // itemBuilder ตัวแสดงข้อมูล
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            GestureDetector(
              onTap: (){
                //  Navigator.pushNamed(context, "/order_product_list",
                //     arguments: data[index].id);
              },
              child: _Order_Data(data[index])
            ),
            // ignore: prefer_const_constructors
             //Image.network("${API.BASE_URL}/${data[index].image}" , width: 100,height: 100,),
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

Widget  _Order_Data(Review data_review) {
    return FutureBuilder<User>(
          // future คือเรียกการฟีดข้อมูล
          future: NetworkService().getDataUserByID(data_review.idList),
          // builder คือผลลัพธ์ที่จะส่งกลับมาให้เรา
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //var data = snapshot.data as List<Product>;
              User? data_user = snapshot.data;
              // ทำการดึงข้อมูลมาใหม่
              return RefreshIndicator(
                child: _DataUser(data_user,data_review),
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

  Widget Show_Alert() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
        "assets/icons/not-comment.png",
        color: Colors.grey,
        width: 120,
      ),
          Text(
            "ไม่มีการรีวิว",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }

  Widget _DataUser(User? data_user, Review data_review,) {
    return  Container(
      padding: EdgeInsets.all(5),
      margin:EdgeInsets.all(5) ,
      width: MediaQuery.of(context).size.width,
      color: kBG1Color,
      child: Column(
        children: [
          Row(
              children: [
                InkWell(
                  onTap: ()async{
                       var prefs = await SharedPreferences.getInstance();
                       int id = prefs.get(API.USER_ID) as int;
                       if(data_user!.id == id){
                             Navigator.pushNamed(context, '/profile_page', arguments: data_user.id);
     
                       }else{
                         Alert(
      context: context,
      title: "${data_user.name}",
      desc: "${data_user.email}",
      closeIcon: Icon(Icons.close),
      buttons: [
        DialogButton(onPressed: (){},child: Text("Final"),)
      ],
      image: Image.network(
          "${API.BASE_URL}${data_user.image}"),
      style: AlertStyle(titleStyle: TextStyle(),backgroundColor: kBGColor)
    ).show();
                       }
                  },
                  child: CircleAvatar(
                  maxRadius: 19,
                  backgroundImage: NetworkImage(
                    '${API.BASE_URL}${data_user!.image}',
                  ),
                ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text("${data_user.name}"),
                Spacer(),
                Text(
                  "${data_review.date}",
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
            SizedBox(height: 15,),
           Container(
             width: MediaQuery.of(context).size.width,
             child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${data_review.data}",style: TextStyle(fontSize: 19),)
              ],
            ) ,
           ),
          
             SizedBox(height: 10,),
            data_review.image.isNotEmpty ?
            Image.network('${API.BASE_URL}${data_review.image}',width: 100,):SizedBox()
        ],
      )
    );
  }
}