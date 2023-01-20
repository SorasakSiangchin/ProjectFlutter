// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:project_app_big/screens/pages/delivery/delivery_order_product.dart';
import 'package:project_app_big/screens/pages/like_product_page.dart';
import 'package:project_app_big/screens/pages/order_products/order_list_address.dart';
import 'package:project_app_big/screens/pages/order_products/order_product_confirm/order_product_confirm_add_address.dart';
import 'package:project_app_big/screens/pages/order_products/order_product_confirm/order_product_list_confirm.dart';
import 'package:project_app_big/screens/pages/home_page.dart';
import 'package:project_app_big/screens/pages/login_page.dart';
import 'package:project_app_big/screens/pages/my_purchase_page.dart';
import 'package:project_app_big/screens/pages/order_products/order_product_list_detail.dart';
import 'package:project_app_big/screens/pages/order_products/order_product_payment.dart';
import 'package:project_app_big/screens/pages/order_products/order_product_list.dart';
import 'package:project_app_big/screens/pages/payment/payment_upload.dart';
import 'package:project_app_big/screens/pages/profiles/edit_password_page.dart';
import 'package:project_app_big/screens/pages/profiles/edit_profile_page.dart';
import 'package:project_app_big/screens/pages/profiles/profile_page.dart';
import 'package:project_app_big/screens/pages/register_page.dart';
import 'package:project_app_big/screens/pages/review/review_order_product.dart';
import 'package:project_app_big/screens/pages/review/review_product.dart';
import 'package:project_app_big/screens/pages/review/review_product_data.dart';
import 'package:project_app_big/screens/pages/shopping_cart_page.dart';
import 'package:project_app_big/screens/pages/test.dart';


class Routes {
  static Map<String, WidgetBuilder> getRoute() {
    return <String, WidgetBuilder>{
        '/login_page':(_) => Login_Page(),
        '/':(_)=> Home_Page(),//home_page
        '/register_page':(_)=> Register_Page(),
        '/shopping_cart_page':(_)=>Shopping_Cart_Page(),
       // '/order_product_list':(_)=>Order_Product_List(),
       //'/order_product_list_detail':(_)=>Order_Product_List_Detail(),
        '/order_product':(_)=>Order_Product(),
        '/my_purchase_page':(_)=>My_Purchase_Page(),
        '/payment_data':(_)=>Payment_Data(),
        '/delivery_order_product':(_)=>Delivery_Order_Product(),
        '/review_order_product':(_)=>Review_Order_Product(),
        '/review_product':(_)=>Review_Product(),
        '/review_product_data':(_)=>Review_Product_Data(),
        '/order_product_list_comfirm':(_)=>Order_Product_List_Comfirm(),
        "/profile_page":(_)=>Profile_Page(),
        '/edit_profile_page':(_)=>Edit_Product_Page(),
        '/edit_password':(_)=>Edit_Password_Page(),
        '/order_list_address':(_)=>Order_List_Address(),
        '/like_product_page':(_)=>Like_Product_Page(),
        '/order_product_confirm_add_address':(_)=>Order_Product_Confirm_Add_Address(),
        '/test':(_)=>Test()
    };
  }
}
// '/':(_) => Login_Page(),
//         '/home_page':(_)=> Home_Page(),
//         '/register_page':(_)=> Register_Page(),
//         '/shopping_cart_page':(_)=>Shopping_Cart_Page(),
//        // '/order_product_list':(_)=>Order_Product_List(),
//        //'/order_product_list_detail':(_)=>Order_Product_List_Detail(),
//         '/order_product':(_)=>Order_Product(),
//         '/my_purchase_page':(_)=>My_Purchase_Page(),
//         '/payment_data':(_)=>Payment_Data(),
//         '/delivery_order_product':(_)=>Delivery_Order_Product(),
//         '/review_order_product':(_)=>Review_Order_Product(),
//         '/review_product':(_)=>Review_Product(),
//         '/review_product_data':(_)=>Review_Product_Data(),
//         '/order_product_list_comfirm':(_)=>Order_Product_List_Comfirm(),
//         "/profile_page":(_)=>Profile_Page(),
//         '/edit_profile_page':(_)=>Edit_Product_Page(),
//         '/edit_password':(_)=>Edit_Password_Page(),
//         '/order_list_address':(_)=>Order_List_Address(),
//         '/like_product_page':(_)=>Like_Product_Page(),
//         '/order_product_confirm_add_address':(_)=>Order_Product_Confirm_Add_Address(),
//         '/test':(_)=>Test()