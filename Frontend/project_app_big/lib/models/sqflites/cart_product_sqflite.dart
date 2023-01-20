// ignore_for_file: non_constant_identifier_names, camel_case_types, unnecessary_this, prefer_const_declarations

final String tableNotes = 'cart';

class NoteFields {
  static final List<String> values = [
    /// Add all fields
    id, name, image, price, stock, number_product
  ];
  
  static final String id = '_id';
  static final String name = 'name';
  static final String image = 'image';
  static final String price = 'price';
  static final String stock = 'stock';
  static final String number_product = 'number_product';
}

class Cart_Product_Sqflite {
   int id;
   String name;
   String image;
   int price;
   int stock;
   int number_product;

   Cart_Product_Sqflite({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.stock,
    required this.number_product,
  });
  
  Cart_Product_Sqflite copy({
    int? id,
    bool? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createdTime,
  }) =>
      Cart_Product_Sqflite(
        id: id ?? this.id,
        name: name,
        image: image,
        price: price,
        stock: stock,
        number_product: number_product,
      );

  static Cart_Product_Sqflite fromJson(Map<String, Object?> json) => Cart_Product_Sqflite(
        id: json[NoteFields.id] as int,
        name: json[NoteFields.name]  as String,
        image: json[NoteFields.image] as String,
        price: json[NoteFields.price] as int,
        stock: json[NoteFields.stock] as int,
        number_product:json[NoteFields.number_product] as int,
      );

  Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.name: name,
        NoteFields.image: image ,
        NoteFields.price: price,
        NoteFields.stock: stock,
        NoteFields.number_product: number_product,
      };
}
