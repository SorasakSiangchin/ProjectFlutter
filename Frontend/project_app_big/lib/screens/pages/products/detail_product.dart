// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, unused_local_variable, non_constant_identifier_names, avoid_unnecessary_containers, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, camel_case_types, prefer_const_constructors_in_immutables, curly_braces_in_flow_control_structures

import 'package:badges/badges.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:project_app_big/constants/api.dart';
import 'package:project_app_big/constants/color.dart';
import 'package:project_app_big/models/products/categor_product.dart';
import 'package:project_app_big/models/products/detail_product.dart';
import 'package:project_app_big/models/sqflites/cart_product_sqflite.dart';
import 'package:project_app_big/models/products/product.dart';
import 'package:project_app_big/models/sqflites/like_product_sqflite.dart';
import 'package:project_app_big/screens/pages/order_products/order_product_confirm/order_product_comfirm.dart';
import 'package:project_app_big/screens/pages/shopping_cart_page.dart';
import 'package:project_app_big/services/network_servises.dart';
import 'package:project_app_big/sqflites/db/cart_database.dart';
import 'package:project_app_big/sqflites/db/like_product_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Detail_Product extends StatefulWidget {
  late int id_product;
  Detail_Product({Key? key, required this.id_product}) : super(key: key);

  @override
  _Detail_ProductState createState() => _Detail_ProductState();
}

