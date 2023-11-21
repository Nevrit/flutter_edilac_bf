import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import './recap.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../DatabaseHandler/api_db_provider.dart';
import '../DatabaseHandler/db_provider.dart';
import '../Model/CashModel.dart';
import 'LoginForm.dart';
import 'TaskDetail.dart';
import 'dart:async';
import 'package:intl/intl.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// import '../../Databases/api_db_provider.dart';
MyStorageFunctions storageFunctions = MyStorageFunctions();

class TaskForm extends StatefulWidget {
  const TaskForm({this.user_id});

  final int? user_id;

  @override
  State<TaskForm> createState() => _TaskFormState(this.user_id);
}

class _TaskFormState extends State<TaskForm>
    with SingleTickerProviderStateMixin {
  final int? user_id;
  _TaskFormState(this.user_id);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isDataLoaded = false;
  int? uid;
  var isLoading = false;
  bool isLoadingSend = false;
  bool hasInternet = false;
  bool isAlertSet = false;
  var isDeviceConnect = false;
  StreamSubscription? internetconnection;
  int tapCount = 0;
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  var subscription;
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'STOCK COMMANDER',
      style: optionStyle,
    ),
    Text(
      'RECAPTULATIVE',
      style: optionStyle,
    ),
  ];

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        // Index 1 correspond à l'élément "RACAP"
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CashViews(
                    user_id: user_id,
                  )),
        );
      }
    });
  }

  get_user_info() async {
    Map<String, String> storageInfo = await storageFunctions.readStorageInfo();
    String? nameUser = storageInfo['name_user'];
    String? sessionToken = storageInfo['session_token'];
    String? database = storageInfo['database'];
    String? url = storageInfo['url'];
    String? userId = storageInfo['user_id'];
    setState(() {
      uid = int.parse(userId!);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    get_user_info();
  }

  void _logout() async {
    final storage = FlutterSecureStorage();

    await storage.delete(key: 'session_token');
    await storage.delete(key: 'name_user');
    await storage.delete(key: 'user_id');
    await storage.delete(key: 'profile');
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => LoginForm()),
    );
  }

  _loadInitialData() async {
    var apiProvider = StockApiProvider();
    await apiProvider.getAllStock();

    setState(() {
      isDataLoaded = true;
    });
  }

  buildListItem(Map<String, dynamic> record) {
    return ListTile(
      title: Text(record['name']),
      subtitle: Text(record['login'] is String ? record['login'] : ''),
    );
  }

  detailstock(int stockid) async {
    DBProvider.instance.getInfoForCash(stockid).then((data) async {
      final DateTime date_now = DateTime.now();

      final String formatter =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(date_now);
      if (data != null) {
        await DBProvider.instance
            .getCash(data['user_id'], data['sale_id'], data['partner_id'])
            .then((value) async {
          if (value != null) {
          } else {
            await DBProvider.instance.createCash(CashModel(
              date: formatter,
              user_id: data['user_id'],
              partner_id: data['partner_id'],
              sale_id: data['sale_id'],
              amount: data['amounttotal'],
              receive_amount: 0,
              recveive_amount_espece: 0,
              recveive_amount_cheque: 0,
              receive_amount_momo: 0,
              amount_tva: 0,
              amount_bic: 0,
              change: 0,
              state: "in progress",
              is_done: 'non',
            ));
          }
        });
      }
    });
  }

  _wrintodooApi() async {
    var stockData = await DBProvider.instance.StockAll();
    if (stockData != null) {
      var apiProvider = WritingStockLineApiProvider();
      for (var i in stockData) {
        apiProvider.writingstock(i.id);
      }
    } else {
      print(" Pas d écriture de stock picking id ");
    }

    Future.delayed(Duration(minutes: 2));
    // _showSnackBar;
  }

  @override
  dispose() {
    super.dispose();
    internetconnection!.cancel();
    //cancel internent connection subscription after you are done
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: SpinKitCircle(
        color: Colors.white,
        size: 50.0,
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex == 0) {
      // If you are in the main Dashb page (index 0), show an alert dialog
      return await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Confirmer la sortie'),
                content: Text('Voulez-vous vraiment quitter l\'application ?'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Annuler'),
                    onPressed: () {
                      Navigator.of(context).pop(false); // Stay in the app
                    },
                  ),
                  TextButton(
                    child: Text('Oui'),
                    onPressed: () {
                      Navigator.of(context).pop(true); // Exit the app
                    },
                  ),
                ],
              );
            },
          ) ??
          false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // ToastContext().init(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
        appBar: //height of appbar
            AppBar(
          elevation: 0.1,
          backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
          title: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            Container(
              padding: const EdgeInsets.only(right: 10.0),
              child: AbsorbPointer(
                absorbing:
                    isLoading, // Si isLoading est true, le bouton est non cliquable et ne peut pas être glissé
                child: IconButton(
                    icon: const Icon(Icons.cloud_download),
                    onPressed: () async {
                      // Vérifiez l'état de la connexion Internet
                      var connectivityResult =
                          await (Connectivity().checkConnectivity());

                      if (connectivityResult == ConnectivityResult.none) {
                        // Pas de connexion Internet, ne rien faire
                        // Vous pouvez afficher un message à l'utilisateur s'il est nécessaire
                        return;
                      }

                      setState(() {
                        isLoading =
                            true; // Mettez à jour l'état pour indiquer que le chargement est en cours
                      });

                      await _loadFromApi(); // Chargez les données depuis l'API

                      setState(() {
                        isLoading =
                            false; // Mettez à jour l'état pour indiquer que le chargement est terminé
                      });
                    }),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 10.0),
              child: Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.settings_input_antenna),
                    onPressed: isLoadingSend
                        ? null
                        : () async {
                            var connectivityResult =
                                await (Connectivity().checkConnectivity());

                            if (connectivityResult == ConnectivityResult.none) {
                              // Pas de connexion Internet, ne rien faire
                              // Vous pouvez afficher un message à l'utilisateur s'il est nécessaire
                              return;
                            }
                            await _wrintodooApi();
                            // startLoading();
                          },
                  ),
                  Visibility(
                    visible: isLoadingSend,
                    child: Positioned.fill(
                      child: Container(
                        color: Colors.black54,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: <Widget>[
                  Expanded(
                    child: FutureBuilder(
                      future: _getData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('An error occurred.');
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: _buildEmployeeListView(uid!),
                          );
                        }
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FloatingActionButton(
                        backgroundColor: Color(0xff392850),
                        onPressed: _logout,
                        child: Icon(
                          Icons.power_settings_new,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              backgroundColor: Colors.blueAccent,
              icon: Icon(Icons.shopping_basket_rounded),
              label: "Commande",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.production_quantity_limits_rounded),
              label: ('CAISSE'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Future _getData() async {
    // Vérifiez s'il y a des données locales
    var localData = DBProvider.instance.getStockByUser(uid!);

    if (localData != null) {
      // Si des données locales existent, utilisez-les immédiatement
      return localData;
    } else {
      // Si aucune donnée locale n'existe, récupérez-les en ligne
      var onlineData = await _loadFromApi();

      // Sauvegardez les données en ligne localement
      await _saveDataLocally(onlineData);

      return onlineData;
    }
  }

  _loadDataFromLocal() {
    // Code pour charger les données locales depuis la base de données locale
  }

  _saveDataLocally(data) {
    // Code pour sauvegarder les données dans la base de données locale
  }

  _loadFromApi() async {
    var apiProvider = StockApiProvider();
    await apiProvider.getAllStock();
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
}

_buildEmployeeListView(int? user_id) {
  return FutureBuilder(
      future: DBProvider.instance.getStockByUser(user_id!),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // print(snapshot.data);
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  detailstock(snapshot.data[index]['id'], context);
                  print('Clik');
                },
                child: Card(
                  elevation: 0.8,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 9.0, vertical: 6.0),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(64, 75, 96, 0.9)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      leading: const Icon(Icons.delivery_dining_sharp),
                      title: Text(
                        '${snapshot.data[index]['SaleName']} | ${snapshot.data[index]['namecustom']}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  "ZONE: ${snapshot.data[index]['zone']}",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 13),
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Montant Devis: ${snapshot.data[index]['amount_total']}",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 13),
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Montant Payé: ${snapshot.data[index]['amount_paid']}",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 13),
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Date effective: ${snapshot.data[index]['date_effect']}",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 13),
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (snapshot.data[index]['state'] == 'done') ...[
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.greenAccent,
                                ),
                              ] else if (snapshot.data[index]['state'] ==
                                  'cancel') ...[
                                const Icon(
                                  Icons.cancel_outlined,
                                  color: Colors.redAccent,
                                ),
                              ] else ...[
                                const Icon(
                                  Icons.warning_amber_outlined,
                                  color: Colors.yellowAccent,
                                ),
                              ]
                            ],
                          ),
                        ],
                      ),
                      trailing: const Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      });
}

detailstock(int stockid, context) async {
  DBProvider.instance.getInfoForCash(stockid).then((data) async {
    final DateTime date_now = DateTime.now();

    final String formatter = DateFormat('yyyy-MM-dd HH:mm:ss').format(date_now);
    print(data);
    if (data != null) {
      await DBProvider.instance
          .getCash(data['user_id'], data['sale_id'], data['partner_id'])
          .then((value) async {
        if (value != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => TaskDetailForm(stock_id: stockid)));
        } else {
          await DBProvider.instance.createCash(CashModel(
            date: formatter,
            user_id: data['user_id'],
            partner_id: data['partner_id'],
            sale_id: data['sale_id'],
            picking_id: data['picking_id'],
            amount: data['amounttotal'],
            receive_amount: 0,
            recveive_amount_cheque: 0,
            recveive_amount_espece: 0,
            receive_amount_momo: 0,
            amount_tva: 0,
            amount_bic: 0,
            change: 0,
            creance: 0,
            state: "in progress",
            is_done: 'non',
          ));
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => TaskDetailForm(stock_id: stockid)));
        }
      });
    }
  });
}
