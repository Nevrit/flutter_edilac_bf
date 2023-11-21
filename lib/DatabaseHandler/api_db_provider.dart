import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'db_provider.dart';
import '../Model/UserModel.dart';
import '../Model/StockModel.dart';
import '../Model/StockLineModel.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

// var urls = "halltech-ci-edilac-bf.odoo.com";
// var urls = "halltech-ci-edilac-bf-stage-10068883.dev.odoo.com";
var headers = {"Content-Type": "application/json"};
var params = {"jsonrpc": "2.0", "params": {}};
// var params = {
//   "jsonrpc": "2.0",
//   "params": {"company_code": "CI"}
// };
var company_code = "BF";
// var company_code = "CI";
// var sessionCookie;

final storage = FlutterSecureStorage();

class MyStorageFunctions {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> createStorage(String session, String db, String url, String name,
      int uid, String profile) async {
    await _storage.write(key: 'session_token', value: session);
    await _storage.write(key: 'database', value: db);
    await _storage.write(key: 'url', value: url);
    await _storage.write(key: 'name_user', value: name);
    await _storage.write(key: 'user_id', value: uid.toString());
    await _storage.write(key: 'profile', value: profile);
  }

  Future<Map<String, String>> readStorageInfo() async {
    String? nameUser = await _storage.read(key: 'name_user');
    String? sessionToken = await _storage.read(key: 'session_token');
    String? database = await _storage.read(key: 'database');
    String? url = await _storage.read(key: 'url');
    String? userId = await _storage.read(key: 'user_id');
    String? profile = await _storage.read(key: 'profile');

    Map<String, String> storageInfo = {
      'name_user': nameUser ?? '',
      'session_token': sessionToken ?? '',
      'database': database ?? '',
      'url': url ?? '',
      'user_id': userId ?? '',
      'profile': profile ?? '',
    };

    return storageInfo;
  }
}

MyStorageFunctions storageFunctions = MyStorageFunctions();
Map<String, String> storageInfo = {};

class UserApiProvider {
  register_user(id, name, login, password) async {
    var res = await DBProvider.instance.getUserId(id);
    if (res != null) {
      print("$res exist");
    } else {
      await DBProvider.instance.createEmployee(UserModel(
        id: id,
        name: name,
        login: login,
        password: password,
      ));
    }
  }

  getAllEmployees(login, passw) async {
    storageInfo = await storageFunctions.readStorageInfo();
    String? urls = storageInfo['url'];
    String? sessionToken = storageInfo['session_token'];
    if (sessionToken != null) {
      var url = Uri.https(urls!, 'web/session/authenticate');
      var params_ = {
        "params": {
          // "db": "halltech-ci-edilac-bf-production-10008466",
          "login": login,
          "password": passw
        }
      };
      var response = await http.post(url, body: jsonEncode(params_), headers: {
        'Content-Type': "application/json",
      });

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        sessionToken = response.headers['set-cookie'];
        print("Authentification");
        print(sessionToken);
        if (body['result'] != null) {
          register_user(body['result']['uid'], body['result']['name'],
              body['result']['username'], passw);
          var apiProvider = StockApiProvider();
          apiProvider.getAllStock();
        } else {
          print("error");
        }
      } else {
        throw Exception('Unable to fetch from the REST API');
      }
    } else {
      throw Exception(
          'La session token est nulle. Vous devez vous authentifier.');
    }
  }
}

class StockLineApiProvider {
  register_stock_line(
    id,
    picking_id,
    product,
    product_packaging_qty,
    packaging_qty_done,
    product_packaging_price,
    amount_tva,
    amount_bic,
  ) async {
    // var res = await DBProvider.instance.getStockLineId(id);
    var res = await DBProvider.instance.getStockLineStockId(id);
    if (res != null) {
      print("$res exist Line Stock");

      // print("$res updates Stock line");
    } else {
      await DBProvider.instance.createStockLine(StockLineModel(
        id: id,
        picking_id: picking_id,
        product: product,
        product_packaging_qty: product_packaging_qty,
        packaging_qty_done: packaging_qty_done,
        product_packaging_price: product_packaging_price,
        amount_tva: amount_tva,
        amount_bic: amount_bic,
        total_bic: 0.0,
        total_tva: 0.0,
        price_subtotal: 0.0,
        price_total: 0.0,
        state: 'draft',
        is_done: 'non',
      ));
      // print("Create stock line");
      // alertDialog(context, "Successfully Saved");
    }
  }

