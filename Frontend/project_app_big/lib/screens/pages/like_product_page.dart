// ignore_for_file: camel_case_types, prefer_const_constructors, non_constant_identifier_names, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:project_app_big/constants/api.dart';
import 'package:project_app_big/constants/color.dart';
import 'package:project_app_big/models/sqflites/like_product_sqflite.dart';
import 'package:project_app_big/screens/pages/products/detail_product.dart';
import 'package:project_app_big/sqflites/db/like_product_database.dart';

class Like_Product_Page extends StatefulWidget {
  const Like_Product_Page({Key? key}) : super(key: key);

  @override
  State<Like_Product_Page> createState() => _Like_Product_PageState();
}

class _Like_Product_PageState extends State<Like_Product_Page> {
    List<LikeProduct> data_like_product =[];
  bool isLoading = false;
  int num_like_product = 0;
 late List<dynamic> check_like_product_delete ;
  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  Future refreshNotes() async {
    // เปิดปิดข้อมูล
    setState(() => isLoading = true);
    data_like_product = await LikeProductDatabase.instance.readAllLikeProduct();
    num_like_product = data_like_product.length;
    setState(() => isLoading = false);
  }
  @override
  Widget build(BuildContext context) {
   
      
    return Scaffold(
      backgroundColor: kBGColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: Text("ที่ฉันชอบ"),
        centerTitle: true,
        actions: [
          num_like_product == 0 ?SizedBox() :
          Container(
            alignment: Alignment.center,
            child: Text(
              "${num_like_product}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : data_like_product.isEmpty
                  ? _show_Alert_Like_Prodoct()
                  : _show_Like_Prodoct(),
        ),
      ),
    );
  }

  Widget _show_Like_Prodoct() {
    return ListView.builder(
          itemBuilder: (context, index) {
            return InkWell(
              onTap: (){
                Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Detail_Product(id_product: data_like_product[index].id, ),),
            ).then((value) =>  {
             _check_Like_Product_Delete(index)
            });
              },
              child: Card(
            child: ListTile(
              leading: Image.network(
                  "${API.BASE_URL}${data_like_product[index].image}"),
              title: Text('${data_like_product[index].name}'),
              subtitle: Text('฿ ${data_like_product[index].id}'),
              trailing: Image.asset(
                "assets/icons/heart.png",
                color:data_like_product[index].status?Color(0xFFD63D3D):Colors.grey,
                width: 20,
              ),
              isThreeLine: true,
            ),
          ),
        );
      },
      itemCount: data_like_product.length,
    );
  }

  _check_Like_Product_Delete(int index) async{
    await LikeProductDatabase.instance
        .readLikeProduct_Check(data_like_product[index].id)
        .then((value) async {
      if (value == 'YES') {
       setState(() {
        data_like_product[index].status = true;
       });
      } else {
           setState(() {
         data_like_product[index].status = false;
       });
      }
    });
   }
  
  Widget _show_Alert_Like_Prodoct() {
    return Image.asset(
      "assets/icons/broken-heart.png",
      width: 160,
      color: Colors.grey,
    );
  }


  
}
