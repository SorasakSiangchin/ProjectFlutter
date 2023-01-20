// ignore_for_file: prefer_const_constructors, camel_case_types, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unused_local_variable

import 'package:flutter/material.dart';
import 'package:project_app_big/constants/api.dart';
import 'package:project_app_big/constants/color.dart';
import 'package:project_app_big/models/sqflites/cart_product_sqflite.dart';

class Order_Product_List_Comfirm extends StatefulWidget {
  const Order_Product_List_Comfirm({ Key? key }) : super(key: key);

  @override
  State<Order_Product_List_Comfirm> createState() => _Order_Product_List_ComfirmState();
}

class _Order_Product_List_ComfirmState extends State<Order_Product_List_Comfirm> {
  List<Cart_Product_Sqflite> data_product=[];
  @override
  Widget build(BuildContext context) {
     data_product = ModalRoute.of(context)!.settings.arguments as List<Cart_Product_Sqflite>;
    return Scaffold(
      backgroundColor: kBGColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: Text("สินค้าสั่งซื้อทั้งหมด"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Center(
            child: Container(
              margin: EdgeInsets.only(
                right: 17
              ),
              child: Text(
                "${data_product.length}",
                style: TextStyle(
                  fontSize: 25
                ),
              ),
            ),
          ),
         
        ],
      ),
      body: SafeArea(
        child: _show_Like_Prodoct(),
      ),
    );
  }
  Widget _show_Like_Prodoct() {
    return ListView.builder(
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: Image.network("${API.BASE_URL}${data_product[index].image}",width: 70,),
                title: Text('${data_product[index].name}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                Text('฿ ${data_product[index].price}'),
              
              ],
            ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                
                    Text.rich(
                      TextSpan(
                        text: 'X ',
                         style: TextStyle(
                              color: Colors.grey
                            ),
                        children: [
                          TextSpan(
                            text: '${data_product[index].number_product}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey
                            )
                          )
                        ]
                      )
                    )
                  ],
                ),
                isThreeLine: true,
              ),
            );
          },
          itemCount: data_product.length,
        );
  }
}