class _Detail_ProductState extends State<Detail_Product> {
  var product = Product(detailProduct: [], idCategoryProductNavigation: IdCategoryProductNavigation(idSellerNavigation: IdSellerNavigation(categoryProduct: [], orderProduct: []), product: []), list: [], productAdded: []);
  late CategoryProducts data_seller;
   List<DetailProducts> detailProducts = [];
  int numberProduct = 0;
  bool check_like = false;
  int number_cart = 0;
  bool isLoading = false;
  int id_user = 0;
  @override
  void initState() {
    super.initState();
    _check_like_product();
    _RefreshCrats();
   _Feed_DetailProduct_Image();
   _Feed_IDUser();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBGColor,
      body: SafeArea(
        child: _show_data(widget.id_product),
      ),
      bottomNavigationBar: _Build_Navbar(product),
    );
  }

  Widget ShowImage_Product() {
    Size size = MediaQuery.of(context).size;
    return Expanded(
      child: Container(
        child: Stack(
          children: [
            InkWell(
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => Detail_Product_Image(
                      Imagedefault:product.image,
                      DetailProductimages: detailProducts,
                      index: 0,
                    ),
                  ),
                );
              },
              child: Container(
                height: size.height * 0.5,
                width: size.width,
                color: Color(0xFFD6EAF8),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),
                  child: Image.network(
                    "${API.BASE_URL}${product.image}",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: kMainColor,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  height: 60,
                  width: size.width / 4.5,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: 18),
                  width: 40,
                  height: 40,
                  decoration:
                  BoxDecoration(
                    color: kMainColor,
                   borderRadius: BorderRadius.circular(10),
                  ),
                  child: Badge(
                    padding: EdgeInsets.all(4),
                    toAnimate: false,
                    badgeColor: kMain1Color,
                    shape: BadgeShape.circle,
                    position: BadgePosition.topEnd(),
                    //showBadge: false,
                    badgeContent: Text(
                      '${number_cart}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: IconButton(
                      color: Colors.white,
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Shopping_Cart_Page(),
                          ),
                        ).then((value) => _RefreshCrats());
                      },
                      icon: Icon(Icons.shopping_cart),
                    ),
                  ),
                )
              ],
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
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _Name_Product(),
                _Price_Product(),
                _Colors_Product(),
                SizedBox(
                  height: 20,
                ),
                
                SizedBox(
                  height: 20,
                ),
                _Build_DataSeller(),
                 SizedBox(
                  height: 10,
                ),
                 _Build_Button(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _Build_Navbar([Product? product]) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 60,
      width: size.width,
      color: kMainColor,
      child: Row(
        children: [
          Expanded(
            child: FlatButton(
                height: double.infinity,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "เพิ่มสินค้า",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Icon(
                        Icons.add_shopping_cart,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                onPressed: add_product_to_cart),
          ),
          VerticalDivider(thickness: 1),
          Expanded(
            child: FlatButton(
              height: double.infinity,
              child: Text(
                "ซื้อสินค้า",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18),
              ),
              onPressed: () async {
                if(id_user != 0){
 if (numberProduct > 0) {
                  int price_total = 0;
                  List<Cart_Product_Sqflite> data = [];
                  Cart_Product_Sqflite data_01 = Cart_Product_Sqflite(
                      id: product!.id,
                      name: product.name,
                      image: product.image,
                      price: product.price,
                      stock: product.stock,
                      number_product: numberProduct);
                  data.add(data_01);
                  price_total = product.price * numberProduct;
                  //  ดึงข้อมูลมา
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Order_Product_Comfirm(
                        data_shopping_cart: data,
                        total_price: price_total,
                      ),
                    ),
                  );
                } else {
                  CoolAlert.show(
                    context: context,
                    type: CoolAlertType.warning,
                    text: "กรุณาเพิ่มจำนวนสินค้า",
                  );
                }
                }else{
                    CoolAlert.show(
                    context: context,
                    type: CoolAlertType.warning,
                    title: "กรุณาเข้าสู่ระบบ"
                  );
                }
               
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _Name_Product() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          product.name,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: _onSubmit_like_product,
          icon: Image.asset(
            "assets/icons/heart.png",
            color: check_like ? Colors.grey : Color(0xFFD63D3D),
          ),
        )
      ],
    );
  }

  Widget _Price_Product() {
    return Row(
      children: [
        Text(
          "ราคา ${product.price} บาท",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacer(),
        Text(
          "คลัง : ${product.stock}",
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ],
    );
  }

  Widget _Build_Button() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          color: kMainColor,
          onPressed: () {
            Navigator.pushNamed(context, "/shopping_cart_page");
          },
            child: Row(
              children: [
                Image.asset(
                  "assets/icons/detail.png",
                  width: 20,
                  cacheWidth: 500,
                  color: kMain1Color,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
            'เพิ่มเติม',
            style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ) 
        ),
        FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          color: kMainColor,
          onPressed: () {
            Navigator.pushNamed(context, "/review_product_data",
                arguments: product.id);
          },
          child: Row(
              children: [
                Image.asset(
                  "assets/icons/comment.png",
                  width: 20,
                  cacheWidth: 500,
                  color: kMain1Color,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
            'รีวิว',
            style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ) ,
        ),
      ],
    );
  }

  // ปุ่มเพิ่มสินค้าเข้าไปในตะกร้า
  Future add_product_to_cart() async {
    if(id_user != 0){
 if (numberProduct > 0) {
      final data = Cart_Product_Sqflite(
          id: product.id,
          name: product.name,
          image: product.image,
          price: product.price,
          stock: product.stock,
          number_product: numberProduct);
      //  ดึงข้อมูลมา
      var data_cart_product = await NotesDatabase.instance.readNote(data.id);
      if (data_cart_product == "NO") {
        // ถ้ามันไม่มีมีใน database
        CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          text: "เพิ่มสินค้าสำเร็จ",
        ).then((value) async {
          await NotesDatabase.instance.create(data);
          _RefreshCrats();
        });
      } else {
        // ถ้ามันมีอยู่ใน database อยู่แล้ว
        CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          text: "เพิ่มสินค้าสำเร็จ",
        ).then((value) async {
          await NotesDatabase.instance.update_toCart(data);
         _RefreshCrats();
        });
      }
    } else {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        text: "กรุณาเพิ่มจำนวนสินค้า",
      );
    }
    }else{
       CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        title:"กรุณาเข้าสู่ระบบ" ,
      );
    }
   

    // var cart_product01 = Cart_Product(id: 0 ,image:"6666" ,name: "4444",number_product:10 ,price:6666 ,stock:55555);
    // cart_product.id = product!.id;
    // cart_product.name = product.name;
    // cart_product.image = product.image;
    // cart_product.price = product.price;
    // cart_product.stock = product.stock;
    // cart_product.number_product = numberProduct;
    //context.read<Cart>().add(cart_product);
  }

  Widget _Detail_Product() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "รายละเอียดสินค้า",
              maxLines: 3,
              style: TextStyle(
                  // ระยะห่าง
                  height: 1.5,
                  fontSize: 19,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "สี",
              maxLines: 3,
              style: TextStyle(
                  // ระยะห่าง
                  height: 1.5,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              "${product.color}",
              maxLines: 3,
              style: TextStyle(
                  // ระยะห่าง
                  height: 1.5,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "น้ำหนัก",
              maxLines: 3,
              style: TextStyle(
                  // ระยะห่าง
                  height: 1.5,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              "${product}",
              maxLines: 3,
              style: TextStyle(
                  // ระยะห่าง
                  height: 1.5,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            )
          ],
        )
      ],
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
                    Add_Product_Cart_Number()
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

  Future _onSubmit_like_product() async {
    await LikeProductDatabase.instance
        .readLikeProduct_Check(product.id)
        .then((value) async {
      if (value == 'YES') {
        await LikeProductDatabase.instance.delete(product.id).then((value) {
          setState(() {
            check_like = true;
          });
        });
      } else {
        var data = LikeProduct(
            id: product.id,
            name: product.name,
            image: product.image,
            price: product.price,
            stock: product.stock,
            color: product.color,
            status: true);
        await LikeProductDatabase.instance.create(data).then((value) {
          setState(() {
            check_like = false;
          });
        });
      }
    });
  }

  Future _check_like_product() async {
    await LikeProductDatabase.instance
        .readLikeProduct(widget.id_product)
        .then((value) {
      if (value == 'NO') {
        setState(() {
          check_like = true;
          //print(value);
        });
      } else {
        setState(() {
          check_like = false;
          //print(value);
        });
      }
    },);
  }

   Future _RefreshCrats() async {
    // เปิดปิดข้อมูล
    setState(() => isLoading = true);
    number_cart = await NotesDatabase.instance.cart_number();
    setState(() => isLoading = false);
  }

  Widget Add_Product_Cart_Number() {
    return Column(
      children: [
         Divider(color: Colors.black),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8
                  ),
                  child: Row(
                    children: [
                      Text(
                        "จำนวน",
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          if (numberProduct == product.stock) {
                            numberProduct = product.stock;
                          } else {
                            setState(() {
                              numberProduct++;
                            });
                          }
                        },
                        child: Container(
                          width: 25.0,
                          height: 25.0,
                          decoration: BoxDecoration(
                            color: kMainColor,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 15.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        child: Text(
                          "${numberProduct}",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (numberProduct == 0) {
                              numberProduct = 0;
                            } else {
                              numberProduct--;
                            }
                          });
                        },
                        child: Container(
                          width: 25.0,
                          height: 25.0,
                          decoration: BoxDecoration(
                            color: Colors.blue[300],
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: 15.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                )
      ],
    );
  }

  Widget _Build_DataSeller() {
    return FutureBuilder<dynamic>(
          // future คือเรียกการฟีดข้อมูล
          future: NetworkService().getCategoryProductsByID(product.idCategoryProduct),
          // builder คือผลลัพธ์ที่จะส่งกลับมาให้เรา
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //var data = snapshot.data as List<Product>;
               data_seller = snapshot.data;
              // ทำการดึงข้อมูลมาใหม่
              return RefreshIndicator(
                child: _Show_DataSeller(data_seller),
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
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      backgroundColor: kMainColor,
                      strokeWidth: 7,
                    ),
                  )
                ],
              ),
            );
          },
        );
  }

  Widget _Show_DataSeller(CategoryProducts data_seller) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: kBG1Color, borderRadius: BorderRadius.circular(4)),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/icons/shop.png",
                width: 30,
                color: kMain1Color,
              ),
              Text(
                "รายละเอียดผู้ขาย",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          Divider(
            color: Colors.black26,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "ชื่อ",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    Spacer(),
                    Text("${data_seller.idSellerNavigation01.name}")
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "อีเมล",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    Spacer(),
                    Text("${data_seller.idSellerNavigation01.email}")
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "เบอร์โทร",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    Spacer(),
                    Text("${data_seller.idSellerNavigation01.tel}")
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "ที่อยู่",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    Spacer(),
                    Text("${data_seller.idSellerNavigation01.address}")
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _Colors_Product() {
    return Row(
      children: [
        Text(
          "สี${product.color}",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.grey
          ),
        )
      ],
    );
  }

  _Feed_DetailProduct_Image()async {
   await NetworkService().getDetailProductByID(widget.id_product).then((value){
     if(value.isNotEmpty){
         setState(() {
            detailProducts = value;
         });
     }else(){
       setState(() {
         
       });
       var dataDetailImage = DetailProducts(image: product.image);
       detailProducts.add(dataDetailImage);
     };
   });
  }

   _Feed_IDUser()async {
     var prefs = await SharedPreferences.getInstance();
    id_user = prefs.get(API.USER_ID) as int;
   }
}


