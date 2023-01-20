
import 'dart:convert';
List<CategoryProducts> categoryProductsFromJson(String str) => List<CategoryProducts>.from(json.decode(str).map((x) => CategoryProducts.fromJson(x)));

 CategoryProducts categoryProductsToJson(String str) => CategoryProducts.fromJson(json.decode(str));


class CategoryProducts {
    CategoryProducts({
        this.id = 0,
        this.idSeller = 0,
        this.categoryName = "",
        required this.idSellerNavigation01,
    });

    int id;
    int idSeller;
    String categoryName;
    IdSellerNavigation01 idSellerNavigation01;

    factory CategoryProducts.fromJson(Map<String, dynamic> json) => CategoryProducts(
        id: json["id"],
        idSeller: json["idSeller"],
        categoryName: json["categoryName"],
        idSellerNavigation01: IdSellerNavigation01.fromJson(json["idSellerNavigation"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idSeller": idSeller,
        "categoryName": categoryName,
        "idSellerNavigation": idSellerNavigation01.toJson(),
    };
}

class IdSellerNavigation01 {
    IdSellerNavigation01({
        this.id = 0,
        this.name = "",
        this.tel = "",
        this.email = "",
        this.password = "",
        this.image,
        this.address  = "",
        required this.categoryProduct,
        required this.orderProduct,
    });

    int id;
    String name;
    String tel;
    String email;
    String password;
    dynamic image;
    String address;
    List<dynamic> categoryProduct;
    List<dynamic> orderProduct;

    factory IdSellerNavigation01.fromJson(Map<String, dynamic> json) => IdSellerNavigation01(
        id: json["id"],
        name: json["name"],
        tel: json["tel"],
        email: json["email"],
        password: json["password"],
        image: json["image"] ?? "",
        address: json["address"],
        categoryProduct: List<dynamic>.from(json["categoryProduct"].map((x) => x)),
        orderProduct: List<dynamic>.from(json["orderProduct"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "tel": tel,
        "email": email,
        "password": password,
        "image": image,
        "address": address,
        "categoryProduct": List<dynamic>.from(categoryProduct.map((x) => x)),
        "orderProduct": List<dynamic>.from(orderProduct.map((x) => x)),
    };
}
