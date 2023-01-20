// ignore_for_file: prefer_const_declarations, non_constant_identifier_names

final String table_cancel_product = 'cancel_product_01';

class CancelProductFields {
  static final List<String> values = [
    /// Add all fields
    id, isImportant, name, id_product, image, price , stock , number_product
  ];

  static final String id = '_id';
  static final String isImportant = 'isImportant';
  static final String name = 'name';
  static final String id_product = 'id_product';
  static final String image = 'image';
  static final String price = 'price';
  static final String stock = 'stock';
  static final String number_product = 'number_product';
}

class CancelProduct {
  final int? id;
  final bool isImportant;
  final String name;
  final String id_product;
  final String image;
  final String price;
  final String stock;
  final String number_product;

  const CancelProduct({
    this.id,
    required this.isImportant,
    required this.name,
    required this.id_product,
    required this.image,
    required this.price,
    required this.stock,
    required this.number_product,
  });

  CancelProduct copy({
  int? id,
   bool? isImportant,
   String? name,
  String? id_product,
   String? image,
   String? price,
   String? stock,
   String? number_product,
  }) =>
      CancelProduct(
        id: id ?? this.id,
        isImportant: isImportant ?? this.isImportant,
        name: name ?? this.name,
        id_product: id_product ?? this.id_product,
        image: image ?? this.image,
        price: price ?? this.price,
        stock: stock ?? this.stock,
        number_product: number_product ?? this.number_product,
      );

  static CancelProduct fromJson(Map<String, Object?> json) => CancelProduct(
        id: json[CancelProductFields.id] as int?,
        isImportant: json[CancelProductFields.isImportant] == 1,
        name: json[CancelProductFields.name] as String,
        id_product: json[CancelProductFields.id_product] as String,
        image: json[CancelProductFields.image] as String,
        price:json[CancelProductFields.price] as String,
        stock:json[CancelProductFields.stock] as String,
        number_product:json[CancelProductFields.number_product] as String,
      );

  Map<String, Object?> toJson() => {
        CancelProductFields.id: id,
        CancelProductFields.isImportant: isImportant ? 1 : 0,
        CancelProductFields.name: name,
        CancelProductFields.id_product: id_product,
        CancelProductFields.image: image,
        CancelProductFields.price: price,
        CancelProductFields.stock: stock,
        CancelProductFields.number_product: number_product,
      };
}
