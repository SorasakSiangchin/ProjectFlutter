// To parse this JSON data, do
//
//     final detailProduct = detailProductFromJson(jsonString);

import 'dart:convert';
List<DetailProducts> detailProductFromJson(String str) => List<DetailProducts>.from(json.decode(str).map((x) => DetailProducts.fromJson(x)));

 DetailProducts detailProductToJson(String str) => DetailProducts.fromJson(json.decode(str));

class DetailProducts {
    DetailProducts({
        this.id = "",
        this.idProduct = 0,
        this.image = "",
        this.weight = "",
        this.dataMore = "",
        this.size = "",
    });

    String id;
    int idProduct;
    String image;
    String weight;
    String dataMore;
    String size;

    factory DetailProducts.fromJson(Map<String, dynamic> json) => DetailProducts(
        id: json["id"],
        idProduct: json["idProduct"],
        image: json["image"] ?? "",
        weight: json["weight"],
        dataMore: json["dataMore"],
        size: json["size"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idProduct": idProduct,
        "image": image,
        "weight": weight,
        "dataMore": dataMore,
        "size": size,
    };
}