class Detail_Product_Image extends StatefulWidget {
  late PageController pageController;
  late List<DetailProducts> DetailProductimages;
  late int index;
  late String Imagedefault;
  Detail_Product_Image(
      {Key? key,
      required this.DetailProductimages,
      required this.index,
      required this.Imagedefault})
      : pageController = PageController(initialPage: index),
        super(key: key);

  @override
  State<Detail_Product_Image> createState() => _Detail_Product_ImageState();
}

class _Detail_Product_ImageState extends State<Detail_Product_Image> {
 
  @override
  void initState() {
     List<DetailProducts> result = widget.DetailProductimages;
    // TODO: implement initState
    super.initState();
    if (result.isEmpty) {
      var dataDetailImage = DetailProducts(image: widget.Imagedefault);
     result.add(dataDetailImage);
    }
    
    
   // widget.DetailProductimages.where((e) => e.image.toLowerCase().contains(userInputValue.toLowerCase()).toList();
  
      
    
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:widget.DetailProductimages.isNotEmpty? _Show_DetailImage():Text("444444"),
    );
  }

  Widget _Show_DetailImage() {
     return Stack(
        alignment: Alignment.bottomLeft,
        children: [
          PhotoViewGallery.builder(
            pageController: widget.pageController,
            itemCount: widget.DetailProductimages.length,
            //scrollDirection: Axis.vertical,Imagedefault
            builder: (context, index) {
              //   .where((e) => e.name.toLowerCase().contains(data_Search))
              // .toList();
              final data = widget.DetailProductimages.reversed.toList();
              return PhotoViewGalleryPageOptions(
                  imageProvider:
                      NetworkImage("${API.BASE_URL}${data[index].image}"),
                  
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.contained * 4);
            },
            onPageChanged: (index) => setState(() {
              widget.index = index;
            }),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              "รูปภาพ ${widget.index + 1}/${widget.DetailProductimages.length}",
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          )
        ],
      );
  }
}
