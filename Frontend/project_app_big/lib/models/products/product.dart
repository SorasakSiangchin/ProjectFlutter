
import 'dart:convert';
List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

 Product productJson(String str) => Product.fromJson(json.decode(str));

// class IdCategoryProductNavigation {
//     IdCategoryProductNavigation({
//         required this.id,
//         required this.idSeller,
//         required this.categoryName,
//         required this.idSellerNavigation,
//         required this.product,
//     });

//     int id;
//     int idSeller;
//     String categoryName;
//     dynamic idSellerNavigation;
//     List<Product> product;

//     factory IdCategoryProductNavigation.fromJson(Map<String, dynamic> json) => IdCategoryProductNavigation(
//         id: json["id"],
//         idSeller: json["idSeller"],
//         categoryName: json["categoryName"],
//         idSellerNavigation: json["idSellerNavigation"],
//         product: List<Product>.from(json["product"].map((x) => Product.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "idSeller": idSeller,
//         "categoryName": categoryName,
//         "idSellerNavigation": idSellerNavigation,
//         "product": List<dynamic>.from(product.map((x) => x.toJson())),
//     };
// }

// class Product {
//     Product({
//          this.id = 0,
//          this.idCategoryProduct = 0,
//          this.name = "",
//          this.price = 0,
//          this.stock = 0,
//          this.color = "",
//          this.image = "",
//          required this.detailProduct ,
//          required this.list,
//          required this.productAdded,
//     });

//     int id;
//     int idCategoryProduct;
//     String name;
//     int price;
//     int stock;
//     String color;
//     String image;
//     List<dynamic> detailProduct;
//     List<dynamic> list;
//     List<dynamic> productAdded;

//     factory Product.fromJson(Map<String, dynamic> json) => Product(
//         id: json["id"],
//         idCategoryProduct: json["idCategoryProduct"],
//         name: json["name"],
//         price: json["price"],
//         stock: json["stock"],
//         color: json["color"],
//         image: json["image"],
       
//         detailProduct: List<dynamic>.from(json["detailProduct"].map((x) => x)),
//         list: List<dynamic>.from(json["list"].map((x) => x)),
//         productAdded: List<dynamic>.from(json["productAdded"].map((x) => x)),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "idCategoryProduct": idCategoryProduct,
//         "name": name,
//         "price": price,
//         "stock": stock,
//         "color": color,
//         "image": image,
//         "detailProduct": List<dynamic>.from(detailProduct.map((x) => x)),
//         "list": List<dynamic>.from(list.map((x) => x)),
//         "productAdded": List<dynamic>.from(productAdded.map((x) => x)),
//     };
// }
class Product {
    Product({
        this.id = 0,
        this.idCategoryProduct = 0,
        this.name = "",
        this.price = 0,
        this.stock = 0,
        this.color  = "",
        this.image  = "",
        required this.idCategoryProductNavigation,
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
    IdCategoryProductNavigation idCategoryProductNavigation;
    List<DetailProduct> detailProduct;
    List<dynamic> list;
    List<dynamic> productAdded;

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        idCategoryProduct: json["idCategoryProduct"],
        name: json["name"],
        price: json["price"],
        stock: json["stock"],
        color: json["color"],
        image: json["image"] ?? "",
        idCategoryProductNavigation: IdCategoryProductNavigation.fromJson(json["idCategoryProductNavigation"]),
        detailProduct: List<DetailProduct>.from(json["detailProduct"].map((x) => DetailProduct.fromJson(x))),
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
        "idCategoryProductNavigation": idCategoryProductNavigation.toJson(),
        "detailProduct": List<dynamic>.from(detailProduct.map((x) => x.toJson())),
        "list": List<dynamic>.from(list.map((x) => x)),
        "productAdded": List<dynamic>.from(productAdded.map((x) => x)),
    };
}

class DetailProduct {
    DetailProduct({
        this.id=0 ,
        this.idProduct=0,
        this.image  = "",
        this.weight  = "",
        this.dataMore  = "",
        this.size = "",
    });

    int id;
    int idProduct;
    String image;
    String weight;
    String dataMore;
    String size;

    factory DetailProduct.fromJson(Map<String, dynamic> json) => DetailProduct(
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

class IdCategoryProductNavigation {
    IdCategoryProductNavigation({
        this.id = 0,
        this.idSeller =0,
        this.categoryName  = "",
        required this.idSellerNavigation,
        required this.product,
    });

    int id;
    int idSeller;
    String categoryName;
    IdSellerNavigation idSellerNavigation;
    List<dynamic> product;

    factory IdCategoryProductNavigation.fromJson(Map<String, dynamic> json) => IdCategoryProductNavigation(
        id: json["id"],
        idSeller: json["idSeller"],
        categoryName: json["categoryName"],
        idSellerNavigation: IdSellerNavigation.fromJson(json["idSellerNavigation"]),
        product: List<dynamic>.from(json["product"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idSeller": idSeller,
        "categoryName": categoryName,
        "idSellerNavigation": idSellerNavigation.toJson(),
        "product": List<dynamic>.from(product.map((x) => x)),
    };
}

class IdSellerNavigation {
    IdSellerNavigation({
        this.id = 0,
        this.name  = "",
        this.tel = "",
        this.email = "",
        this.password = "",
        this.image = "",
        this.address  = "",
        required this.categoryProduct ,
        required this.orderProduct,
    });

    int id;
    String name;
    String tel;
    String email;
    String password;
    String image;
    String address;
    List<dynamic> categoryProduct;
    List<dynamic> orderProduct;

    factory IdSellerNavigation.fromJson(Map<String, dynamic> json) => IdSellerNavigation(
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
