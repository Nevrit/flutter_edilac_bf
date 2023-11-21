import 'dart:convert';

List<UserModel> employeeFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String employeeToJson(List<UserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  final int id;
  final String name;
  final String login;
  final String password;

  UserModel(
      {required this.id,
      required this.name,
      required this.login,
      required this.password});

  factory UserModel.fromMap(Map<String, dynamic> json) => new UserModel(
      id: json['id'],
      name: json['name'],
      login: json['login'],
      password: json['password']);

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'],
      name: json['name'],
      login: json['login'],
      password: json['password']);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'login': login,
      'password': password
    };
    return map;
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'login': login, 'password': password};
}
