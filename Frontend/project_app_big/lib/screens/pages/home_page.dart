// ignore_for_file: prefer_const_constructors, deprecated_member_use, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, non_constant_identifier_names, unnecessary_this, sized_box_for_whitespace, unnecessary_string_interpolations, avoid_print, unnecessary_cast, unused_element, unused_import, unnecessary_brace_in_string_interps

import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:project_app_big/constants/api.dart';
import 'package:project_app_big/constants/color.dart';
import 'package:project_app_big/models/products/product.dart';
import 'package:project_app_big/models/sqflites/cart_product_sqflite.dart';
import 'package:project_app_big/models/users/user.dart';
import 'package:project_app_big/screens/pages/order_products/order_product_confirm/order_product_comfirm.dart';
import 'package:project_app_big/screens/pages/products/detail_product.dart';
import 'package:project_app_big/screens/pages/order_products/order_product_payment.dart';
import 'package:project_app_big/screens/pages/shopping_cart_page.dart';
import 'package:project_app_big/services/network_servises.dart';
import 'package:project_app_big/sqflites/db/cart_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({Key? key}) : super(key: key);

  @override
  _Home_PageState createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  Color color = Color(0xFF5DADE2);
  bool isLoading = false;
  User data_user = User();
  bool status_Search = false;
  String data_Search = "";
  int number_cart = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _FeedData_User();
    _RefreshCrats();
  }

  final List<String> imgList = [
    'assets/images/slides/img_slider.jpg',
    'assets/images/slides/img_slider01.jpg',
    'assets/images/slides/img_slider02.jpg',
    'assets/images/slides/img_slider03.jpg',
    'assets/images/slides/img_slider04.jpg',
    'assets/images/slides/img_slider05.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // ยืดให้สุด
        backgroundColor: kBGColor,
        drawer: _NavigationDrawer(context),
        appBar: AppBar(
          backgroundColor: color,
          title: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: _InputSearch(),
          ),
          elevation: 3,
        ),
      body: _Home(),
    );
  }

  Widget _Product_New() {
    return FutureBuilder<List<Product>>(
      // future คือเรียกการฟีดข้อมูล
      future: NetworkService().getProductNew(),
      // builder คือผลลัพธ์ที่จะส่งกลับมาให้เรา
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //var data = snapshot.data as List<Product>;
          List<Product>? data = snapshot.data;
          // ทำการดึงข้อมูลมาใหม่
          return RefreshIndicator(
            child: Padding(
              padding: EdgeInsets.only(left: 6),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _Show_Product_New(data),
              ),
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

  Widget _Home() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              !status_Search ? _Show_Index() : _Show_Search(),
            ],
          ),
        ),
      ),
    );
  }

  // ข้อมูลสินค้า
  Widget _Show_Data([List<Product>? data]) {
    return Container(
      margin: EdgeInsets.only(
        top: 10,
      ),
      child: StaggeredGridView.countBuilder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        crossAxisCount: 4,
        itemCount: data!.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Detail_Product(
                  id_product: data[index].id,
                ),
              ),
            ).then((value) {
              _RefreshCrats();
            });
          },
          child: Container(
            width: 180.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                  child: Image(
                    image: NetworkImage(
                      "${API.BASE_URL}${data[index].image}",
                    ),
                    width: 200.0,
                    height: 160.0,
                    alignment: Alignment.center,
                    fit: BoxFit.cover,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            data[index].name,
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${data[index].price} ฿",
                            style: TextStyle(color: Colors.orange),
                          ),
                          Text(
                            "คลัง ${data[index].stock} ชิ้น",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Text(
                //   category,
                //   style: TextStyle(
                //     fontSize: 18.0,
                //     color: Colors.grey,
                //   ),
                // ),
                // Text(
                //   "$price ฿",
                //   style: TextStyle(fontSize: 22.0, color: Color(0xFFFF9900)),
                // ),
              ],
            ),
          ),
        ),
        staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
    );
  }

  // ดึงข้อมูลคนท่ login เข้ามา
  _FeedData_User() async {
    var prefs = await SharedPreferences.getInstance();
    int id = prefs.get(API.USER_ID) as int;
    if(id != 0){
 await NetworkService().getUser_ID(id).then(
          (value) => {
            setState(
              () {
                data_user = value as User;
              },
            ),
          },
        );
    }
   
  }

  // บาร์เลื่อน
  Widget _NavigationDrawer(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            _buildMenuItem(context),
          ],
        ),
      ),
    );
  }

