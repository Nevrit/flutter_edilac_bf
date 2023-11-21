import 'dart:async';

import '../Model/StockLineModel.dart';
import '../Model/StockModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:toast/toast.dart';
import '../Common/comHelper.dart';
import '../Common/genTaskFormField.dart';
import '../DatabaseHandler/api_db_provider.dart';
import '../DatabaseHandler/db_provider.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../Model/CashModel.dart';
import 'TaskForm.dart';

class TaskDetailForm extends StatefulWidget {
  const TaskDetailForm({required this.stock_id});

  final int stock_id;

  @override
  State<TaskDetailForm> createState() => _TaskDetailFormState(this.stock_id);
}

class _TaskDetailFormState extends State<TaskDetailForm> {
  final int stock_id;
  _TaskDetailFormState(this.stock_id);
  final _formKey = new GlobalKey<FormState>();
  final _formAlert = new GlobalKey<FormState>();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  var _TotalMoney = 0.0;
  var _ChangeMoney = 0.0;
  var _Somme = 0.0;
  var _Bic = 0.0;
  var _AmountTVA = 0.0;
  var _TotalTotal = 0.0;
  var _TotalHT = 0.0;
  var CartonLivre = 0.0;
  var _CreanceMoney = 0.0;
  // var _Timbre = 0.0;
  final _conuser = TextEditingController();
  final _conName = TextEditingController();
  final _conCustomer = TextEditingController();
  final _conLocation = TextEditingController();
  final _conZone = TextEditingController();
  final _conDatePrevu = TextEditingController();
  final _conDateEffec = TextEditingController();
  final _controllerState = TextEditingController();
  final _controllerCarton = TextEditingController();
  final _controllerCartonPrevu = TextEditingController();
  final _controllerCartonValider = TextEditingController();
  final _controllerCartonLivrer = TextEditingController();
  TextEditingController _countrollerStateStock = new TextEditingController();
  final _controllerAmountAttendu = new TextEditingController();
  TextEditingController _countrollerAmountCash = new TextEditingController();
  TextEditingController _countrollerAmountTotal = new TextEditingController();
  TextEditingController _countrollerAmountReceive = new TextEditingController();
  TextEditingController _countrollerAmountReceiveEspece =
      new TextEditingController();
  TextEditingController _countrollerAmountReceiveCheque =
      new TextEditingController();

  TextEditingController _countrollerAmountMomo = new TextEditingController();
  TextEditingController _countrollerAmountBic = new TextEditingController();
  TextEditingController _countrollerAmountTva = new TextEditingController();
  TextEditingController _countrollerAmountHT = new TextEditingController();
  TextEditingController _countrollerChange = new TextEditingController();
  TextEditingController _countrollerCreance = new TextEditingController();
  bool hasInternet = true;
  StreamSubscription? internetconnection;
  var isLoading = false;
  bool isAlertSet = false;
  var isDeviceConnect = false;
  // TextEditingController? _controllerState;
  var number_carton = String;
  var customname = String;

  final now = TextEditingController();
  final column = ["Produit", "Qte C", "Qte F"];

  final List<String> items = [
    'En Cours',
    'Fait',
    'Annulé',
  ];
  String? selectedValue;

  // Future getstockines() async {
  //   await DBProvider.instance.gettockLine(stock_id).then((value) => {value});
  // }
  _wrintodooApi() {
    DBProvider.instance.CashAll().then((data) async {
      // final String formatter = DateFormat('yyyy-MM-dd HH:mm').format(date_now);
      if (data != []) {
        var apiProvider = WritingStockLineApiProvider();
        for (var i in data) {
          await apiProvider.createCashDelivery(
              i.user_id, i.sale_id, i.partner_id, i.picking_id, i.state);
        }

        // await apiProvider.createCashDelivery(data["user_id"],data["sale_id"],data["partner_id"],data["picking_id"]);
      }
    });

    DBProvider.instance.StockLineAllLastThreeDays().then((datastockine) async {
      if (datastockine != []) {
        var apiProvider = WritingStockLineApiProvider();
        var apiProd = WritingStockLineApiProvider();

        for (var rs in datastockine) {
          await apiProvider.writingstockline(rs.id!);
        }
        apiProvider.writingstock(datastockine[0].picking_id);
      } else {}
    });
    DBProvider.instance.StockAllLastThreeDays().then((data) async {
      // final String formatter = DateFormat('yyyy-MM-dd HH:mm').format(date_now);
      if (data != []) {
        var apiProvider = WritingStockLineApiProvider();
        for (var i in data) {
          await apiProvider.writingstock(i.id);
        }
      }
    });
  }

