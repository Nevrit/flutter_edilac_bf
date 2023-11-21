import 'dart:convert';

List<CashModel> stockFromJson(String str) =>
    List<CashModel>.from(json.decode(str).map((x) => CashModel.fromJson(x)));

String stockToJson(List<CashModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CashModel {
  final int? id;
  final String? date;
  final int user_id;
  final int partner_id;
  final int? sale_id;
  final int? picking_id;
  final double? amount;
  final double? receive_amount;
  final double? recveive_amount_espece;
  final double? recveive_amount_cheque;
  final double? receive_amount_momo;
  final double? amount_tva;
  final double? amount_bic;

  final double? change;
  final double? creance;
  final String? state;
  final String? is_done;

  CashModel({
    this.id,
    this.date,
    required this.user_id,
    required this.partner_id,
    this.sale_id,
    this.picking_id,
    this.amount,
    this.receive_amount,
    this.recveive_amount_espece,
    this.recveive_amount_cheque,
    this.receive_amount_momo,
    this.amount_tva,
    this.amount_bic,
    this.change,
    this.creance,
    this.state,
    this.is_done,
  });

  factory CashModel.fromMap(Map<String, dynamic> json) => new CashModel(
        id: json['id'],
        date: json['date'],
        user_id: json['user_id'],
        partner_id: json['partner_id'],
        sale_id: json['sale_id'],
        picking_id: json['picking_id'],
        amount: json['amount'],
        receive_amount: json['receive_amount'],
        recveive_amount_espece: json['recveive_amount_espece'],
        recveive_amount_cheque: json['recveive_amount_cheque'],
        receive_amount_momo: json['receive_amount_momo'],
        amount_tva: json['amount_tva'],
        amount_bic: json['amount_bic'],
        // recveive_amount_timbre: json['recveive_amount_timbre'],
        change: json['change'],
        creance: json['creance'],
        state: json['state'],
        is_done: json['is_done'],
      );

  factory CashModel.fromJson(Map<String, dynamic> json) => new CashModel(
        id: json['id'],
        date: json['date'],
        user_id: json['user_id'],
        partner_id: json['partner_id'],
        sale_id: json['sale_id'],
        picking_id: json['picking_id'],
        amount: json['amount'],
        receive_amount: json['receive_amount'],
        recveive_amount_espece: json['recveive_amount_espece'],
        recveive_amount_cheque: json['recveive_amount_cheque'],
        receive_amount_momo: json['receive_amount_momo'],
        amount_tva: json['amount_tva'],
        amount_bic: json['amount_bic'],
        // recveive_amount_timbre: json['recveive_amount_timbre'],
        change: json['change'],
        creance: json['creance'],
        state: json['state'],
        is_done: json['is_done'],
      );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'date': date,
      'user_id': user_id,
      'partner_id': partner_id,
      'sale_id': sale_id,
      'picking_id': picking_id,
      'amount': amount,
      'receive_amount': receive_amount,
      'recveive_amount_espece': recveive_amount_espece,
      'recveive_amount_cheque': recveive_amount_cheque,
      'receive_amount_momo': receive_amount_momo,
      'amount_tva': amount_tva,
      'amount_bic': amount_bic,
      // 'recveive_amount_timbre': recveive_amount_timbre,
      'change': change,
      'creance': creance,
      'state': state,
      'is_done': is_done,
    };
    return map;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'user_id': user_id,
        'partner_id': partner_id,
        'sale_id': sale_id,
        'picking_id': picking_id,
        'amount': amount,
        'receive_amount': receive_amount,
        'recveive_amount_espece': recveive_amount_espece,
        'recveive_amount_cheque': recveive_amount_cheque,
        'receive_amount_momo': receive_amount_momo,
        'amount_tva': amount_tva,
        'amount_bic': amount_bic,
        'change': change,
        'creance': creance,
        'state': state,
        'is_done': is_done,
      };
}