  getAllStockLine() async {
    var params_ = {
      'data': jsonEncode(params),
    };
    storageInfo = await storageFunctions.readStorageInfo();
    String? urls = storageInfo['url'];
    String? sessionToken = storageInfo['session_token'];
    if (sessionToken != null) {
      var url = Uri.https(urls!, 'api/get_pickings', params_);
      headers = {
        "Content-Type": "application/json",
        'Cookie': sessionToken,
      };
      var requestBody = jsonEncode(params_);
      var response = await http.post(
        url,
        headers: headers,
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        print("Move line");
        print(sessionToken);

        print(body);
        // return body;
        if (body['result'] != null) {
          final responseList = body['result']['response'] as List;
          if (responseList.isNotEmpty) {
            print(body['result']['response']);
            return responseList.map((stock) {
              for (var line in stock['move_line']) {
                print(
                    "Prix des produit ${line['product']} : ${line['product_packaging_price']}");
                register_stock_line(
                  line['id'],
                  line['picking_id'],
                  line['product'],
                  line['product_packaging_qty'],
                  line['packaging_qty_done'],
                  line['product_packaging_price'],
                  line['amount_tva'],
                  line['amount_bic'],
                );
              }
              // DBProvider.instance.createstock(StockModel.fromJson(stock));
            }).toList();
          } else {
            // Aucune donnée disponible
            return [];
          }
        }
      } else {
        // print(response.body);
        throw Exception('Unable to fetch data from the REST API');
      }
    } else {
      throw Exception(
          'La session token est nulle. Vous devez vous authentifier.');
    }
  }
}

class StockApiProvider {
  register_stock_line(
    id,
    picking_id,
    product,
    product_packaging_qty,
    packaging_qty_done,
    product_packaging_price,
    amount_tva,
    amount_bic,
  ) async {
    // var res = await DBProvider.instance.getStockLineId(id);
    var res = await DBProvider.instance.getStockLineStockId(id);
    if (res != null) {
      print("$res exist Line Stock");

      // print("$res updates Stock line");
    } else {
      await DBProvider.instance.createStockLine(StockLineModel(
        id: id,
        picking_id: picking_id,
        product: product,
        product_packaging_qty: product_packaging_qty,
        packaging_qty_done: packaging_qty_done,
        product_packaging_price: product_packaging_price,
        amount_tva: amount_tva,
        amount_bic: amount_bic,
        total_bic: 0.0,
        total_tva: 0.0,
        price_subtotal: 0.0,
        price_total: 0.0,
        state: 'draft',
        is_done: 'non',
      ));
      // print("Create stock line");
      // alertDialog(context, "Successfully Saved");
    }
  }

  register_stock(
      id,
      name,
      date_prevue,
      date_effective,
      delivery_agent_id,
      delivery_agent_name,
      customer_id,
      customer_name,
      delivery_zone,
      sale_order_id,
      sale_order_name,
      amount_total,
      state) async {
    var res = await DBProvider.instance.getStockId(id);
    if (res != null) {
      print("$res exist");
      await DBProvider.instance.updatestockid(PickingModel(
          id: res.id,
          name: res.name,
          date_prevue: res.date_prevue,
          date_effective: res.date_effective,
          delivery_agent_id: delivery_agent_id,
          delivery_agent_name: delivery_agent_name,
          customer_id: res.customer_id,
          customer_name: res.customer_name,
          delivery_zone: res.delivery_zone,
          sale_order_id: res.sale_order_id,
          sale_order_name: res.sale_order_name,
          amount_total: amount_total,
          amount_paid: res.amount_paid,
          validate: res.validate,
          state: res.state));
      print("$name stock update");
      print("Stock name ${name} update");
      // res.delivery_id = delivery_id;
    } else {
      await DBProvider.instance.createstock(PickingModel(
          id: id,
          name: name,
          date_prevue: date_prevue,
          date_effective: date_effective,
          delivery_agent_id: delivery_agent_id,
          delivery_agent_name: delivery_agent_name,
          customer_id: customer_id,
          customer_name: customer_name,
          delivery_zone: delivery_zone,
          sale_order_id: sale_order_id,
          sale_order_name: sale_order_name,
          amount_total: amount_total,
          amount_paid: 0.0,
          validate: 'non',
          state: state));
      print("Stock name ${name} create");
      // alertDialog(context, "Successfully Saved");
    }
  }

