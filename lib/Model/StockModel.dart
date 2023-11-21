import 'dart:convert';

List<PickingModel> stockFromJson(String str) => List<PickingModel>.from(
    json.decode(str).map((x) => PickingModel.fromJson(x)));

String stockToJson(List<PickingModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PickingModel {
  final int id;
  final String? name;
  final String? date_prevue;
  final String? date_effective;
  final int delivery_agent_id;
  final String? delivery_agent_name;
  final int? customer_id;
  final String? customer_name;
  final String? delivery_zone;
  final int? sale_order_id;
  final String? sale_order_name;
  final double? amount_total;
  final double? amount_paid;
  final String? state;
  final String? validate;

  PickingModel(
      {required this.id,
      this.name,
      this.date_prevue,
      this.date_effective,
      required this.delivery_agent_id,
      required this.delivery_agent_name,
      required this.customer_id,
      required this.customer_name,
      this.delivery_zone,
      this.sale_order_id,
      this.sale_order_name,
      this.amount_total,
      this.amount_paid,
      this.state,
      this.validate});

  factory PickingModel.fromMap(Map<String, dynamic> json) => new PickingModel(
        id: json['id'],
        name: json['name'],
        date_prevue: json['date_prevue'],
        date_effective: json['date_effective'],
        delivery_agent_id: json['delivery_agent_id'],
        delivery_agent_name: json['delivery_agent_name'],
        customer_id: json['customer_id'],
        customer_name: json['customer_name'],
        delivery_zone: json['delivery_zone'],
        sale_order_id: json['sale_order_id'],
        sale_order_name: json['sale_order_name'],
        amount_total: json['amount_total'],
        amount_paid: json['amount_paid'],
        state: json['state'],
        validate: json['validate'],
      );

  factory PickingModel.fromJson(Map<String, dynamic> json) => new PickingModel(
        id: json['id'],
        name: json['name'],
        date_prevue: json['date_prevue'],
        date_effective: json['date_effective'],
        delivery_agent_id: json['delivery_agent_id'],
        delivery_agent_name: json['delivery_agent_name'],
        customer_id: json['customer_id'],
        customer_name: json['customer_name'],
        delivery_zone: json['delivery_zone'],
        sale_order_id: json['sale_order_id'],
        sale_order_name: json['sale_order_name'],
        amount_total: json['amount_total'],
        amount_paid: json['amount_paid'],
        state: json['state'],
        validate: json['validate'],
      );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'date_prevue': date_prevue,
      'date_effective': date_effective,
      'delivery_agent_id': delivery_agent_id,
      'delivery_agent_name': delivery_agent_name,
      'customer_id': customer_id,
      'customer_name': customer_name,
      'delivery_zone': delivery_zone,
      'sale_order_id': sale_order_id,
      'sale_order_name': sale_order_name,
      'amount_total': amount_total,
      'amount_paid': amount_paid,
      'state': state,
      'validate': validate,
    };
    return map;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'date_prevue': date_prevue,
        'date_effective': date_effective,
        'delivery_agent_id': delivery_agent_id,
        'delivery_agent_name': delivery_agent_name,
        'customer_id': customer_id,
        'customer_name': customer_name,
        'delivery_zone': delivery_zone,
        'sale_order_id': sale_order_id,
        'sale_order_name': sale_order_name,
        'amount_total': amount_total,
        'amount_paid': amount_paid,
        'state': state,
        'validate': validate,
      };
}
