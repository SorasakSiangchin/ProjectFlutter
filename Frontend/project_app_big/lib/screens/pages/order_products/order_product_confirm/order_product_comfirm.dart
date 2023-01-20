// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unnecessary_string_interpolations, must_be_immutable

import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:project_app_big/constants/api.dart';
import 'package:project_app_big/constants/color.dart';
import 'package:project_app_big/models/addresses/address.dart';
import 'package:project_app_big/models/sqflites/cart_product_sqflite.dart';
import 'package:project_app_big/services/network_servises.dart';
import 'package:project_app_big/sqflites/db/cart_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types
class Order_Product_Comfirm extends StatefulWidget {
  late List<Cart_Product_Sqflite> data_shopping_cart;
  late int total_price;
  Order_Product_Comfirm({Key? key,required this.data_shopping_cart,required this.total_price})
      : super(key: key);

  @override
  State<Order_Product_Comfirm> createState() => _Order_Product_ComfirmState();
}

class _Order_Product_ComfirmState extends State<Order_Product_Comfirm> {
  Address data_address = Address(
      order: [], idDataAddressNavigation: IdDataAddressNavigation(address: []));
  late bool check_product ;
   int total_price_0 = 0;
  void initState() {
    // TODO: implement initState
    super.initState();
    
    total_price_0 = widget.total_price + 35;
    print("${widget.data_shopping_cart.length}");
   check_product = widget.data_shopping_cart.length == 1;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBGColor,
      bottomNavigationBar: _Build_Navbar(),
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: Text("ทำการสั่งซื้อ"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            //----------------------------------------------------
            _build_Address(),
            //----------------------------------------------------
           _build_Product(),
            //----------------------------------------------------
            _build_PriceDelivery(),
            //----------------------------------------------------
            _build_NumberProductAndPriceProduct(),
            //----------------------------------------------------
            _build_TotalPayment(),
            
          ],
        ),
      ),
    );
  }

  Widget _Build_Navbar() {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 60,
      width: size.width,
      color: kMainColor,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(
                    height: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            "ยอดชำระเงินทั้งหมด",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "฿ ${total_price_0}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kMain1Color,
                              fontSize: 17
                            ),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () {}),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: kMain1Color,
              child: FlatButton(
                  height: double.infinity,
                  child: Text(
                    "สั่งสินค้า",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18),
                  ),
                  onPressed: () {
                    if(data_address.id.isNotEmpty){
                      CoolAlert.show(
                      context: context,
                      type: CoolAlertType.success,
                      text: "ยืนยันการสั่งซื้อเรียบร้อย",
                    ).then(
                      (value) async {
                        await NetworkService()
                            .postOrderProducts_Many(widget.data_shopping_cart,
                                totalProduct: total_price_0,
                                Address_id: data_address.id,
                              )
                            .then(
                              (value) => print(value),
                            );
                        await NotesDatabase.instance.delete_All().then((value){
                           Navigator.of(context).pushNamedAndRemoveUntil(
                                '/', (Route<dynamic> route) => false);
                          });
                        },
                      );
                    }else{
                       CoolAlert.show(
                      context: context,
                      type: CoolAlertType.warning,
                      text: "กรุณาเลือกที่อยู่",
                    );
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonAdd_Address() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: DottedBorder(
        child: Container(
          width: 50,
          height: 30,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/icons/add.png",
                width: 20,
                color: Colors.blue,
              )
            ],
          ),
        ),
        color: Colors.blue,
        strokeWidth: 2.5,
        borderType: BorderType.RRect,
        dashPattern: [9, 5],
        strokeCap: StrokeCap.round,
      ),
    );
  }

  Widget _buildData_Address() {
    return Column(
      crossAxisAlignment:CrossAxisAlignment.start,
      children: 
        [SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${data_address.idDataAddressNavigation.userName} | ',
                        ),
                        TextSpan(
                          text: '${data_address.idDataAddressNavigation.telUser}',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "${data_address.idDataAddressNavigation.addressData}",
                  ),
                ],
              ),
              data_address.idDataAddressNavigation.addressDetail.isNotEmpty
                  ? Row(
                      children: [
                        Text(
                          "(${data_address.idDataAddressNavigation.addressDetail})",
                        ),
                      ],
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ],
    );
  }

  _onSubmitAdd_Address() async {
    Address result =
        await Navigator.pushNamed(context, "/order_list_address") as Address;
    if(result.id.isNotEmpty){
      setState(() {
      data_address = result;
    });
    }    
   
  }

  Widget _Show_Address() {
    return InkWell(
      onTap: _onSubmitAdd_Address,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "ที่อยู่สำหรับจัดส่งสินค้า",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            data_address.id.isEmpty
                ? _buildButtonAdd_Address()
                : _buildData_Address(),
          ],
        ),
      ),
    );
  }

  Widget _build_Address() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: MediaQuery.of(context).size.width,
      height: 110,
      padding: EdgeInsets.all(10),
      color: Color(0xff98D4FF),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Image.asset(
                  "assets/icons/location.png",
                  width: 25,
                  color: kMain1Color,
                ),
              ],
            ),
          ),
          Expanded(flex: 10, child: _Show_Address()),
          Expanded(
            child: InkWell(
              onTap: _onSubmitAdd_Address
              ,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 22,
                    color: kMain1Color,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _build_Product() {
    return  InkWell(
      onTap: _onProductList,
      child: Container(
                margin: EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width,
                height: 120,
                padding: EdgeInsets.all(10),
                color: Color(0xff98D4FF),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 90,
                            child: Image.network(
                              "${API.BASE_URL}${widget.data_shopping_cart[0].image}",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              //${widget.data_shopping_cart[0].name}
                              children: [
                                Text(
                                  "${widget.data_shopping_cart[0].name}",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "฿ ${widget.data_shopping_cart[0].price}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  "X ${widget.data_shopping_cart[0].number_product} ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child:widget.data_shopping_cart.length == 1 ? SizedBox(): Row(
                        children: [
                          Text(
                            "ทั้งหมด",
                            style: TextStyle(
                              color: kMain1Color,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 22,
                            color: kMain1Color,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _build_PriceDelivery() {
    return Column(
      children: [
        Container(
              width: MediaQuery.of(context).size.width,
              height: 4,
              padding: EdgeInsets.all(10),
              color: Color(0xffC6DBD8),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 80,
              padding: EdgeInsets.all(10),
              color: Color(0xffF6FFFE),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text("- ส่งธรรมดาในประเทศ",
                      style: TextStyle(
                          fontSize: 16,
                          
                        ),),
                      Spacer(),
                      Text(
                        "฿ 35.0",
                        style: TextStyle(
                          fontSize: 16,

                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 4,
              padding: EdgeInsets.all(10),
              color: Color(0xffC6DBD8),
            ),
      ],
    );
  }

  Widget _build_NumberProductAndPriceProduct() {
    return Container(
              margin: EdgeInsets.only(top: 10),
              width: MediaQuery.of(context).size.width,
              height: 60,
              padding: EdgeInsets.all(10),
              color: Color(0xff98D4FF),
              child: Center(
                  child: Row(
                children: [
                  Text("คำสั่งซื้อทั้งหมด (${widget.data_shopping_cart.length} ชิ้น):"),
                  Spacer(),
                  Text(
                    "฿ ${widget.total_price}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: kMain1Color),
                  )
                ],
        ),
      ),
            );
  }

  Widget _build_TotalPayment() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: MediaQuery.of(context).size.width,
      height: 120,
      padding: EdgeInsets.all(10),
      color: Color(0xff98D4FF),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Text("รวมการสั่งซื้อ"),
              Spacer(),
              Text("฿ ${widget.total_price}")
            ],
          ),
          Row(
            children: [Text("การจัดส่ง"), Spacer(), Text("฿ 35.0")],
          ),
          Row(
            children: [
              Text(
                "ยอดชำระเงินทั้งหมด",
                style: TextStyle(fontSize: 19),
              ),
              Spacer(),
              Text(
                "฿ ${total_price_0}",
                style: TextStyle(fontSize: 19, color: kMain1Color),
              ),
            ],
          ),
        ],
      ),
    );
  }

   _onProductList() {
     check_product
          ? null
          :    Navigator.pushNamed(context, "/order_product_list_comfirm",arguments:widget.data_shopping_cart );
            ;
  }
}