  network() => internetconnection = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) async {
        // whenevery connection status is changed.
        isDeviceConnect = await InternetConnectionChecker().hasConnection;

        if (!isDeviceConnect && isAlertSet == false) {
          //there is no any connection
          showDialogBox();
          setState(() => isAlertSet = true);
        } else {
          _loadFromApi();
        }
      });
  getcash() async {
    await DBProvider.instance.getInfoForCash(stock_id).then((data) async {
      if (data != null) {
        await DBProvider.instance
            .getCash(data['user_id'], data['sale_id'], data['partner_id'])
            .then((value) async {
          if (value != null) {
            // print('Oui il y a une caisse et le montant est : ${value.amount}');
            var montant = "${value.amount.toString()} FCFA";
            _controllerAmountAttendu.text = montant;

            _countrollerAmountCash.text = value.amount!.round().toString();

            _countrollerChange.text = value.change.toString();
            _countrollerAmountReceive.text = (value.receive_amount == 0.0)
                ? '0.0'
                : value.receive_amount.toString();
            _countrollerAmountReceiveEspece.text =
                (value.recveive_amount_espece == 0.0)
                    ? '0.0'
                    : value.recveive_amount_espece.toString();
            _countrollerAmountReceiveCheque.text =
                (value.recveive_amount_cheque == 0.0)
                    ? '0.0'
                    : value.recveive_amount_cheque.toString();
            _countrollerAmountMomo.text = (value.receive_amount_momo == 0.0)
                ? '0.0'
                : value.receive_amount_momo.toString();
            _countrollerCreance.text = value.creance.toString();
            var subtotal = 0.0;
            var bic_amount = 0.0;
            var tva_amount = 0.0;
            var len = 0;
            var roundedTotal = 0;

            DBProvider.instance.gettockLine(stock_id).then((value) async => {
                  len = value.toList().length,
                  for (var i in value.toList())
                    {
                      if (i['price_subtotal'] > 0)
                        {subtotal = (subtotal + i['price_subtotal'])},
                      if (i['total_tva'] > 0)
                        {tva_amount = (tva_amount + i['total_tva'])},
                      if (i['total_bic'] > 0)
                        {bic_amount = (bic_amount + i['total_bic'])},
                    },
                  print("Montant subtotal : $subtotal"),
                  _countrollerAmountCash.text = subtotal.round().toString(),
                  _countrollerAmountHT.text = subtotal.round().toString(),
                  _countrollerAmountTva.text = tva_amount.round().toString(),
                  _countrollerAmountBic.text = bic_amount.round().toString(),
                  _Somme = double.parse(_countrollerAmountHT.text),
                  _Bic = (double.parse(_countrollerAmountBic.text)),
                  _AmountTVA = (double.parse(_countrollerAmountTva.text)),
                  _Bic = (double.parse(_countrollerAmountBic.text)),
                  _TotalHT = _Somme,
                  _TotalTotal = _Somme + _AmountTVA + _Bic,
                  roundedTotal = _TotalTotal.round(),
                  _countrollerAmountHT.text = _Somme.round().toString(),
                  _countrollerAmountBic.text = _Bic.round().toString(),
                  _countrollerAmountTva.text = _AmountTVA.round().toString(),
                  _countrollerAmountCash.text = roundedTotal.toString(),
                  _countrollerAmountTotal.text = roundedTotal.toString(),
                });
          } else {
            print("Pas de caisse");
          }
        });
      }
    });
  }

  get_info_stock() async {
    await DBProvider.instance.updateStock(stock_id).then((data) async {
      final DateTime date_now = DateTime.now();

      final String formatter = DateFormat('yyyy-MM-dd HH:mm').format(date_now);

      if (data != null) {
        _countrollerStateStock.text = data['state'].toString(); //state
        await DBProvider.instance.gettockLine(stock_id).then((value) async {
          var carton = 0.0;
          var contonValider = 0.0;
          for (var i in value.toList()) {
            carton = carton + i['pack_qty'];
            contonValider = contonValider + i['pack_qty_done'];
          }
          ;

          var carton_p = "${carton.toString()} Carton";
          CartonLivre = contonValider;
          _controllerCarton.text = carton_p;
          _controllerCartonPrevu.text = carton.toString();
          _controllerCartonValider.text = contonValider.toString();
          _controllerCartonLivrer.text = "${contonValider.toString()} Livré";
        });

        _conuser.text = data['delivery_agent_id'].toString();

        _conName.text = data['sale_order_name'];
        _conCustomer.text = data['namecustom'];
        customname = data['namecustom'];
        _conDateEffec.text = formatter;
        _conDatePrevu.text = data['date_prevue'];
        _conLocation.text = data['lieu'];
        _conZone.text = data['zone'];
        _controllerState.text = data['state'];
      } else {
        print("No any data with stock id: " + widget.stock_id.toString());
      }
    }).catchError((error) {
      // alertDialog("Information erronée");
    });
  }

  @override
  void initState() {
    // getstockines();
    // TODO: implement initState

    getcash();
    get_info_stock();
    // network();
    // _wrintodooApi();

    super.initState();

    _countrollerAmountReceiveEspece.addListener(_CalculChange);
    _countrollerAmountReceiveCheque.addListener(_CalculChange);
    _countrollerAmountMomo.addListener(_CalculChange);
  }

  _CalculChange() {
    var change = 0.0;
    var creance = 0.0;
    var total = 0.0;
    total = (_countrollerAmountReceiveCheque.text == "")
        ? 0.0
        : double.parse(_countrollerAmountReceiveCheque.text);

    total += (_countrollerAmountReceiveCheque.text == "")
        ? 0.0
        : double.parse(_countrollerAmountReceiveCheque.text);

    change = (_countrollerAmountReceiveCheque.text == "")
        ? 0.0
        : double.parse(_countrollerAmountReceiveCheque.text);
    change += (_countrollerAmountMomo.text == "")
        ? 0.0
        : double.parse(_countrollerAmountMomo.text);

    change += (_countrollerAmountReceiveEspece.text == "")
        ? 0.0
        : double.parse(_countrollerAmountReceiveEspece.text);

    change -= (_countrollerAmountCash.text == "")
        ? 0.0
        : double.parse(_countrollerAmountCash.text);

    creance = (_countrollerAmountCash.text == "")
        ? 0.0
        : double.parse(_countrollerAmountCash.text);
    creance -= (_countrollerAmountReceiveEspece.text == "")
        ? 0.0
        : double.parse(_countrollerAmountReceiveEspece.text);

    creance -= (_countrollerAmountReceiveCheque.text == "")
        ? 0.0
        : double.parse(_countrollerAmountReceiveCheque.text);

    creance -= (_countrollerAmountMomo.text == "")
        ? 0.0
        : double.parse(_countrollerAmountMomo.text);

    setState(() {
      if (total >= 0.0) {
        _TotalMoney = total;
      } else {
        _TotalMoney = 0.0;
      }

      if (change >= 0) {
        _ChangeMoney = change;
      } else {
        _ChangeMoney = 0.0;
      }
      if (_countrollerAmountReceiveEspece.text != "0.0" && creance > 0) {
        _CreanceMoney = creance;
      } else {
        _CreanceMoney = 0.0;
      }
    });
  }

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });

    var apiProvider = StockApiProvider();

    await apiProvider.getAllStock();

    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _refreshData() async {
    // Simuler une tâche asynchrone
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      isLoading = false;

      // wait for 2 seconds to simulate loading of data
      Future.delayed(const Duration(seconds: 2));
      DBProvider.instance.StockLineAllLastThreeDays().then((data) async {
        // final String formatter = DateFormat('yyyy-MM-dd HH:mm').format(date_now);
        if (data != []) {
          var apiProvider = WritingStockLineApiProvider();
          for (var i in data) {
            await apiProvider.writingstockline(i.id!);
          }
          apiProvider.writingstock(data[0].picking_id);
        }
      });
    });
  }

  Cancel(id, name, date_prevue, date_effective, user_id, agentid, customer_id,
      zone_id, delivery_id, saleid, amount_total, state) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (_) => TaskForm(user_id: agentid)));
  }

  back_taskform(int user_id) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => TaskForm(user_id: user_id)));
  }

  UpdateStok(
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
      state,
      validate) async {
    PickingModel data = PickingModel(
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
        amount_paid: double.parse(_countrollerAmountCash.text),
        state: state,
        validate: validate);
    // data.qte_fait = double.parse(QtyController.text);
    int count = 0;
    double tva = 0.0;
    var len = 0;
    StockLineModel line;
    var apiProvider = StockApiProvider();
    var apiProd = WritingStockLineApiProvider();
    DBProvider.instance.gettockLine(stock_id).then(
          (value) async => {
            len = value.toList().length,
            for (var i in value.toList())
              {
                line = StockLineModel(
                  id: i['id'],
                  picking_id: i['stock_id'],
                  product: i['product'],
                  product_packaging_qty: i['pack_qty'],
                  packaging_qty_done: i['pack_qty_done'],
                  product_packaging_price: i['price_unit'],
                  amount_tva: i['amount_tva'],
                  amount_bic: i['amount_bic'],
                  total_tva: i['total_tva'],
                  total_bic: i['total_bic'],
                  price_subtotal: i['price_subtotal'],
                  price_total: i['price_total'],
                  state: state,
                  is_done: 'non',
                ),
                DBProvider.instance.updatestoclines(line),
                apiProvider.writingstockline(i['id']),
              },
            print(value),
          },
        );
    await DBProvider.instance.updatestockid(data).then((stock) => {
          if (stock != 0)
            {
              apiProd.writingstock(id),
            }
          else
            {print("Non Modification du stock")}
        });

    await DBProvider.instance
        .getCash(delivery_agent_id, sale_order_id, customer_id)
        .then(
      (value) async {
        if (value != null) {
          final DateTime date_now = DateTime.now();

          final String formatter =
              DateFormat('yyyy-MM-dd HH:mm:ss').format(date_now);
          CashModel cash = CashModel(
            id: value.id,
            date: formatter,
            user_id: value.user_id,
            partner_id: value.partner_id,
            sale_id: value.sale_id,
            picking_id: value.picking_id,
            amount: double.parse(_countrollerAmountCash.text),
            receive_amount: double.parse(_countrollerAmountReceiveEspece.text) +
                double.parse(_countrollerAmountReceiveCheque.text),
            recveive_amount_espece:
                double.parse(_countrollerAmountReceiveEspece.text),
            recveive_amount_cheque:
                double.parse(_countrollerAmountReceiveCheque.text),
            receive_amount_momo: double.parse(_countrollerAmountMomo.text),
            amount_tva: double.parse(_countrollerAmountTva.text),
            amount_bic: double.parse(_countrollerAmountBic.text),
            change: _ChangeMoney,
            creance: _CreanceMoney,
            state: state,
            is_done: 'non',
          );
          await DBProvider.instance.updateCashId(cash);
          // await apiProd.createCashDelivery(delivery_agent_id, value.sale_id!,
          //     value.partner_id, value.picking_id!, state);
        }
      },
    );

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TaskForm(user_id: delivery_agent_id)));
  }

  Future<void> showInformationQuantity(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Form(
                  key: _formAlert,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [],
                  )),
              title: Column(
                children: [
                  Text(
                      'Vous n\'aviez pas saisi toute la quantité prévue. Voulez-vous confirmer?'),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 255, 0, 0)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(
                                  color: Color.fromARGB(255, 255, 0, 0))))),
                  child: Text(
                    'Non',
                  ),
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TaskForm(user_id: int.parse(_conuser.text))));
                  },
                ),
                TextButton(
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(color: Colors.blue)))),
                  child: Text(
                    'Oui',
                  ),
                  onPressed: () async {
                    await DBProvider.instance
                        .updateStock(stock_id)
                        .then((value) => {
                              if (value != null)
                                {
                                  UpdateStok(
                                      value['id'],
                                      value['namestock'],
                                      value['date_prevue'],
                                      value['date_effect'],
                                      value['delivery_agent_id'],
                                      value['delivery_agent_name'],
                                      value['custom_id'],
                                      value['namecustom'],
                                      value['zone'],
                                      value['sale_order_id'],
                                      value['sale_order_name'],
                                      value['amounttotal'],
                                      "done",
                                      "non"),
                                }
                            });
                    ;
                  },
                ),
              ],
            );
          });
        });
  }

  Future<void> showInformationDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Form(
                  key: _formAlert,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [],
                  )),
              title: Column(
                children: [
                  if (double.parse(_countrollerAmountReceiveEspece.text) ==
                      0.0) ...[
                    if (double.parse(_controllerCartonValider.text) <
                        double.parse(_controllerCartonPrevu.text)) ...[
                      const Text(
                        "Vous n'aviez pas saisi le montant reçu. Vous confirmez?",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Vous n\'aviez pas saisi toute la quantité prevue. Vous confirmez?',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ] else ...[
                      if (double.parse(_controllerCartonValider.text) >=
                          double.parse(_controllerCartonPrevu.text)) ...[
                        const Text(
                          'Felicitation vous avez livré tous vos produit !',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Avez-vous fini votre livraison ?',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ] else ...[
                    if (double.parse(_controllerCartonValider.text) <
                        double.parse(_controllerCartonPrevu.text)) ...[
                      const Text(
                        "Vous n'aviez pas saisi toute la quantité prevue. Vous confirmez?",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ] else ...[
                      if (double.parse(_controllerCartonValider.text) >=
                          double.parse(_controllerCartonPrevu.text)) ...[
                        const Text(
                          'Felicitation vous avez livré tous vos produit !',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Avez-vous fini votre livraison ?',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ]
                ],
              ),
              actions: <Widget>[
                TextButton(
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 255, 0, 0)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: const BorderSide(
                                  color: Color.fromARGB(255, 255, 0, 0))))),
                  child: const Text(
                    'Non',
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(color: Colors.blue)))),
                  child: const Text(
                    'Oui',
                  ),
                  onPressed: () async {
                    await DBProvider.instance
                        .updateStock(stock_id)
                        .then((value) => {
                              if (value != null)
                                {
                                  UpdateStok(
                                      value['id'],
                                      value['namestock'],
                                      value['date_prevue'],
                                      value['date_effect'],
                                      value['delivery_agent_id'],
                                      value['delivery_agent_name'],
                                      value['custom_id'],
                                      value['namecustom'],
                                      value['zone'],
                                      value['sale_order_id'],
                                      value['sale_order_name'],
                                      value['amounttotal'],
                                      "done",
                                      "non"),
                                }
                            });
                    ;
                  },
                ),
              ],
            );
          });
        });
  }

  Future<void> showInformationDialogCancel(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Form(
                  key: _formAlert,
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [],
                  )),
              title: const Text('Voulez-vous annuler cette livraison?'),
              actions: <Widget>[
                TextButton(
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 255, 0, 0)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: const BorderSide(
                                  color: Color.fromARGB(255, 255, 0, 0))))),
                  child: const Text(
                    'Non',
                  ),
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TaskForm(user_id: int.parse(_conuser.text))));
                  },
                ),
                TextButton(
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: const BorderSide(color: Colors.blue)))),
                  child: const Text(
                    'Oui',
                  ),
                  onPressed: () async {
                    await DBProvider.instance
                        .updateStock(stock_id)
                        .then((value) => {
                              if (value != null)
                                {
                                  UpdateStok(
                                      value['id'],
                                      value['namestock'],
                                      value['date_prevue'],
                                      value['date_effect'],
                                      value['delivery_agent_id'],
                                      value['delivery_agent_name'],
                                      value['custom_id'],
                                      value['namecustom'],
                                      value['zone'],
                                      value['sale_order_id'],
                                      value['sale_order_name'],
                                      value['amounttotal'],
                                      "cancel",
                                      "non"),
                                }
                            });
                    ;
                  },
                ),
              ],
            );
          });
        });
  }

  Future<bool> onBackPressed() {
    if (navigatorKey.currentState!.canPop()) {
      navigatorKey.currentState!.pop();
      return Future.value(false);
    } else {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Êtes-vous sûr de vouloir quitter l\'application ?'),
            actions: <Widget>[
              TextButton(
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 255, 0, 0)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: const BorderSide(
                                color: Color.fromARGB(255, 255, 0, 0))))),
                child: const Text(
                  'oui',
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              TextButton(
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 255, 0, 0)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: const BorderSide(
                                color: Color.fromARGB(255, 255, 0, 0))))),
                child: const Text(
                  'Non',
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        },
      ).then((value) => value ?? false);
    }
  }

  @override
  dispose() {
    super.dispose();
    internetconnection!.cancel();
    //cancel internent connection subscription after you are done
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Livraison',
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade400,
        centerTitle: true,
        actions: <Widget>[],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 30),
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                Colors.blue.shade300,
                Colors.blue.shade100,
                Colors.white,
              ]),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    // height: 500,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                    child: getTaskFormField(
                                  margin: const EdgeInsets.only(left: 20),
                                  controller: _conName,
                                  title: '',
                                  inputType: TextInputType.text,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                )),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                getTaskFormField(
                                  // margin: const EdgeInsets.only(left: 15),
                                  margin: const EdgeInsets.only(left: 60),
                                  controller: _conCustomer,
                                  title: '',
                                  inputType: TextInputType.text,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                    child: getTaskFormField(
                                  margin: const EdgeInsets.only(left: 20),
                                  controller: _controllerCarton,
                                  title: '',
                                  inputType: TextInputType.text,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                )),
                                Flexible(
                                    child: getTaskFormField(
                                  margin: const EdgeInsets.only(left: 25),
                                  controller: _controllerCartonLivrer,
                                  title: '',
                                  inputType: TextInputType.text,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                )),
                                Flexible(
                                    child: getTaskFormField(
                                  margin: const EdgeInsets.only(left: 30),
                                  controller: _controllerAmountAttendu,
                                  title: '',
                                  inputType: TextInputType.text,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                )),
                              ],
                            ),
                            const SizedBox(
                              height: 0,
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            FutureBuilder(
                                future:
                                    DBProvider.instance.gettockLine(stock_id),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (!snapshot.hasData) {
                                    // checking if API has data & if no data then loading bar
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    // return data after recieving it in snapshot.
                                    return DataStockLine(
                                        datalist: snapshot.data);
                                  }
                                }),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Text(
                                  "MONTANT HT",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13),
                                ),
                                Flexible(
                                  child: getCashField(
                                    controller: _countrollerAmountHT,
                                    title: '',
                                    inputType: TextInputType.phone,
                                    isEnable: false,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Text(
                                  "MONTANT TVA",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13),
                                ),
                                Flexible(
                                  child: getCashField(
                                    controller: _countrollerAmountTva,
                                    title: '',
                                    inputType: TextInputType.phone,
                                    isEnable: false,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Text(
                                  "MONTANT BIC",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13),
                                ),
                                Flexible(
                                  child: getCashField(
                                    controller: _countrollerAmountBic,
                                    title: '',
                                    inputType: TextInputType.phone,
                                    isEnable: false,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Text(
                                  "MONTANT TTC",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13),
                                ),
                                Flexible(
                                  child: getCashField(
                                    controller: _countrollerAmountCash,
                                    title: '',
                                    inputType: TextInputType.phone,
                                    isEnable: false,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Text(
                                  "ESPECE",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13),
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                if (_countrollerStateStock.text == 'done' ||
                                    _countrollerStateStock.text ==
                                        'cancel') ...[
                                  Flexible(
                                    child: getCashField(
                                      border: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.blue.shade100,
                                          ),
                                        ),
                                      ),
                                      controller:
                                          _countrollerAmountReceiveEspece,
                                      title: '',
                                      inputType: TextInputType.phone,
                                      isEnable: false,
                                    ),
                                  ),
                                ] else ...[
                                  if (_countrollerAmountCash.text != '0.0') ...[
                                    Flexible(
                                      child: getCashField(
                                        border: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.blue.shade100,
                                            ),
                                          ),
                                        ),
                                        controller:
                                            _countrollerAmountReceiveEspece,
                                        title: '',
                                        inputType: TextInputType.phone,
                                      ),
                                    ),
                                  ] else ...[
                                    Flexible(
                                      child: getCashField(
                                        controller:
                                            _countrollerAmountReceiveEspece,
                                        title: '',
                                        inputType: TextInputType.phone,
                                        isEnable: false,
                                      ),
                                    ),
                                  ],
                                ],
                                SizedBox(
                                  width: 50,
                                ),
                                if (_ChangeMoney >= 0) ...[
                                  Flexible(
                                    child: getCashField(
                                      controller: TextEditingController(
                                          text: _ChangeMoney.toString()),
                                      title: 'Monnaie',
                                      inputType: TextInputType.text,
                                      isEnable: false,
                                    ),
                                  ),
                                ] else
                                  ...[]
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Text(
                                  "CHEQUE",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13),
                                ),
                                if (_countrollerStateStock.text == 'done' ||
                                    _countrollerStateStock.text ==
                                        'cancel') ...[
                                  Flexible(
                                    child: getCashField(
                                      controller:
                                          _countrollerAmountReceiveCheque,
                                      title: '',
                                      inputType: TextInputType.phone,
                                      isEnable: false,
                                    ),
                                  ),
                                ] else ...[
                                  if (_countrollerAmountCash.text != '0.0') ...[
                                    Flexible(
                                      child: getCashField(
                                        border: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.blue.shade100,
                                            ),
                                          ),
                                        ),
                                        controller:
                                            _countrollerAmountReceiveCheque,
                                        title: '',
                                        inputType: TextInputType.phone,
                                      ),
                                    ),
                                  ] else ...[
                                    Flexible(
                                      child: getCashField(
                                        controller:
                                            _countrollerAmountReceiveCheque,
                                        title: '',
                                        inputType: TextInputType.phone,
                                        isEnable: false,
                                      ),
                                    ),
                                  ],
                                ],
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Text(
                                  "MOBILE MONEY",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13),
                                ),
                                if (_countrollerStateStock.text == 'done' ||
                                    _countrollerStateStock.text ==
                                        'cancel') ...[
                                  Flexible(
                                    child: getCashField(
                                      controller: _countrollerAmountMomo,
                                      title: '',
                                      inputType: TextInputType.phone,
                                      isEnable: false,
                                    ),
                                  ),
                                ] else ...[
                                  if (_countrollerAmountCash.text != '0.0') ...[
                                    Flexible(
                                      child: getCashField(
                                        border: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.blue.shade100,
                                            ),
                                          ),
                                        ),
                                        controller: _countrollerAmountMomo,
                                        title: '',
                                        inputType: TextInputType.phone,
                                      ),
                                    ),
                                  ] else ...[
                                    Flexible(
                                      child: getCashField(
                                        controller: _countrollerAmountMomo,
                                        title: '',
                                        inputType: TextInputType.phone,
                                        isEnable: false,
                                      ),
                                    ),
                                  ],
                                ],
                              ],
                            ),
                            if (_countrollerStateStock.text == 'cancel') ...[
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 15, top: 20, bottom: 20),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade400,
                                  border: Border.all(
                                    color: Colors.red.shade400,
                                  ),
                                ),
                                child: SizedBox(
                                  // <-- SEE HERE
                                  width: 200,
                                  child: TextFormField(
                                    // autocorrect: true,
                                    // decoration: InputDecoration(border: InputBorder.none),
                                    controller: TextEditingController(
                                        text: 0.0.toString()),
                                    keyboardType: TextInputType.text,
                                    enabled: false,

                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    textAlign: TextAlign.center,

                                    decoration: InputDecoration(
                                      // hintText: "Créance",
                                      // labelText: "Creance",

                                      hintStyle: TextStyle(
                                          color: Colors.blue.shade100),
                                      enabledBorder: OutlineInputBorder(
                                        //<-- SEE HERE
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Colors.blue.shade100),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ] else ...[
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 15, top: 20, bottom: 20),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent.shade400,
                                  border: Border.all(
                                    color: Colors.red.shade400,
                                  ),
                                ),
                                child: SizedBox(
                                  // <-- SEE HERE
                                  width: 200,
                                  child: TextFormField(
                                    // autocorrect: true,
                                    // decoration: InputDecoration(border: InputBorder.none),
                                    controller: TextEditingController(
                                        text: _CreanceMoney.toString()),
                                    keyboardType: TextInputType.text,
                                    enabled: false,

                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    textAlign: TextAlign.center,

                                    decoration: InputDecoration(
                                      // hintText: "Créance",
                                      // labelText: "Creance",

                                      hintStyle: TextStyle(
                                          color: Colors.blue.shade100),
                                      enabledBorder: OutlineInputBorder(
                                        //<-- SEE HERE
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Colors.blue.shade100),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      const Text(
                                        "MONTANT TOTAL",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              bottom:
                                                  13), // Ajustez cette valeur selon vos besoins
                                          child: TextFormField(
                                            controller: _countrollerAmountTotal,
                                            keyboardType: TextInputType.phone,
                                            enabled: false,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            decoration: InputDecoration(
                                              labelText: "",
                                              hintStyle: TextStyle(
                                                  color: Colors.blue.shade100),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        "FCFA",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            if (CartonLivre < 1) ...[
                              if (_countrollerStateStock.text != 'cancel' &&
                                  _countrollerStateStock.text != 'done') ...[
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.red.shade400,
                                  ),
                                  margin: EdgeInsets.symmetric(horizontal: 60),
                                  width: double.infinity,
                                  child: Center(
                                    child: TextButton(
                                      onPressed: () async {
                                        await showInformationDialogCancel(
                                            context);
                                      },
                                      child: const Text(
                                        'Annuler',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              ] else ...[
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0),
                                    color: Colors.red.shade400,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 95),
                                  width: double.infinity,
                                  child: const Center(
                                    child: TextButton(
                                      onPressed: null,
                                      child: Text(
                                        'Déjà annulé',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                            ] else ...[
                              if (_countrollerStateStock.text == 'cancel' ||
                                  _countrollerStateStock.text == 'done') ...[
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0),
                                    color: Colors.green.shade400,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 95),
                                  width: double.infinity,
                                  child: const Center(
                                    child: TextButton(
                                      onPressed: null,
                                      child: Text(
                                        'Déjà Vailder',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              ] else ...[
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.blue.shade400,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 60),
                                  width: double.infinity,
                                  child: Center(
                                    child: TextButton(
                                      onPressed: () async {
                                        await showInformationDialog(context);
                                      },
                                      child: const Text(
                                        'Valider',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ]
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget errmsg(String text, bool show) {
    //error message widget.
    if (show == false) {
      //if error is true then show error message box
      return Container(
        padding: const EdgeInsets.all(10.00),
        margin: const EdgeInsets.only(bottom: 10.00),
        color: Colors.red,
        child: Row(children: [
          Container(
            margin: const EdgeInsets.only(right: 6.00),
            child: const Icon(Icons.info, color: Colors.white),
          ), // icon for error message

          Text(text, style: const TextStyle(color: Colors.white)),
          //show error message text
        ]),
      );
    } else {
      return Container(
        child: const Text(''),
      );
      //if error is false, return empty container.
    }
  }

  showDialogBox() => showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
            title: const Text("Pas de connection"),
            content: const Text("Veuillez vérifier votre connexion Internet"),
            actions: <Widget>[
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context, 'Annuler');
                    setState(() => isAlertSet = false);
                    isDeviceConnect =
                        await InternetConnectionChecker().hasConnection;
                  },
                  child: const Text("Ok"))
            ],
          ));
  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
          ))
      .toList();
}

detailstock(int stockid, context) async {
  DBProvider.instance.detailStock(stockid).then((stock) {
    if (stock != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => TaskDetailForm(stock_id: stock.id)));
    } else {
      alertDialog("Information erronée");
    }
  }).catchError((error) {
    print(error);
    // alertDialog(context, "Error: Data Save Fail");
  });
}

_appBar() {
  return AppBar(
    leading: GestureDetector(
      onTap: () {},
      child: const Icon(
        Icons.delivery_dining_rounded,
        size: 20,
      ),
    ),
    // ignore: prefer_const_literals_to_create_immutables
    actions: [
      const Icon(
        Icons.search,
        size: 20,
      ),
    ],
  );
}

class DataStockLine extends StatefulWidget {
  const DataStockLine({required this.datalist});
  final List datalist;

  @override
  State<DataStockLine> createState() => _DataStockLineState(this.datalist);
}

class _DataStockLineState extends State<DataStockLine> {
  final List datalist;
  _DataStockLineState(this.datalist);

  TextEditingController QtyController = TextEditingController();

  @override
  void initState() {
    //widget.rollno is passed paramater to this class

    super.initState();
    // Step 2 <- SEE HERE
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SizedBox(
      // height: MediaQuery.of(context).size.height,
      // width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          SizedBox(
            height: 290,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: DataTable(
                dataRowHeight: 80.0,
                dividerThickness: 2.5,
                // headingRowHeight: 40,
                headingRowColor: MaterialStateProperty.all(Colors.blue[100]),
                columnSpacing: 20,
                // sortColumnIndex: 1,
                showCheckboxColumn: true,
                // decoration: BoxDecoration(
                //   border: Border(
                //     right: BorderSide(
                //       color: Colors.blue.shade100,
                //       width: 0.5,
                //     ),
                //   ),
                // ),

                // Data columns as required by APIs data.
                columns: const [
                  DataColumn(
                      label: Text(
                    "PRODUIT",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  )),
                  DataColumn(
                      label: Text(
                    "CMMD",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  )),
                  DataColumn(
                      label: Text(
                    "FAIT",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  )),
                  // DataColumn(
                  //     label: Text(
                  //   "ACTION",
                  //   style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  // )),
                ],
                // Main logic and code for geting data and shoing it in table rows.

                rows: datalist
                    .map(
                      //maping each rows with datalist data
                      (data) => DataRow(cells: [
                        DataCell(
                          SizedBox(
                            height: 50,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  data['product'].toString(),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        DataCell(SizedBox(
                          height: 50,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // alignment: AlignmentDirectional.center,
                              children: [
                                Text(
                                  data['pack_qty'].toString(),
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                              ]),
                        )),

                        // DataCell(
                        //   Text(data['qtefait'].toString(),
                        //       style: const TextStyle(
                        //           fontSize: 13,
                        //           fontWeight: FontWeight.w500)),
                        // ),
                        if (data['state'] != 'done' &&
                            data['state'] != 'cancel') ...[
                          DataCell(
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                // alignment: AlignmentDirectional.center,
                                children: [
                                  Text(data['pack_qty_done'].toString(),
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500)),
                                ]),
                            showEditIcon: true,
                            onTap: () async {
                              await EditeProductQty(data);
                            },
                          ),
                        ] else ...[
                          DataCell(Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // alignment: AlignmentDirectional.center,
                              children: [
                                Text(data['pack_qty_done'].toString(),
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500)),
                              ])),
                        ],
                        // DataCell(Column(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     // alignment: AlignmentDirectional.center,
                        //     children: [
                        //       Text(
                        //           "${data['amount_tva'].toString()} | ${data['amount_bic'].toString()}",
                        //           style: const TextStyle(
                        //               fontSize: 13,
                        //               fontWeight: FontWeight.w500)),
                        //     ])),
                        // DataCell(Column(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     // alignment: AlignmentDirectional.center,
                        //     children: [
                        //       if (data['state'] == 'done') ...[
                        //         const Icon(
                        //           Icons.check_circle,
                        //           color: Colors.greenAccent,
                        //         ),
                        //       ] else if (data['state'] == 'cancel') ...[
                        //         const Icon(
                        //           Icons.cancel_outlined,
                        //           color: Colors.redAccent,
                        //         ),
                        //       ] else ...[
                        //         const Icon(
                        //           Icons.warning_amber_outlined,
                        //           color: Colors.yellowAccent,
                        //         ),
                        //       ]
                        //     ])),
                      ]),
                    )
                    .toList(), // converting at last into list.
              ),
            ),
          ),
        ],
      ),
    );
  }

  EditeProductQty(data) {
    final qtydone = _dialogBuilder(context, data);
  }

  UpdateStokline(
    id,
    picking_id,
    product,
    product_packaging_qty,
    packaging_qty_done,
    product_packaging_price,
    amount_tva,
    amount_bic,
    total_tva,
    total_bic,
    price_subtotal,
    price_total,
    state,
  ) async {
    StockLineModel data = StockLineModel(
      id: id,
      picking_id: picking_id,
      product: product,
      product_packaging_qty: product_packaging_qty,
      packaging_qty_done: packaging_qty_done,
      product_packaging_price: product_packaging_price,
      amount_tva: amount_tva,
      amount_bic: amount_bic,
      total_tva: total_tva,
      total_bic: total_bic,
      price_subtotal: price_subtotal,
      price_total: price_total,
      state: state,
      is_done: 'non',
    );
    // data.qte_fait = double.parse(QtyController.text);
    var result = await DBProvider.instance.updatestoclines(data);
    print(
        "Montant de la ligne $price_subtotal et le prix est $product_packaging_price");
    if (result != 0) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => TaskDetailForm(stock_id: picking_id)));
      // Navigator.pop(context);
    } else {
      print("Error");
    }
  }

  Future _dialogBuilder(BuildContext context, data) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: <Widget>[
              Text(
                  "${data['product'].toString()} Qté: ${data['pack_qty'].toString()}"),
            ],
          ),
          content: Container(
            child: TextFormField(
              controller: QtyController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: "Qté Fait"),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.subtitle1,
              ),
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.subtitle1,
              ),
              child: Text('Valider'),
              onPressed: () {
                var convert_subtotal =
                    (double.parse(QtyController.text) * data['price_unit']);
                var amount_tva = data['amount_tva'];
                var amount_bic = data['amount_bic'];
                var total_tva =
                    (double.parse(QtyController.text) * data['amount_tva']);
                var total_bic =
                    (double.parse(QtyController.text) * data['amount_bic']);
                var convert_total = convert_subtotal + total_tva + total_bic;

                if (double.parse(QtyController.text) > data['pack_qty']) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Quantité Supérieure'),
                        content: Text(
                            "Vous avez saisi une quantité supérieure à celle demandée. Qté demandée : ${data['pack_qty'].toString()}; Qté saisie : ${double.parse(QtyController.text)}"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Fermer'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  if (double.parse(QtyController.text) < 0) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Quantité Négative'),
                          content: Text(
                              "Vous avez saisi une quantité négative : ${double.parse(QtyController.text)}"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Fermer'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    UpdateStokline(
                      data['id'],
                      data['stock_id'],
                      data['product'],
                      data['pack_qty'],
                      double.parse(QtyController.text),
                      data['price_unit'],
                      amount_tva,
                      amount_bic,
                      total_tva,
                      total_bic,
                      convert_subtotal,
                      convert_total,
                      data['state'],
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
