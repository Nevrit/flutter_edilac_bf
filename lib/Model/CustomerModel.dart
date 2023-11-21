import 'dart:convert';

List<CustomerModel> customerFromJson(String str) => List<CustomerModel>.from(
    json.decode(str).map((x) => CustomerModel.fromJson(x)));

String customerToJson(List<CustomerModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomerModel {
  final int? id;
  final String name;
  final String? email;
  final String lieu;

  CustomerModel({
    this.id,
    required this.name,
    this.email,
    required this.lieu,
  });

  factory CustomerModel.fromMap(Map<String, dynamic> json) => new CustomerModel(
        id: json['id'],
        name: json['name'],
        email: json['email'].toString(),
        lieu: json['lieu'],
      );

  factory CustomerModel.fromJson(Map<String, dynamic> json) =>
      new CustomerModel(
        id: json['id'],
        name: json['name'],
        email: json['email'].toString(),
        lieu: json['lieu'],
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
      'email': email.toString(),
      'lieu': lieu,
    };
    return map;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email.toString(),
        'lieu': lieu,
      };
}
