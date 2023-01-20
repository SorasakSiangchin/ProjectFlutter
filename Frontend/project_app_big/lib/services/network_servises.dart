// ignore_for_file: unused_local_variable, non_constant_identifier_names, prefer_typing_uninitialized_variables, unnecessary_brace_in_string_interps, unnecessary_string_interpolations

import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:project_app_big/constants/api.dart';
import 'package:project_app_big/models/addresses/address.dart';
import 'package:project_app_big/models/addresses/data_address.dart';
import 'package:project_app_big/models/products/categor_product.dart';
import 'package:project_app_big/models/products/detail_product.dart';
import 'package:project_app_big/models/sqflites/cart_product_sqflite.dart';
import 'package:project_app_big/models/deliverys/delivery.dart';
import 'package:project_app_big/models/deliverys/delivery_data.dart';
import 'package:project_app_big/models/list.dart';
import 'package:project_app_big/models/order.dart';
import 'package:project_app_big/models/products/product.dart';
import 'package:project_app_big/models/review.dart';
import 'package:project_app_big/models/users/user.dart';
import 'package:project_app_big/models/users/user_login.dart';

class NetworkService {
  //สร้างออบแบบ single ton คือจองพื้นที่หน่วยความจาเรียบร้อยแล้ว
  NetworkService._internal();
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  //interceptors เพื่อกำหนดค่าเริ่มต้นบางอย่าง
  var dio = Dio()
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.baseUrl = API.BASE_URL;
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioError e, handler) {
          // ถ้ามันมี Error ใดๆ
          e.error = 'การเชื่อมต่อผิดพลาด';
          return handler.next(e);
        },
      ),
    );
  // -----------


 


  
  //====================== User ======================================================================
    // ถ้ามีการส่งข้อมูลไปยัง Backend ต้องมี async กับ await เสมอ
  Future<List<String>> login(User_Login user) async {
    var url = API.LOGIN;
    var logindata = FormData.fromMap(
      {'email': user.email, 'password': user.password},
    );
    // await ต้องใส่เดียว data Error
    var response = await dio.post(url, data: logindata);
    String msg = response.data['msg'];
    String uid = response.data['uid'];
    return [msg, uid];
  }

    Future<User> getUser_ID(int id_uder) async {
    var url = API.USER;
    var result = await dio.get("$url/$id_uder");
    User data = userFromJson(json.encode(result.data['data']));
    return data;
  }

  //----------- register -------------
  Future<String> register(User user, {File? imageFile}) async {
    const url = API.REGISTER;
    // form ของ dart
    FormData data = FormData.fromMap(
      {
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'password': user.password,
        'tel': user.tel,

        // MultipartFile ถ้าไม่มีจะส่งไฟล์ไม่ได้
        // ถ้าจะส่งเป็นไฟล์ต้อง object MultipartFile
        if (imageFile!.path.isNotEmpty)
          // MultipartFile ถ้าไม่มีจะส่งไฟล์ไม่ได้
          // ถ้าจะส่งเป็นไฟล์ต้อง object MultipartFile
          'upfile': await MultipartFile.fromFile(
            // contentType: MediaType('image', 'jpg'),
            // imageFile.path ยัดรูปภาพใส่ให้ upfile
            imageFile.path,
          )
      },
    );
    String msg;

    // Response ทำการ map ผลลัพธ์ให้โดยอัตโนมัติ
    final response = await dio.post(url, data: data);
    msg = response.data["msg"];

    return msg;
  }
  
  
  Future<String> putUser(int user_id , String key , String data_new) async {
    var url_user = API.USER;
    var url_putdata = API.PUTDATA;
    var userdata = FormData.fromMap(
      {
        "id":user_id,
        key: data_new,
      },
    );
    // await ต้องใส่เดียว data Error
    var response = await dio.put("${url_user}/${url_putdata}", data: userdata);
    String msg = response.data['msg'];
    return msg ;
  }

  Future<String> putUser_image({required int user_id ,required File imageFile}) async {
    var url_user = API.USER;
    var url_image = API.PUTIMAGE;
    var userdata = FormData.fromMap(
      {
        "id":user_id,
         if (imageFile.path.isNotEmpty)
          // MultipartFile ถ้าไม่มีจะส่งไฟล์ไม่ได้
          // ถ้าจะส่งเป็นไฟล์ต้อง object MultipartFile
          'upfile': await MultipartFile.fromFile(
            // contentType: MediaType('image', 'jpg'),
            // imageFile.path ยัดรูปภาพใส่ให้ upfile
            imageFile.path,
          )
      },
    );
    // await ต้องใส่เดียว data Error
    var response = await dio.put("${url_user}/${url_image}", data: userdata);
    String msg = response.data['msg'];
    return msg ;
  }
  //==================================================================================================
 

  //====================== Order =====================================================================
   Future<String> postOrderProducts_Many(List<Cart_Product_Sqflite> order_product,
      {int? totalProduct,String? Address_id}) async {
    var url = API.ORDER;
     //List<FormData> data_all = [];
    late FormData data;
    List<int> idproduck = [];
    List<int> numberproduct = [];
    List<int> priceproduct = [];
    for (var i = 0; i < order_product.length; i++) {
      idproduck.add(order_product[i].id);
      numberproduct.add(order_product[i].number_product);
      priceproduct.add(order_product[i].price);
    }
    data = FormData.fromMap({
      'idproduck': idproduck,
      'numberproduct': numberproduct,
      'idaddress': Address_id,
      'priceproduct': priceproduct,
      'pricetotal': totalProduct,
    });
    //await ต้องใส่เดียว data Error
    final Response response = await dio.post(
      url ,
      data: data,
    );
    var msg = response.data['msg'];
    return "msg" ;
  }

  Future<List<Lists>> getList_IDOrder(String id_order) async {
    var url = API.LIST;
    var result = await dio.get("$url/$id_order");
    List<Lists> data = listsFromJson(json.encode(result.data));
    return data;
  }

  Future<String> postOrderProduct_Alone(Cart_Product_Sqflite order_product,
      {double? totalProduct,String? Address_id}) async {
    var url = API.ORDER;
    //  List<FormData> data_all = [];
    late FormData data;
    data = FormData.fromMap({
      'idproduck': order_product.id,
      'numberproduct': order_product.number_product,
      'idaddress': Address_id,
      'priceproduct': order_product.price,
      'pricetotal': order_product.price,
    });
    //await ต้องใส่เดียว data Error
    final Response response = await dio.post(
      url,
      data: data,
    );
    var msg = response.data['msg'];
    return msg ;
  }

  //----------- getOrder --------------------
  Future<List<Order>> getOrder() async {
    var url = API.ORDER;
    var result = await dio.get(url);
    var data = orderFromJson(json.encode(result.data));
    return data;
  }

  //----------- getOrder statusMoney---------
  Future<List<Order>> getOrder_statusMoney() async {
    var Smoney = API.STATUSMONEY;
    var result = await dio.get(Smoney);
    var data = orderFromJson(json.encode(result.data));
    return data;
  }

  //----------- getOrder ToGet---------------
  Future<List<Order>> getOrder_toGet() async {
    var toget = API.TOGET;
    var result = await dio.get(toget);
    var data = orderFromJson(json.encode(result.data));
    return data;
  }
  //----------- getOrder Succeed---------------
  Future<List<Order>> getOrder_Succeed() async {
    var succeed = API.SUCCEED;
    var result = await dio.get(succeed);
    var data = orderFromJson(json.encode(result.data));
    return data;
  }
  
  Future<String> putOrder_Upload(Order order, {File? imageFile}) async {
    const url = API.ORDER;
    // form ของ dart
    FormData data = FormData.fromMap(
      {
        'id': order.id,
        if (imageFile!.path.isNotEmpty)
          // MultipartFile ถ้าไม่มีจะส่งไฟล์ไม่ได้
          // ถ้าจะส่งเป็นไฟล์ต้อง object MultipartFile
          'upfile': await MultipartFile.fromFile(
            // contentType: MediaType('image', 'jpg'),
            // imageFile.path ยัดรูปภาพใส่ให้ upfile
            imageFile.path,
          )
      },
    );
    String msg;
    try {
      // Response ทำการ map ผลลัพธ์ให้โดยอัตโนมัติ
      final Response response = await dio.put(url, data: data);
      msg = response.data["msg"];
    } catch (e) {
      msg = 'Network error';
    }
    return msg;
  }

  Future<String> putOrder_Confirm_Product(Order order) async {
    const url = API.TOGET;
    // form ของ dart
    FormData data = FormData.fromMap(
      {'id': order.id, 'statusforuser': true},
    );
    String msg;
    try {
      // Response ทำการ map ผลลัพธ์ให้โดยอัตโนมัติ
      final Response response = await dio.put(url, data: data);
      msg = response.data["msg"];
    } catch (e) {
      msg = 'Network error';
    }
    return msg;
  }
  
  //----------- getDelivery Order---------------
  Future<Delivery> getDelivery_Order(String id) async {
    var delivery = API.DELIVERY;
    var result = await dio.get("$delivery/$id");
    var data = result.data['data'];
    var data_result = deliveryFromJson(json.encode(data));
    return data_result;  
  }
  //==========================================================================================================
  



  //========================== Product =======================================================================
  Future<List<Product>> getProductAll() async {
    var url = API.PRODUCTAll;
    var result = await dio.get(url);
    var data = productFromJson(json.encode(result.data));
    return data;
  }

  Future<List<Product>> getProductNew() async {
    var url = API.PRODUCTNEW;
    var result = await dio.get(url);
    var data = productFromJson(json.encode(result.data));
    return data;
  }
  
  Future<Product> getProductID (int id) async {
     var product = API.APIPRODUCT;
    var result = await dio.get("$product/$id");
    var data = result.data['data'];
    var data_result = productJson(json.encode(data));
    return data_result;  
  }
  //==========================================================================================================



  //======================= Review ===========================================================================
  Future<String> postReviewProduct({required Lists List,required File imageFile ,required String dataReview }) async {
    var url = API.REVIEW;
    //  List<FormData> data_all = [];
    late FormData data;
    data = FormData.fromMap({
      'idlist':List.id,
      'dataReview':"$dataReview",
      if (imageFile.path.isNotEmpty)
          // MultipartFile ถ้าไม่มีจะส่งไฟล์ไม่ได้
          // ถ้าจะส่งเป็นไฟล์ต้อง object MultipartFile
          'upfile': await MultipartFile.fromFile(
            // contentType: MediaType('image', 'jpg'),
            // imageFile.path ยัดรูปภาพใส่ให้ upfile
            imageFile.path,
          )
    });
    //await ต้องใส่เดียว data Error
    final Response response = await dio.post(
      url,
      data: data,
    );
    var msg = response.data['msg'];
    return msg;
  }
  
  Future<List<Review>> getReview_Data_id(int id) async {
    var review = API.REVIEW;
    var result = await dio.get("ApiReviews/$id");
    var msg = result.data['data'];
    var data = reviewFromJson(json.encode(msg));
    return data;  
  }

    Future<User> getDataUserByID(String id) async {
    var url = API.REVIEWUSER;
    var result = await dio.get("$url/$id");
    var data = result.data['data'];
    var data_result = userToJson01(json.encode(data));
    print(data_result.id);
    return data_result;  
  }
  //==========================================================================================================



  //=========================== Delivery =====================================================================
   Future<List<DeliveryData>> getDelivery_Data() async {
    var delivery = API.DELIVERY;
    var delivery_data = API.Delivery_Data;
    var result = await dio.get("$delivery/$delivery_data");
    var data = deliveryDataFromJson(json.encode(result.data));
    return data;  
  }
  //==========================================================================================================
 


  

  //=========================== List ========================================================================
     Future<String> deleteProduct_list(String id)async {
      final url = "${API.LIST}/${id}";
      String msg;
      try {
        // Response ทำการ map ผลลัพธ์ให้โดยอัตโนมัติ
        final Response response = await dio.delete(url);
        // var result = response.data['result'] as Product;
        // msg = '${result.id}';
        msg = 'OK';
      } catch (e) {
        msg = 'Network error';
      }
      return msg;
    }
  //=========================================================================================================

  
   //====================== Address =====================================================================
     Future<List<Address>> getAddressByID(int id) async {
    var address = API.ADDRESS;
    var result = await dio.get("$address/$id");
    var data = result.data['data'];
    var data_result = addressFromJson(json.encode(data));
    return data_result;  
  }
   //====================================================================================================


   //==================== DataAddress ===================================================================
   //---------- post_DataAddress -------------
   Future<String> post_DataAddress({required DataAddress data_address,required int id_user}) async {
    const url = API.ADDRESS;
    // form ของ dart
    FormData data = FormData.fromMap(
      {
        'id': data_address.id,
        'addressdata': data_address.addressData,
        'addressdetail': data_address.addressDetail,
        'username': data_address.userName,
        'teluser': data_address.telUser,
        'iduser':id_user
      },
    );
    String msg;

    // Response ทำการ map ผลลัพธ์ให้โดยอัตโนมัติ
    final response = await dio.post(url, data: data);
    msg = response.data["msg"];

    return msg;
  }
  
  Future<DataAddress> getDataAddressByID(String id) async {
    var url = API.DATAADDRESS;
    var result = await dio.get("$url/$id");
    var data = result.data['data'];
    var data_result = dataAddressToJson(json.encode(data));
    return data_result;  
  }

  Future<String> delete_DataAddress(String id_address) async {
    final url = "${API.ADDRESS}/${id_address}";
      String msg;
      try {
        // Response ทำการ map ผลลัพธ์ให้โดยอัตโนมัติ
        final Response response = await dio.delete(url);
        // var result = response.data['result'] as Product;
        // msg = '${result.id}';
        msg = 'OK';
      } catch (e) {
        msg = 'Network error';
      }
      return msg;
  }
   //====================================================================================================




   //========================= CategoryProducts =========================================================
    Future<CategoryProducts> getCategoryProductsByID(int id) async {
    var url = API.CATEGORYPRODUCT;
   var result = await dio.get("$url/$id");
    var data = result.data['data'];
    var data_result = categoryProductsToJson(json.encode(data));
    return data_result;  
  }
   //====================================================================================================




   //======================= DetailProduct ==============================================================
    Future<List<DetailProducts>> getDetailProductByID(int id) async {
    var url = API.DETAILPRODUCT;
    var result = await dio.get("$url/$id");
    var data = result.data;
    var data_result = detailProductFromJson(json.encode(data));
    return data_result;  
  }
   //====================================================================================================
}
