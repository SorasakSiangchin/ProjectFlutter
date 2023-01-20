// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

// import 'dart:convert';
// List<Order> orderFromJson(String str) => List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

// String orderToJson(List<Order> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class Order {
//     Order({
//         this.id ="",
//         this.idUser=0,
//         this.statusMoney = false,
//         this.proofTransfer,
//         required this.date ,
//         this.priceTotal = 0,
//         required this.idUserNavigation,
//         required this.delivery,
//         required this.list,
//     });

//     String id;
//     int idUser;
//     bool statusMoney;
//     dynamic proofTransfer;
//     DateTime date;
//     int priceTotal;
//     IdUserNavigation idUserNavigation;
//     List<dynamic> delivery;
//     List<ListElement> list;

//     factory Order.fromJson(Map<String, dynamic> json) => Order(
//         id: json["id"],
//         idUser: json["idUser"],
//         statusMoney: json["statusMoney"],
//         proofTransfer: json["proofTransfer"],
//         date: DateTime.parse(json["date"]),
//         priceTotal: json["priceTotal"],
//         idUserNavigation: IdUserNavigation.fromJson(json["idUserNavigation"]),
//         delivery: List<dynamic>.from(json["delivery"].map((x) => x)),
//         list: List<ListElement>.from(json["list"].map((x) => ListElement.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "idUser": idUser,
//         "statusMoney": statusMoney,
//         "proofTransfer": proofTransfer,
//         "date": date.toIso8601String(),
//         "priceTotal": priceTotal,
//         "idUserNavigation": idUserNavigation.toJson(),
//         "delivery": List<dynamic>.from(delivery.map((x) => x)),
//         "list": List<dynamic>.from(list.map((x) => x.toJson())),
//     };
// }

// class IdUserNavigation {
//     IdUserNavigation({
//         this.id = 0,
//         this.name = "",
//         this.email = "",
//         this.password = "",
//         this.address= "",
//         this.tel ="",
//         this.image,
//         required this.order ,
//     });

//     int id;
//     String name;
//     String email;
//     String password;
//     String address;
//     String tel;
//     dynamic image;
//     List<dynamic> order;

//     factory IdUserNavigation.fromJson(Map<String, dynamic> json) => IdUserNavigation(
//         id: json["id"],
//         name: json["name"],
//         email: json["email"],
//         password: json["password"],
//         address: json["address"],
//         tel: json["tel"],
//         image: json["image"] ?? '',
//         order: List<dynamic>.from(json["order"].map((x) => x)),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "email": email,
//         "password": password,
//         "address": address,
//         "tel": tel,
//         "image": image,
//         "order": List<dynamic>.from(order.map((x) => x)),
//     };
// }

// class ListElement {
//     ListElement({
//         this.id = "",
//         this.idOrder = "",
//         this.idProduct = 0,
//         this.priceProduct = 0,
//         this.numberProduct = 0,
//         this.idProductNavigation,
//         required this.review,
//     });

//     String id;
//     String idOrder;
//     int idProduct;
//     int priceProduct;
//     int numberProduct;
//     dynamic idProductNavigation;
//     List<dynamic> review;

//     factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
//         id: json["id"],
//         idOrder: json["idOrder"],
//         idProduct: json["idProduct"],
//         priceProduct: json["priceProduct"],
//         numberProduct: json["numberProduct"],
//         idProductNavigation: json["idProductNavigation"],
//         review: List<dynamic>.from(json["review"].map((x) => x)),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "idOrder": idOrder,
//         "idProduct": idProduct,
//         "priceProduct": priceProduct,
//         "numberProduct": numberProduct,
//         "idProductNavigation": idProductNavigation,
//         "review": List<dynamic>.from(review.map((x) => x)),
//     };
// }



//------------------------------------------------------------
// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);
// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

List<Order> orderFromJson(String str) => List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String orderToJson(List<Order> data) => json.encode(List<Order>.from(data.map((x) => x.toJson())));
class Order {
    Order({
        this.id = "",
        this.statusMoney = false,
        this.proofTransfer ="",
        required this.date,
        this.priceTotal = 0,
        this.statusForUser = false,
        this.idAddress = "",
        this.idAddressNavigation,
        required this.list,
    });

    String id;
    bool statusMoney;
    String proofTransfer;
    DateTime date;
    int priceTotal;
    bool statusForUser;
    String idAddress;
    dynamic idAddressNavigation;
    List<ListElement> list;

    factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        statusMoney: json["statusMoney"],
        proofTransfer: json["proofTransfer"] ??"",
        date: DateTime.parse(json["date"]),
        priceTotal: json["priceTotal"],
        statusForUser: json["statusForUser"],
        idAddress: json["idAddress"],
        idAddressNavigation: json["idAddressNavigation"],
        list: List<ListElement>.from(json["list"].map((x) => ListElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "statusMoney": statusMoney,
        "proofTransfer": proofTransfer,
        "date": date.toIso8601String(),
        "priceTotal": priceTotal,
        "statusForUser": statusForUser,
        "idAddress": idAddress,
        "idAddressNavigation": idAddressNavigation,
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
    };
}

class ListElement {
    ListElement({
        this.id = "",
        this.idOrder= "",
        this.idProduct = 0,
        this.priceProduct = 0,
        this.numberProduct = 0,
        this.idProductNavigation,
        required this.review,
    });

    String id;
    String idOrder;
    int idProduct;
    int priceProduct;
    int numberProduct;
    dynamic idProductNavigation;
    List<dynamic> review;

    factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        id: json["id"],
        idOrder: json["idOrder"],
        idProduct: json["idProduct"],
        priceProduct: json["priceProduct"],
        numberProduct: json["numberProduct"],
        idProductNavigation: json["idProductNavigation"] ?? '',
        review: List<dynamic>.from(json["review"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idOrder": idOrder,
        "idProduct": idProduct,
        "priceProduct": priceProduct,
        "numberProduct": numberProduct,
        "idProductNavigation": idProductNavigation,
        "review": List<dynamic>.from(review.map((x) => x)),
    };
}

// class Order {
//     Order({
//         this.id = "",
//         this.statusMoney = false,
//         this.proofTransfer = "",
//         required this.date,
//         this.priceTotal =  0,
//         this.statusForUser = false,
//         this.idAddress = "",
//         required this.idAddressNavigation,
//         required this.delivery ,
//         required this.list,
//     });

//     String id;
//     bool statusMoney;
//     String proofTransfer;
//     DateTime date;
//     int priceTotal;
//     bool statusForUser;
//     String idAddress;
//     IdAddressNavigation idAddressNavigation;
//     List<dynamic> delivery;
//     List<dynamic> list;

//     factory Order.fromJson(Map<String, dynamic> json) => Order(
//         id: json["id"],
//         statusMoney: json["statusMoney"],
//         proofTransfer: json["proofTransfer"] ?? '',
//         date: DateTime.parse(json["date"]),
//         priceTotal: json["priceTotal"],
//         statusForUser: json["statusForUser"],
//         idAddress: json["idAddress"],
//         idAddressNavigation: IdAddressNavigation.fromJson(json["idAddressNavigation"]),
//         delivery: List<dynamic>.from(json["delivery"].map((x) => x)),
//         list: List<dynamic>.from(json["list"].map((x) => x)),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "statusMoney": statusMoney,
//         "proofTransfer": proofTransfer,
//         "date": date.toIso8601String(),
//         "priceTotal": priceTotal,
//         "statusForUser": statusForUser,
//         "idAddress": idAddress,
//         "idAddressNavigation": idAddressNavigation.toJson(),
//         "delivery": List<dynamic>.from(delivery.map((x) => x)),
//         "list": List<dynamic>.from(list.map((x) => x)),
//     };
// }

// class IdAddressNavigation {
//     IdAddressNavigation({
//         this.id = "",
//         this.idUser = 0,
//         this.idDataAddress = "",
//         this.idDataAddressNavigation,
//         this.idUserNavigation,
//         required this.order,
//     });

//     String id;
//     int idUser;
//     String idDataAddress;
//     dynamic idDataAddressNavigation;
//     dynamic idUserNavigation;
//     List<dynamic> order;

//     factory IdAddressNavigation.fromJson(Map<String, dynamic> json) => IdAddressNavigation(
//         id: json["id"],
//         idUser: json["idUser"],
//         idDataAddress: json["idDataAddress"],
//         idDataAddressNavigation: json["idDataAddressNavigation"],
//         idUserNavigation: json["idUserNavigation"],
//         order: List<dynamic>.from(json["order"].map((x) => x)),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "idUser": idUser,
//         "idDataAddress": idDataAddress,
//         "idDataAddressNavigation": idDataAddressNavigation,
//         "idUserNavigation": idUserNavigation,
//         "order": List<dynamic>.from(order.map((x) => x)),
//     };
// }
