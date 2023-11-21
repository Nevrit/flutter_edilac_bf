import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';
import '../DatabaseHandler/db_provider.dart';
import 'package:intl/intl.dart';
import 'TaskForm.dart';

class CashViews extends StatefulWidget {
  const CashViews({this.user_id});
  final int? user_id;

  @override
  State<CashViews> createState() => _CashViewsState(this.user_id);
}

class _CashViewsState extends State<CashViews> {
  final int? user_id;
  _CashViewsState(this.user_id);
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final _conDateToday = TextEditingController();
  final _controllerAmountAttendu = new TextEditingController();

  bool hasInternet = true;
  StreamSubscription? internetconnection;
  var isLoading = false;
  bool isAlertSet = false;
  var isDeviceConnect = false;
  // TextEditingController? _controllerState;
  var number_carton = String;
  var customname = String;
  int _selectedIndex = 1;

  final now = TextEditingController();
  final column = ["Produit", "Qte C", "Qte F"];

  final List<String> items = [
    'En Cours',
    'Fait',
    'Annulé',
  ];
  String? selectedValue;

  Future<void> _refreshData() async {
    // Simuler une tâche asynchrone
    await Future.delayed(Duration(seconds: 2));
    // Mettre à jour les données
  }

  getcash() async {
    await DBProvider.instance.getCurrentDateTotals(user_id!).then((data) async {
      final DateTime date_now = DateTime.now();

      final String formatter = DateFormat('dd-MM-yyyy').format(date_now);
      // print('Oui il y a une caisse et le montant est : ${value.amount}');
      if (data['total_receive_amount_espece'] > 0) {
        setState(() {
          var montant =
              "${data['total_receive_amount_espece'].toString()} FCFA";
          _controllerAmountAttendu.text = montant;
        });
      } else {
        setState(() {
          var montant = "0.0 FCFA";
          _controllerAmountAttendu.text = montant;
        });
      }

      setState(() {
        _conDateToday.text = formatter;
        // _conDateToday.text = "2023-06-21";
      });
    });
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
      if (index == 0) {
        // Index 1 correspond à l'élément "RACAP"
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TaskForm(user_id: user_id)),
        );
      }
    });
  }

  @override
  void initState() {
    getcash();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            SizedBox(
                              height: 30,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 15, top: 20, bottom: 20),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    border: Border.all(
                                      color: Color.fromARGB(255, 249, 251, 252),
                                    ),
                                  ),
                                  child: SizedBox(
                                    // <-- SEE HERE
                                    width: 200,
                                    child: TextFormField(
                                      // autocorrect: true,
                                      // decoration: InputDecoration(border: InputBorder.none),
                                      controller:
                                          TextEditingController(text: "CAISSE"),
                                      keyboardType: TextInputType.text,
                                      enabled: false,

                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
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
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: Container(
                                    child: SizedBox(
                                      // <-- SEE HERE
                                      width: 200,
                                      child: TextFormField(
                                        // autocorrect: true,
                                        // decoration: InputDecoration(border: InputBorder.none),
                                        controller:
                                            TextEditingController(text: "Date"),
                                        keyboardType: TextInputType.text,
                                        enabled: false,

                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
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
                                ),
                                Flexible(
                                  child: Container(
                                    child: SizedBox(
                                      // <-- SEE HERE
                                      width: 200,
                                      child: TextFormField(
                                        // autocorrect: true,
                                        // decoration: InputDecoration(border: InputBorder.none),
                                        controller: TextEditingController(
                                            text: "Versement du jours"),
                                        keyboardType: TextInputType.text,
                                        enabled: false,

                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
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
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 15, top: 20, bottom: 20),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 7, 139, 196),
                                      border: Border.all(
                                        color: Colors.blue.shade400,
                                      ),
                                    ),
                                    child: SizedBox(
                                      // <-- SEE HERE
                                      width: 200,
                                      child: TextFormField(
                                        // autocorrect: true,
                                        // decoration: InputDecoration(border: InputBorder.none),
                                        controller: TextEditingController(
                                            text: _conDateToday.text),
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
                                ),
                                Flexible(
                                  child: Container(
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
                                            text:
                                                _controllerAmountAttendu.text),
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
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            FutureBuilder(
                                future:
                                    DBProvider.instance.getCashUser(user_id!),
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
    );
  }
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
            height: 300,
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
                    "Date",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  )),
                  DataColumn(
                      label: Text(
                    "Facturer",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  )),
                  DataColumn(
                      label: Text(
                    "Encaisser",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  )),
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
                                  data['cash_date'].toString(),
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
                                  data['total_receive_amount'].toString(),
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                              ]),
                        )),
                        DataCell(SizedBox(
                          height: 50,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // alignment: AlignmentDirectional.center,
                              children: [
                                Text(
                                  data['total_receive_amount_espece']
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                              ]),
                        )),
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
}