  Future<List<Null>> getAllStock() async {
    var params_ = {
      'data': jsonEncode(params),
    };
    storageInfo = await storageFunctions.readStorageInfo();
    String? urls = storageInfo['url'];
    String? sessionToken = storageInfo['session_token'];
    if (sessionToken != null) {
      var url = Uri.https(urls!, 'api/get_pickings', params_);
      headers = {
        "Content-Type": "application/json",
        'Cookie': sessionToken,
      };
      var requestBody = jsonEncode(params_);
      var response = await http.post(
        url,
        headers: headers,
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        // var apiProductStockLine = StockLineApiProvider();
        // await apiProductStockLine.getAllStockLine();

        if (body['result'] != null && body['result']['response'] != null) {
          final responseList = body['result']['response'] as List;
          if (responseList.isNotEmpty) {
            // print(body['result']['response']);
            return responseList.map((stock) {
              register_stock(
                  stock['id'],
                  stock['name'],
                  stock['date_prevue'],
                  stock['date_effective'],
                  stock['delivery_agent_id'],
                  stock['delivery_agent_name'],
                  stock['customer_id'],
                  stock['customer_name'],
                  stock['delivery_zone'],
                  stock['sale_order_id'],
                  stock['sale_order_name'],
                  stock['amount_total'],
                  stock['state']);
              for (var line in stock['move_line']) {
                register_stock_line(
                  line['id'],
                  line['picking_id'],
                  line['product'],
                  line['product_packaging_qty'],
                  line['packaging_qty_done'],
                  line['product_packaging_price'],
                  line['amount_tva'],
                  line['amount_bic'],
                );
              }
              // DBProvider.instance.createstock(StockModel.fromJson(stock));
            }).toList();
          } else {
            // Aucune donnée disponible
            return [];
          }
        } else {
          // Clés manquantes dans la réponse
          return [];
        }
      } else {
        // print(response.body);
        throw Exception('Unable to fetch data from the REST API');
      }
    } else {
      throw Exception(
          'La session token est nulle. Vous devez vous authentifier.');
    }
  }

  writingstockline(int id) async {
    await DBProvider.instance.getStockLineId(id).then((value) async {
      if (value != null) {
        storageInfo = await storageFunctions.readStorageInfo();
        String? urls = storageInfo['url'];
        String? sessionToken = storageInfo['session_token'];
        if (sessionToken != null) {
          var url = Uri.https(urls!, 'api/updatestockline');
          var params = {
            "params": {
              "id": value.id,
              "product_packaging_qty": value.product_packaging_qty,
              "packaging_qty_done": value.packaging_qty_done,
            }
          };
          var response =
              await http.post(url, body: jsonEncode(params), headers: {
            'Content-Type': "application/json",
          });
          if (response.statusCode == 200) {
            final body = jsonDecode(response.body);

            if (body['is_done'] == 'ok') {
              DBProvider.instance.StockPickingSend(value.id!, body['is_done']);
            }
          } else {
            print(response.body);
            throw Exception('Unable to fetch  from the REST API');
          }
        } else {
          print('Erreur sur stockline');
        }
      } else {
        throw Exception(
            'La session token est nulle. Vous devez vous authentifier.');
      }
    });
  }
}

