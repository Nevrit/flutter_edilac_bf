import 'dart:convert';

List<SaleOrderModel> stockFromJson(String str) => List<SaleOrderModel>.from(
    json.decode(str).map((x) => SaleOrderModel.fromJson(x)));

String stockToJson(List<SaleOrderModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SaleOrderModel {
  final int id;
  final String name;
  final String date_order;
  final int user_id;
  final int partner_id;
  final int? zone_id;
  final String? payment_mode;
  final double amount_untaxed;
  final double amount_tax;
  // final double? amount_timbre;
  final double? amount_bic;
  final double amount_total;
  final String state;
  final String? is_done;

  SaleOrderModel(
      {required this.id,
      required this.name,
      required this.date_order,
      required this.user_id,
      required this.partner_id,
      this.payment_mode,
      this.zone_id,
      required this.amount_untaxed,
      required this.amount_tax,
      // this.amount_timbre,
      this.amount_bic,
      required this.amount_total,
      required this.state,
      this.is_done,});

  factory SaleOrderModel.fromMap(Map<String, dynamic> json) =>
      new SaleOrderModel(
        id: json['id'],
        name: json['name'],
        date_order: json['date_order'],
        user_id: json['user_id'],
        partner_id: json['partner_id'],
        payment_mode: json['payment_mode'],
        zone_id: json['zone_id'],
        amount_untaxed: json['amount_untaxed'],
        amount_tax: json['amount_tax'],
        // amount_timbre: json['amount_timbre'],
        amount_bic: json['amount_bic'],
        amount_total: json['amount_total'],
        state: json['state'],
      );

  factory SaleOrderModel.fromJson(Map<String, dynamic> json) =>
      new SaleOrderModel(
        id: json['id'],
        name: json['name'],
        date_order: json['date_order'],
        user_id: json['user_id'],
        partner_id: json['partner_id'],
        payment_mode: json['payment_mode'],
        zone_id: json['zone_id'],
        amount_untaxed: json['amount_untaxed'],
        amount_tax: json['amount_tax'],
        // amount_timbre: json['amount_timbre'],
        amount_bic: json['amount_bic'],
        amount_total: json['amount_total'],
        state: json['state'],
      );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'date_order': date_order,
      'user_id': user_id,
      'partner_id': partner_id,
      'payment_mode': payment_mode,
      'zone_id': zone_id,
      'amount_untaxed': amount_untaxed,
      'amount_tax': amount_tax,
      // 'amount_timbre': amount_timbre,
      'amount_bic': amount_bic,
      'amount_total': amount_total,
      'state': state,
    };
    return map;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'date_order': date_order,
        'user_id': user_id,
        'partner_id': partner_id,
        'payment_mode': payment_mode,
        'zone_id': zone_id,
        'amount_untaxed': amount_untaxed,
        'amount_tax': amount_tax,
        // 'amount_timbre': amount_timbre,
        'amount_bic': amount_bic,
        'amount_total': amount_total,
        'state': state,
      };
}
