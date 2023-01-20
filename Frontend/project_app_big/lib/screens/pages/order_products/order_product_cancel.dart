// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:project_app_big/constants/api.dart';
import 'package:project_app_big/constants/color.dart';
import 'package:project_app_big/models/addresses/address.dart';
import 'package:project_app_big/models/sqflites/cancel_product_sqflite.dart';
import 'package:project_app_big/screens/pages/products/detail_product.dart';
import 'package:project_app_big/services/network_servises.dart';
import 'package:project_app_big/sqflites/db/cancel_product_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Order_Product_Cancel extends StatefulWidget {
  const Order_Product_Cancel({Key? key}) : super(key: key);

  @override
  State<Order_Product_Cancel> createState() => _Order_Product_CancelState();
}

class _Order_Product_CancelState extends State<Order_Product_Cancel> {
  late List<CancelProduct> data;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    this.data = await NotesDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CircularProgressIndicator()
        : data.isEmpty
            ? Text(
                'No Notes',
                style: TextStyle(color: Colors.white, fontSize: 24),
              )
            : _CancelItem();
  }

  Widget _CancelItem() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            SizedBox(
              height: 10,
            ),
            _Cancel_Data(data[index]),
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
      itemCount: data.length,
    );
  }

  Widget _Cancel_Data(CancelProduct data) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 5,
      ),
      width: MediaQuery.of(context).size.width / 1.1,
      height: 220,
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
                  "ยกเลิก",
                  style: TextStyle(fontSize: 14, color: kMain1Color),
                ),
              ],
            ),
            Divider(),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: kMainColor),
                  ),
                  child: Image.network(
                    "${API.BASE_URL}${data.image}",
                    width: 70,
                    height: 70,
                  ),
                ),
                 SizedBox(
              width: 10,
            ),
                Expanded(child: Container(
                  child: Column(
                    children: [
                      Container(
                        height: 45,
                        width: 265,
                        child:  Text(data.name),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("฿ ${data.price}"),
                        ],
                      ),
                    ],
                  ),
                ),
                flex: 3,
                )
              ],
            ),
           Divider(),
            Row(
              children: [
                Text(
                  "${data.number_product} ชิ้น",
                  style: TextStyle(fontSize: 12),
                ),
                Spacer(),
                Row(
                  children: [
                    Text(
                      "รวมการสั่งซื้อ : ",
                      style: TextStyle(fontSize: 13),
                    ),
                    Text(
                      "฿${int.parse(data.price) * int.parse(data.number_product)}",
                      style: TextStyle(fontSize: 14,color: kMain1Color),
                    ),
                  ],
                ),
               
              ],
            ),
            // Row(
            //   children: [
            //     Text(
            //       "ยอดชำระเงินทั้งหมด : ",
            //       style: TextStyle(fontSize: 16),
            //     ),
            //     Text(
            //       "฿ ",
            //       style: TextStyle(
            //         fontSize: 17,
            //         color: kMain1Color,
            //       ),
            //     ),
            //   ],
            // ),
             Divider(),
            //  ElevatedButton(onPressed: ()async{
            //    await NotesDatabase.instance
            //                             .delete(data.id as int)
            //                             .then((value) {
            //                             });
            //  }, child: Text("44444")),
            InkWell(
              onTap: () {
                // Navigator.pushNamed(context, '/delivery_order_product',
                //     arguments: data);
              },
              child: Container(
                height: 35,
                child: Row(
                  children: [
                    Text(
                      "ยกเลิกโดยคุณ",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Spacer(),
                    FlatButton(
                        minWidth: 120,
                        onPressed: () async{
                          await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>Detail_Product(id_product: int.parse(data.id_product),)),
                        ).then((value) {
                          
                          });
                        },
                        child: Text(
                          "ซื้ออีกครั้ง",
                          style: TextStyle(fontSize: 15,color: Colors.white),
                        ),
                        color: kMainColor),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}
 