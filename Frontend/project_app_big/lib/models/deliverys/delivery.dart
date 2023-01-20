// To parse this JSON data, do
//
//     final delivery = deliveryFromJson(jsonString);
// To parse this JSON data, do
//
//     final delivery = deliveryFromJson(jsonString);

import 'dart:convert';

 List<Delivery> deliveryFromJson_list(String str) => List<Delivery>.from(json.decode(str).map((x) => Delivery.fromJson(x)));
 Delivery deliveryFromJson(String str) => Delivery.fromJson(json.decode(str));

class Delivery {
    Delivery({
         this.id = 0,
        this.idOrder = "",
        this.idStatusDelivery = 0,
        required this.date,
        this.idOrderNavigation,
        required this.idStatusDeliveryNavigation,
    });

    int id;
    String idOrder;
    int idStatusDelivery;
    DateTime date;
    dynamic idOrderNavigation;
    IdStatusDeliveryNavigation idStatusDeliveryNavigation;

    factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
        id: json["id"],
        idOrder: json["idOrder"],
        idStatusDelivery: json["idStatusDelivery"],
        date: DateTime.parse(json["date"]),
        idOrderNavigation: json["idOrderNavigation"],
        idStatusDeliveryNavigation: IdStatusDeliveryNavigation.fromJson(json["idStatusDeliveryNavigation"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idOrder": idOrder,
        "idStatusDelivery": idStatusDelivery,
        "date": date.toIso8601String(),
        "idOrderNavigation": idOrderNavigation,
        "idStatusDeliveryNavigation": idStatusDeliveryNavigation.toJson(),
    };
}

class IdStatusDeliveryNavigation {
    IdStatusDeliveryNavigation({
        this.id = 0,
        this.statusName = "",
        required this.delivery,
    });

    int id;
    String statusName;
    List<dynamic> delivery;

    factory IdStatusDeliveryNavigation.fromJson(Map<String, dynamic> json) => IdStatusDeliveryNavigation(
        id: json["id"],
        statusName: json["statusName"],
        delivery: List<dynamic>.from(json["delivery"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "statusName": statusName,
        "delivery": List<dynamic>.from(delivery.map((x) => x)),
    };
}





// import 'dart:convert';

// List<Delivery> deliveryFromJson_list(String str) => List<Delivery>.from(json.decode(str).map((x) => Delivery.fromJson(x)));
// Delivery deliveryFromJson(String str) => Delivery.fromJson(json.decode(str));

// String deliveryToJson(Delivery data) => json.encode(data.toJson());

// class Delivery {
//     Delivery({
//         this.id = 0,
//         this.idOrder = "",
//         this.idStatusDelivery = 0,
//         required this.date,
//         this.idOrderNavigation,
//         this.idStatusDeliveryNavigation,
//     });

//     int id;
//     String idOrder;
//     int idStatusDelivery;
//     DateTime date;
//     dynamic idOrderNavigation;
//     dynamic idStatusDeliveryNavigation;

//     factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
//         id: json["id"],
//         idOrder: json["idOrder"],
//         idStatusDelivery: json["idStatusDelivery"],
//         date: DateTime.parse(json["date"]),
//         idOrderNavigation: json["idOrderNavigation"],
//         idStatusDeliveryNavigation: json["idStatusDeliveryNavigation"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "idOrder": idOrder,
//         "idStatusDelivery": idStatusDelivery,
//         "date": date.toIso8601String(),
//         "idOrderNavigation": idOrderNavigation,
//         "idStatusDeliveryNavigation": idStatusDeliveryNavigation,
//     };
// }
