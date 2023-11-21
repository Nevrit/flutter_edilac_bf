import 'dart:convert';

List<ProductModel> productFromJson(String str) => List<ProductModel>.from(
    json.decode(str).map((x) => ProductModel.fromJson(x)));

String productToJson(List<ProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
  final int? id;
  final String name;

  ProductModel({
    this.id,
    required this.name,
  });

  factory ProductModel.fromMap(Map<String, dynamic> json) => new ProductModel(
        id: json['id'],
        name: json['name'],
      );

  factory ProductModel.fromJson(Map<String, dynamic> json) => new ProductModel(
        id: json['id'],
        name: json['name'],
      );

  // factory UserModel.fromMap(Map<String, dynamic> map) => new UserModel(
  //   user_id = map['user_id'],
  //   user_name = map['user_name'],
  //   email = map['email'],
  //   password = map['password'],
  //   );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
    };
    return map;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