class WritingStockLineApiProvider {
  writingstock(int id) async {
    await DBProvider.instance.writingStock(id, "done").then((value) async {
      if (value != null) {
        final details = [];
        await DBProvider.detailStocking(id).then((stockline) async {
          for (var item in stockline) {
            print("");
            var detailItem = {
              "id": item.id,
              "product_packaging_qty": item.product_packaging_qty,
              "packaging_qty_done": item.packaging_qty_done,
            };
            details.add(detailItem);
          }
        });
        storageInfo = await storageFunctions.readStorageInfo();
        String? urls = storageInfo['url'];
        String? sessionToken = storageInfo['session_token'];

        if (sessionToken != null) {
          var url = Uri.https(urls!, 'api/update_stock');
          var params = {
            "params": {
              "id": value.id,
              "state": value.state,
              "details": details,
            }
          };
          headers = {
            "Content-Type": "application/json",
            'Cookie': sessionToken,
          };
          var response =
              await http.post(url, body: jsonEncode(params), headers: {
            "Content-Type": "application/json",
            'Cookie': sessionToken,
          });
          if (response.statusCode == 200) {
            final body = jsonDecode(response.body);

            if (body['is_done'] == 'ok') {
              print("Stock id ${value.id} State ${value.state}");
              DBProvider.instance.StockPickingSend(value.id, body['is_done']);
            }
            createCashDelivery(value.delivery_agent_id, value.sale_order_id!,
                value.customer_id!, value.id, value.state!);
            // print(body);
          } else {
            // print(response.body);
            throw Exception('Unable to fetch  from the REST API');
          }
        } else {
          throw Exception(
              'La session token est nulle. Vous devez vous authentifier.');
        }
      } else {
        print('erreur sur stock to done');
      }
    });
    await DBProvider.instance
        .writingStockCancel(id, "cancel")
        .then((value) async {
      print(value);
      if (value != null) {
        final details = [];
        await DBProvider.detailStocking(id).then((stockline) async {
          for (var item in stockline) {
            print("");
            var detailItem = {
              "id": item.id,
              "product_packaging_qty": item.product_packaging_qty,
              "packaging_qty_done": item.packaging_qty_done,
            };
            details.add(detailItem);
          }
        });
        storageInfo = await storageFunctions.readStorageInfo();
        String? urls = storageInfo['url'];
        String? sessionToken = storageInfo['session_token'];
        if (sessionToken != null) {
          var url = Uri.https(urls!, 'api/update_stock');
          var params = {
            "params": {
              "id": value.id,
              "state": value.state,
              "details": details,
            }
          };
          var response =
              await http.post(url, body: jsonEncode(params), headers: {
            "Content-Type": "application/json",
            'Cookie': sessionToken,
          });
          if (response.statusCode == 200) {
            final body = jsonDecode(response.body);
            // final body = jsonDecode(response.body);
            print("Stock id ${value.id} State ${value.state}");
            if (body['is_done'] == 'ok') {
              print("Stock id ${value.id} State ${value.state}");
              DBProvider.instance.StockPickingSend(value.id, body['is_done']);
            }
            // print(body);
          } else {
            // print(response.body);
            throw Exception('Unable to fetch  from the REST API');
          }
        } else {
          throw Exception(
              'La session token est nulle. Vous devez vous authentifier.');
        }
      } else {
        print('erreur sur stock to cancel');
      }
    });
  }

