import 'dart:convert';

List<StockDeliveryModel> stockFromJson(String str) =>
    List<StockDeliveryModel>.from(
        json.decode(str).map((x) => StockDeliveryModel.fromJson(x)));

String stockToJson(List<StockDeliveryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StockDeliveryModel {
  final int id;
  final String name;
  final int agent;
  final String? date_start;
  final String? date_end;
  final String state;
  final int is_ok;

  StockDeliveryModel(
      {required this.id,
      required this.name,
      required this.agent,
      this.date_start,
      this.date_end,
      required this.state,
      required this.is_ok});

  factory StockDeliveryModel.fromMap(Map<String, dynamic> json) =>
      new StockDeliveryModel(
        id: json['id'],
        name: json['name'],
        agent: json['agent'],
        date_start: json['date_start'],
        date_end: json['date_end'],
        state: json['state'],
        is_ok: json['is_ok'],
      );

  factory StockDeliveryModel.fromJson(Map<String, dynamic> json) =>
      new StockDeliveryModel(
        id: json['id'],
        name: json['name'],
        agent: json['agent'],
        date_start: json['date_start'],
        date_end: json['date_end'],
        state: json['state'],
        is_ok: json['is_ok'],
      );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'agent': agent,
      'date_start': date_start,
      'date_end': date_end,
      'state': state,
      'is_ok': is_ok,
    };
    return map;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'agent': agent,
        'date_start': date_start,
        'date_end': date_end,
        'state': state,
        'is_ok': is_ok,
      };
}
