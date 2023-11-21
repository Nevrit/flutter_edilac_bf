import 'dart:convert';

List<ZoneModel> ZoneFromJson(String str) =>
    List<ZoneModel>.from(json.decode(str).map((x) => ZoneModel.fromJson(x)));

String ZoneToJson(List<ZoneModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ZoneModel {
  final int id;
  final String name;
  final String lieu;

  ZoneModel({
    required this.id,
    required this.name,
    required this.lieu,
  });

  factory ZoneModel.fromMap(Map<String, dynamic> json) => new ZoneModel(
        id: json['id'],
        name: json['name'],
        lieu: json['lieu'],
      );

  factory ZoneModel.fromJson(Map<String, dynamic> json) => ZoneModel(
        id: json['id'],
        name: json['name'],
        lieu: json['lieu'],
      );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'lieu': lieu,
    };
    return map;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'lieu': lieu,
      };
}
