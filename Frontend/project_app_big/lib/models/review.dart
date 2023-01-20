// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);

import 'dart:convert';
List<Review> reviewFromJson(String str) => List<Review>.from(json.decode(str).map((x) => Review.fromJson(x)));

String reviewToJson(List<Review> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);


class IdListNavigation {
    IdListNavigation({
        this.id= "",
        this.idOrder = "",
        this.idProduct = 0,
        this.priceProduct = 0,
        this.numberProduct = 0,
        this.idOrderNavigation,
        this.idProductNavigation,
        required this.review,
    });

    String id;
    String idOrder;
    int idProduct;
    int priceProduct;
    int numberProduct;
    dynamic idOrderNavigation;
    dynamic idProductNavigation;
    List<Review> review;

    factory IdListNavigation.fromJson(Map<String, dynamic> json) => IdListNavigation(
        id: json["id"],
        idOrder: json["idOrder"],
        idProduct: json["idProduct"],
        priceProduct: json["priceProduct"],
        numberProduct: json["numberProduct"],
        idOrderNavigation: json["idOrderNavigation"],
        idProductNavigation: json["idProductNavigation"],
        review: List<Review>.from(json["review"].map((x) => Review.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idOrder": idOrder,
        "idProduct": idProduct,
        "priceProduct": priceProduct,
        "numberProduct": numberProduct,
        "idOrderNavigation": idOrderNavigation,
        "idProductNavigation": idProductNavigation,
        "review": List<dynamic>.from(review.map((x) => x.toJson())),
    };
}

class Review {
    Review({
        this.id = "",
        required this.idList,
        this.data = "",
        required this.date,
        this.image = "",
    });

    String id;
    String idList;
    String data;
    DateTime date;
    String image;

    factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        idList: json["idList"],
        data: json["data"] == null ? null : json["data"],
        date: DateTime.parse(json["date"]),
        image: json["image"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idList": idList,
        "data": data == null ? null : data,
        "date": date.toIso8601String(),
        "image": image,
    };
}