// ส่วนหัวของบาร์เลื่อน
  Widget _buildHeader(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          color: kMainColor,
          child: Column(
            children:data_user.id != 0? [
              CircleAvatar(
                radius: 52,
                backgroundImage:
                    NetworkImage("${API.BASE_URL}${data_user.image}"),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                data_user.name,
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
              Text(
                data_user.email,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 12,
              ),
                  ]
                : [
                    SizedBox(
                      height: 12,
                    ),
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/icons/user.png'),
                      maxRadius: 40,

                    ),
                    SizedBox(
                      height: 12,
                    ),
                  ],
          ),
        ),
      ),
    );
  }

// ส่วนไอเทมของบาร์เลื่อน
  Widget _buildMenuItem(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 16,
        children: data_user.id == 0?[
         ListTile(
      leading: Image.asset(
        "assets/icons/login.png",
        width: 30,
        color: Colors.grey,
      ),
      title: Text(
        "เข้าสู่ระบบ",
        style: TextStyle(fontSize: 16),
      ),
      onTap: () async{
        Navigator.pop(context);
       await Navigator.pushNamed(context, '/login_page').then((value) {
          _FeedData_User();
        });
      },
    )
        ]: [
          _Item_Purchase(),
          _Item_Cart(),
          _Item_Profile(),
          _Item_LikeProduct(),
          _Item_Logout(),
        ],
      ),
    );
  }

  _onSearch(String value) async {
    if (value.isNotEmpty) {
      setState(() {
        status_Search = true;
        data_Search = value;
      });
    } else {
      setState(() {
        status_Search = false;
      });
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  // กล้องค้นหาข้อมูล
  Widget _InputSearch() {
    return TextFormField(
      onChanged: (value) => {
        _onSearch(value),
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(20.0),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        prefixIcon: Icon(
          Icons.search,
          color: Colors.grey,
        ),
        hintText: "ค้นหา...",
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }

  Widget _Show_Index() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20, right: 6, left: 6),
          child: CarouselSlider(
            items: imgList
                .map((item) => Container(
                      child: Center(
                        child: Image.asset(
                          item,
                          fit: BoxFit.cover,
                          width: 1000,
                        ),
                      ),
                    ))
                .toList(),
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 2.0,
              enlargeCenterPage: true,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "สินค้ามาใหม่",
            style: TextStyle(
              color: Colors.orange,
              fontSize: 28.0,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 270.0,
          child: _Product_New(),
        ),
        SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "สินค้าทั้งหมด",
            style: TextStyle(color: Colors.orange, fontSize: 28.0),
          ),
        ),
        //----------------------------- ข้อมูล --------------------------
        FutureBuilder<List<Product>>(
          // future คือเรียกการฟีดข้อมูล
          future: NetworkService().getProductAll(),
          // builder คือผลลัพธ์ที่จะส่งกลับมาให้เรา
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //var data = snapshot.data as List<Product>;
              List<Product>? data = snapshot.data;
              // ทำการดึงข้อมูลมาใหม่
              return RefreshIndicator(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _Show_Data(data),
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
        )
      ],
    );
  }

  Widget _Show_Search() {
    return FutureBuilder<List<Product>>(
      // future คือเรียกการฟีดข้อมูล
      future: NetworkService().getProductAll(),
      // builder คือผลลัพธ์ที่จะส่งกลับมาให้เรา
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //var data = snapshot.data as List<Product>;
          List<Product>? data = snapshot.data!
              .where((e) => e.name.toLowerCase().contains(data_Search))
              .toList();

          // ทำการดึงข้อมูลมาใหม่
          return RefreshIndicator(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: data.isNotEmpty ? _Show_Data(data) : _Alert_Search(),
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

  Widget _Alert_Search() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(
        top: 30,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "ไม่พบผลการค้นหา",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageIcon(
                AssetImage(
                  "assets/icons/note.png",
                ),
                size: 20,
                color: Colors.grey,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                "ลองใช้คำค้นหาอื่น",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _Show_Product_New(List<Product>? data) {
    List<Widget> s = data!
        .map((e) => GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Detail_Product(
                      id_product: e.id,
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(right: 10.0),
                width: 180.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                      child: Image(
                        image: NetworkImage("${API.BASE_URL}${e.image}"),
                        width: 180.0,
                        height: 160.0,
                        alignment: Alignment.center,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      e.name,
                      style: TextStyle(
                        fontSize: 22.0,
                      ),
                    ),
                    Text(
                      e.price.toString(),
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "${e.price.toString()} ฿",
                      style:
                          TextStyle(fontSize: 22.0, color: Color(0xFFFF9900)),
                    ),
                  ],
                ),
              ),
            ))
        .toList();
    return s;
  }

  Future _RefreshCrats() async {
    // เปิดปิดข้อมูล
    setState(() => isLoading = true);
    number_cart = await NotesDatabase.instance.cart_number();
    setState(() => isLoading = false);
  }
  
  //------------ item_mrnu ------------
  Widget _Item_Purchase() {
    return ListTile(
      leading: Image.asset(
        "assets/icons/my_purchase.png",
        width: 30,
        color: Colors.grey,
      ),
      title: Text(
        "การซื้อของฉัน",
        style: TextStyle(fontSize: 16),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, '/my_purchase_page');
      },
    );
  }

  Widget _Item_Cart() {
    return ListTile(
      leading: Badge(
          padding: EdgeInsets.all(4),
          toAnimate: false,
          badgeColor: kBG1Color,
          shape: BadgeShape.circle,
          position: BadgePosition.topEnd(),
          //showBadge: false,
          badgeContent: Text(
            '${number_cart}',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: Image.asset(
            "assets/icons/shopping.png",
            width: 30,
            color: Colors.grey,
        ),
      ),
      title: Text("ตะกร้าสินค้า"),
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Shopping_Cart_Page(),
          ),
        );
      },
    );
  }

  Widget _Item_Profile() {
    return ListTile(
      leading: Image.asset(
        "assets/icons/profile_cuttom.png",
        width: 30,
        color: Colors.grey,
      ),
      title: Text("ฉัน"),
      onTap: () {
        Navigator.pushNamed(context, '/profile_page', arguments: data_user.id)
            .then(
          (value) => _FeedData_User(),
        );
      },
    );
  }

  Widget _Item_LikeProduct() {
    return ListTile(
      leading: Image.asset(
        "assets/icons/heart.png",
        width: 30,
        color: Colors.grey,
      ),
      title: Text("ที่ฉันชอบ"),
      onTap: () {
        Navigator.pushNamed(context, '/like_product_page');
      },
    );
  }

  Widget _Item_Logout() {
    return ListTile(
      leading: Image.asset(
        "assets/icons/logout.png",
        width: 30,
        color: Colors.grey,
      ),
      title: Text("ออกจากระบบ"),
      onTap: _logout,
    );
  }
  //-----------------------------------
  _logout() {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.warning,
      title: "ออกจากระบบหรือไม่",
      onConfirmBtnTap: () async {
        var prefs = await SharedPreferences.getInstance();
        prefs.remove(API.ISLOGIN);
        prefs.remove(API.USER_ID);
        Navigator.pop(context);
        Navigator.pushNamed(context, '/');
      },
      confirmBtnText: "ตกลง",
      cancelBtnTextStyle: TextStyle(),
      cancelBtnText: 'ยกเลิก',
      onCancelBtnTap: () {
        Navigator.pop(context);
      },
      showCancelBtn: true,
    );
  }
}
