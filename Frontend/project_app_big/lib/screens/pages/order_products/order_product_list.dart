// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project_app_big/constants/api.dart';
import 'package:project_app_big/constants/color.dart';
import 'package:project_app_big/models/addresses/data_address.dart';
import 'package:project_app_big/models/list.dart';
import 'package:project_app_big/models/order.dart';
import 'package:project_app_big/models/products/categor_product.dart';
import 'package:project_app_big/models/sqflites/cancel_product_sqflite.dart';
import 'package:project_app_big/screens/pages/order_products/order_product_list_detail.dart';
import 'package:project_app_big/services/network_servises.dart';
import 'package:project_app_big/sqflites/db/cancel_product_database.dart';

class Order_Product_List extends StatefulWidget {
  late Order data;
   Order_Product_List(this.data, {Key? key}) : super(key: key);

  @override
  _Order_Product_ListState createState() => _Order_Product_ListState();
}

class _Order_Product_ListState extends State<Order_Product_List> {
   DataAddress dataAddress = DataAddress();
   CategoryProducts data_seller =  CategoryProducts(idSellerNavigation01: IdSellerNavigation01(categoryProduct: [], orderProduct: []));
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _Feed_Address(widget.data.idAddress);
  }

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
          "รายละเอียดการสั่งซื้อ",
          style: TextStyle(fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder<List<Lists>>(
          // future คือเรียกการฟีดข้อมูล
          future: NetworkService().getList_IDOrder(widget.data.id),
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

  _DataView(List<Lists>? data_list_product) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: 
        [
         Padding(
           padding: EdgeInsets.all(5),
           child: Container(
             decoration: BoxDecoration(
               borderRadius:BorderRadius.circular(3),
             color: kBG1Color,
             ),
             padding: EdgeInsets.all(9),
             width:MediaQuery.of(context).size.width ,
             height: 100,
             child: Row(
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
               Expanded(child: 
               Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment:CrossAxisAlignment.start,
                 children: [
                   Image.asset("assets/icons/location.png",width: 20,color: kMain1Color,)
                 ],
                  ),
                ),
               Expanded(
                 flex: 10,
                 child: ListView(
                   children: 
                     [Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                          Text(
                            "ที่อยู่ในการจัดส่ง",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                            ),
                          ),
                         
                            Text.rich(
                        TextSpan(
                          children: [
                        TextSpan(text: "${dataAddress.userName} | "),
                        TextSpan(text: "${dataAddress.telUser}"),
                          ],
                        ),
                      ),
                      Text("${dataAddress.addressData}"),
                      dataAddress.addressDetail.isNotEmpty? Text("${dataAddress.addressDetail}") : SizedBox(),
                       ],
                     ),
                   ],
                 ),
               )
              ],
            ),
          ),
         ),
         Expanded(child:  ListView.builder(
          //scrollDirection: Axis.horizontal,
          itemCount: data_list_product!.length,
          // itemBuilder ตัวแสดงข้อมูล
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                  InkWell(
                    onTap: ()async{
                     await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>Order_Product_List_Detail(data_seller:data_seller,idProduct:data_list_product[index].idProduct)),
                        );
                        // await Navigator.pushNamed(context, "/order_product_list",
                        //     arguments: data[index])
                      },
                    child: _build_CartProduct(data_list_product, index),
                  ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox()
                )
              ],
            );
          },
          ),
        )
      ],
    );
  }

  Widget _build_IconBytton_Delete(List<Lists> data_list_product, int index) {
    return IconButton(
      hoverColor: Colors.red,
      icon: Icon(
        Icons.cancel_outlined,
        color: Colors.black,
      ),
      onPressed: () {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.warning,
          title: "ยกเลิกหรือไม่",
          onConfirmBtnTap: () async {
            //----------------การยกเลิกสินค้า----------------------
            await NetworkService()
                .deleteProduct_list(data_list_product[index].id)
                .then((value) async {
              final cancel_data = CancelProduct(
                  id_product:  data_list_product[index].idProductNavigation.id.toString(),
                  name: data_list_product[index].idProductNavigation.name,
                  price: data_list_product[index]
                      .idProductNavigation
                      .price
                      .toString(),
                  stock: data_list_product[index]
                      .idProductNavigation
                      .stock
                      .toString(),
                  image: data_list_product[index].idProductNavigation.image,
                  isImportant: true,
                  number_product:
                      data_list_product[index].numberProduct.toString());
              await NotesDatabase.instance.create(cancel_data).then((value) {
                Navigator.pop(context);
                setState(() {});
              });
            });
            //------------------------------------------
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
    );
  }



  Widget _Name_Seller(int idCategoryProduct) {
    return FutureBuilder<dynamic>(
          // future คือเรียกการฟีดข้อมูล
          future: NetworkService().getCategoryProductsByID(idCategoryProduct),
          // builder คือผลลัพธ์ที่จะส่งกลับมาให้เรา
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //var data = snapshot.data as List<Product>;
               data_seller = snapshot.data;
              // ทำการดึงข้อมูลมาใหม่
              return RefreshIndicator(
                child: _Show_Name_Seller(data_seller),
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
                    width: 10,
                    height: 10,
                    child: CircularProgressIndicator(
                      backgroundColor: kMainColor,
                      strokeWidth: 2,
                    ),
                  )
                ],
              ),
            );
          },
        );
  }

  Widget _Show_Name_Seller(CategoryProducts data) {

   return Container(
     margin: EdgeInsets.only(left: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${data.idSellerNavigation01.name}"),
        ],
      ),
   );
  }

  Widget _build_CartProduct(List<Lists> data_list_product, int index) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(9),
        child: Column(
          children: [
           _build_Name_Seller(data_list_product[index].idProductNavigation.idCategoryProduct),
            Divider(
              height: 2,
              color: Colors.black45,
            ),
           _build_Product(data_list_product,index)
          ],
        ),
      ),
    );
  }

  Widget _build_Name_Seller(int idCategoryProduct) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Image.asset(
            "assets/icons/shop.png",
            width: 22,
            cacheWidth: 90,
            color: kMain1Color,
          ),
          _Name_Seller(idCategoryProduct),
          Spacer(),
          Icon(Icons.arrow_forward_ios_rounded, size: 20,)
        ],
      ),
    );
  }

  Widget _build_Product(List<Lists> data_list_product, int index) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Container(
          height: 150,
          width: 60,
          child: Image.network(
            "${API.BASE_URL}${data_list_product[index].idProductNavigation.image}",
            fit: BoxFit.fill,
          ),
        ),
      ),
      // ignore: unnecessary_string_interpolations
      title: Text("${data_list_product[index].idProductNavigation.name}"),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("ราคา : ฿${data_list_product[index].idProductNavigation.price}"),
          Text("X ${data_list_product[index].numberProduct}"),
           
        ],
      ),

      // ignore: prefer_const_constructors
      trailing: widget.data.proofTransfer.isEmpty
          ? _build_IconBytton_Delete(data_list_product, index)
          : SizedBox(),
    );
  }

   _Feed_Address(String idAddress) async {
    var data = await NetworkService().getDataAddressByID(idAddress);
    dataAddress = data ;
  }
}
