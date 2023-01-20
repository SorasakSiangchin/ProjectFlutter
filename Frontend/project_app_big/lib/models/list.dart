// To parse this JSON data, do
//
//     final lists = listsFromJson(jsonString);

import 'dart:convert';
List<Lists> listsFromJson(String str) => List<Lists>.from(json.decode(str).map((x) => Lists.fromJson(x)));

String productToJson(List<Lists> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Lists {
    Lists({
        this.id = "",
        this.idOrder = "",
        this.idProduct = 0,
        this.priceProduct = 0,
        this.numberProduct = 0,
        this.idOrderNavigation,
        required this.idProductNavigation,
        required this.review,
    });

    String id;
    String idOrder;
    int idProduct;
    int priceProduct;
    int numberProduct;
    dynamic idOrderNavigation;
    IdProductNavigation idProductNavigation;
    List<dynamic> review;

    factory Lists.fromJson(Map<String, dynamic> json) => Lists(
        id: json["id"],
        idOrder: json["idOrder"],
        idProduct: json["idProduct"],
        priceProduct: json["priceProduct"],
        numberProduct: json["numberProduct"],
        idOrderNavigation: json["idOrderNavigation"],
        idProductNavigation: IdProductNavigation.fromJson(json["idProductNavigation"]),
        review: List<dynamic>.from(json["review"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idOrder": idOrder,
        "idProduct": idProduct,
        "priceProduct": priceProduct,
        "numberProduct": numberProduct,
        "idOrderNavigation": idOrderNavigation,
        "idProductNavigation": idProductNavigation.toJson(),
        "review": List<dynamic>.from(review.map((x) => x)),
    };
}

class IdProductNavigation {
    IdProductNavigation({
        this.id = 0,
        this.idCategoryProduct = 0,
        this.name = "",
        this.price = 0,
        this.stock = 0,
        this.color = "",
        this.image = "",
        this.idCategoryProductNavigation,
        required this.detailProduct,
        required this.list,
        required this.productAdded,
    });

    int id;
    int idCategoryProduct;
    String name;
    int price;
    int stock;
    String color;
    String image;
    dynamic idCategoryProductNavigation;
    List<dynamic> detailProduct;
    List<dynamic> list;
    List<dynamic> productAdded;

    factory IdProductNavigation.fromJson(Map<String, dynamic> json) => IdProductNavigation(
        id: json["id"],
        idCategoryProduct: json["idCategoryProduct"],
        name: json["name"],
        price: json["price"],
        stock: json["stock"],
        color: json["color"],
        image: json["image"],
        idCategoryProductNavigation: json["idCategoryProductNavigation"],
        detailProduct: List<dynamic>.from(json["detailProduct"].map((x) => x)),
        list: List<dynamic>.from(json["list"].map((x) => x)),
        productAdded: List<dynamic>.from(json["productAdded"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idCategoryProduct": idCategoryProduct,
        "name": name,
        "price": price,
        "stock": stock,
        "color": color,
        "image": image,
        "idCategoryProductNavigation": idCategoryProductNavigation,
        "detailProduct": List<dynamic>.from(detailProduct.map((x) => x)),
        "list": List<dynamic>.from(list.map((x) => x)),
        "productAdded": List<dynamic>.from(productAdded.map((x) => x)),
    };
}