  writingstockline(int id) async {
    await DBProvider.instance.writingStockLine(id, 'done').then((value) async {
      if (value != null) {
        storageInfo = await storageFunctions.readStorageInfo();
        String? urls = storageInfo['url'];
        String? sessionToken = storageInfo['session_token'];
        if (sessionToken != null) {
          var url = Uri.https(urls!, 'api/updatestockline');
          var params = {
            "params": {
              "id": value.id,
              "product_packaging_qty": value.product_packaging_qty,
              "packaging_qty_done": value.packaging_qty_done,
            }
          };
          var response =
              await http.post(url, body: jsonEncode(params), headers: {
            "Content-Type": "application/json",
            'Cookie': sessionToken,
          });
          if (response.statusCode == 200) {
            final body = jsonDecode(response.body);

            // print(body);
            // print("Send stockline");
            // print(" ${body['is_done']} ");
            print("Send stockline done ");
            if (body['is_done'] == 'ok') {
              print("Send stockline done");
              DBProvider.instance.StockMoveLineSend(value.id!, body['is_done']);
            }
          } else {
            // print(response.body);
            throw Exception('Unable to fetch  from the REST API');
          }
        } else {
          print('erreur sur stockline to done');
        }
      } else {
        throw Exception(
            'La session token est nulle. Vous devez vous authentifier.');
      }
    });
    await DBProvider.instance
        .writingStockLineCancel(id, 'cancel')
        .then((value) async {
      if (value != null) {
        storageInfo = await storageFunctions.readStorageInfo();
        String? urls = storageInfo['url'];
        String? sessionToken = storageInfo['session_token'];
        if (sessionToken != null) {
          var url = Uri.https(urls!, 'api/updatestockline');
          var params = {
            "params": {
              "id": value.id,
              "product_packaging_qty": value.product_packaging_qty,
              "packaging_qty_done": value.packaging_qty_done,
            }
          };
          var response =
              await http.post(url, body: jsonEncode(params), headers: {
            "Content-Type": "application/json",
            'Cookie': sessionToken,
          });
          if (response.statusCode == 200) {
            final body = jsonDecode(response.body);
            // print(body);
            print("Send stockline cancel");
            if (body['is_done'] == 'ok') {
              print("Send stockline cancel");
              DBProvider.instance.StockMoveLineSend(value.id!, body['is_done']);
            }
          } else {
            // print(response.body);
            throw Exception('Unable to fetch  from the REST API');
          }
        } else {
          print('erreur sur stockline to cancel');
        }
      } else {
        throw Exception(
            'La session token est nulle. Vous devez vous authentifier.');
      }
    });
  }

  createCashDelivery(
    int user_id,
    int sale_id,
    int partner_id,
    int picking_id,
    String state,
  ) async {
    await DBProvider.instance
        .getCasDone(user_id, sale_id, partner_id, picking_id, 'done')
        .then((value) async {
      if (value != null) {
        storageInfo = await storageFunctions.readStorageInfo();
        String? urls = storageInfo['url'];
        String? sessionToken = storageInfo['session_token'];
        if (sessionToken != null) {
          var url = Uri.https(urls!, 'api/insertcash');
          var params = {
            "params": {
              "picking_id": value.picking_id,
              "sale_id": value.sale_id,
              "partner_id": value.partner_id,
              "user_id": value.user_id,
              "amount": value.amount,
              "receive_amount": value.receive_amount,
              "recveive_amount_espece": value.recveive_amount_espece,
              "recveive_amount_cheque": value.recveive_amount_cheque,
              "receive_amount_momo": value.receive_amount_momo,
              "amount_tva": value.amount_tva,
              "amount_bic": value.amount_bic,
              "change": value.change,
              "creance": value.creance,
              "date": value.date.toString(),
              "company_code": company_code,
            }
          };
          var response =
              await http.post(url, body: jsonEncode(params), headers: {
            "Content-Type": "application/json",
            'Cookie': sessionToken,
          });
          if (response.statusCode == 200) {
            final body = jsonDecode(response.body);

            print("API CASH ODOO SUCCESS");
            if (body['is_done'] == 'ok') {
              print("API CASH ODOO SUCCESS");
              // print(body);
              DBProvider.instance.updateCashSend(value.id!, body['is_done']);
            }
            // DBProvider.instance.updateCashSend(value.id!, body['is_done']);
          } else {
            print("Error pour l'enregistrement");
            print(response.body);
            throw Exception('Unable to fetch  from the REST API');
          }
        } else {
          print('Erreur sur Cash');
        }
      } else {
        throw Exception(
            'La session token est nulle. Vous devez vous authentifier.');
      }
    });
  }
}
