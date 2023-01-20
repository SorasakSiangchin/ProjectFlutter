// ignore_for_file: non_constant_identifier_names, camel_case_types, unnecessary_this, prefer_const_declarations, unnecessary_string_interpolations

final String tableLikeProduct = 'like_products_bd';

class LikeProductFields {
  static final List<String> values = [
    /// Add all fields
    id, name, image, price, stock, color , status
  ];
  
  static final String id = '_id';
  static final String name = 'name';
  static final String image = 'image';
  static final String price = 'price';
  static final String stock = 'stock';
  static final String color = 'color';
  static final String status = 'status';
  
}

class LikeProduct {
   int id;
   String name;
   String image;
   int price;
   int stock;
   String color;
   bool status = false;
   LikeProduct({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.stock,
    required this.color,
     required this.status,
  });
  
  LikeProduct copy({
    int? id,
    String? name,
    String? image,
    int? price,
    int? stock,
    String? color,
     bool? status,
  }) =>
      LikeProduct(
        id: id?? this.id,
        name: name?? this.name,
        image: image?? this.image,
        price: price?? this.price,
        stock: stock?? this.stock,
        color: color?? this.color,
        status: status?? this.status,
      );

  static LikeProduct fromJson(Map<String, Object?> json) => LikeProduct(
        id: json[LikeProductFields.id] as int ,
        name: json[LikeProductFields.name]  as String,
        image: json[LikeProductFields.image] as String,
        price: json[LikeProductFields.price] as int,
        stock: json[LikeProductFields.stock] as int,
        color:json[LikeProductFields.color] as String,
        status:json[LikeProductFields.status] == 1,
      );

  Map<String, Object?> toJson() => {
        LikeProductFields.id: id ,
        LikeProductFields.name: name,
        LikeProductFields.image: image ,
        LikeProductFields.price: price,
        LikeProductFields.stock: stock,
        LikeProductFields.color: color,
        LikeProductFields.status: status? 1 : 0,
      };
}
