import 'dart:convert';

List<StockLineModel> stocklineFromJson(String str) => List<StockLineModel>.from(
    json.decode(str).map((x) => StockLineModel.fromJson(x)));

String stocklineToJson(List<StockLineModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StockLineModel {
  late int? id;
  final int picking_id;
  final String product;
  final double? product_packaging_qty;
  final double? packaging_qty_done;
  final double product_packaging_price;
  final double? amount_tva;
  final double? amount_bic;
  final double? total_tva;
  final double? total_bic;
  // final double? amount_airsi;
  final double? price_subtotal;
  final double? price_total;
  final String? state;
  final String? is_done;

  StockLineModel({
    this.id,
    required this.picking_id,
    required this.product,
    this.product_packaging_qty,
    this.packaging_qty_done,
    required this.product_packaging_price,
    this.amount_tva,
    this.amount_bic,
    this.total_tva,
    this.total_bic,
    this.price_subtotal,
    this.price_total,
    this.state,
    this.is_done,
  });

  factory StockLineModel.fromMap(Map<String, dynamic> json) =>
      new StockLineModel(
        id: json['id'],
        picking_id: json['picking_id'],
        product: json['product'],
        product_packaging_qty: json['product_packaging_qty'],
        packaging_qty_done: json['packaging_qty_done'],
        product_packaging_price: json['product_packaging_price'],
        amount_tva: json['amount_tva'],
        amount_bic: json['amount_bic'],
        total_tva: json['total_tva'],
        total_bic: json['total_bic'],
        price_subtotal: json['price_subtotal'],
        price_total: json['price_total'],
        state: json['state'],
        is_done: json['is_done'],
      );

  factory StockLineModel.fromJson(Map<String, dynamic> json) =>
      new StockLineModel(
        id: json['id'],
        picking_id: json['picking_id'],
        product: json['product'],
        product_packaging_qty: json['product_packaging_qty'],
        packaging_qty_done: json['packaging_qty_done'],
        product_packaging_price: json['product_packaging_price'],
        amount_tva: json['amount_tva'],
        amount_bic: json['amount_bic'],
        total_tva: json['total_tva'],
        total_bic: json['total_bic'],
        price_subtotal: json['price_subtotal'],
        price_total: json['price_total'],
        state: json['state'],
        is_done: json['is_done'],
      );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'picking_id': picking_id,
      'product': product,
      'product_packaging_qty': product_packaging_qty,
      'packaging_qty_done': packaging_qty_done,
      'product_packaging_price': product_packaging_price,
      'amount_tva': amount_tva,
      'amount_bic': amount_bic,
      'total_tva': total_tva,
      'total_bic': total_bic,
      'price_subtotal': price_subtotal,
      'price_total': price_total,
      'state': state,
      'is_done': is_done,
    };
    return map;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'picking_id': picking_id,
        'product': product,
        'product_packaging_qty': product_packaging_qty,
        'packaging_qty_done': packaging_qty_done,
        'product_packaging_price': product_packaging_price,
        'amount_tva': amount_tva,
        'amount_bic': amount_bic,
        'total_tva': total_tva,
        'total_bic': total_bic,
        'price_subtotal': price_subtotal,
        'price_total': price_total,
        'state': state,
        'is_done': is_done,
      };
}
