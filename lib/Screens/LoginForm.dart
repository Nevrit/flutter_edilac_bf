import 'dart:async';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:toast/toast.dart';
import '../Common/comHelper.dart';
import '../Common/genTextFormField.dart';
import '../DatabaseHandler/api_db_provider.dart';
import '../DatabaseHandler/db_provider.dart';
import '../Model/UserModel.dart';
import './TaskForm.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

var urls = "halltech-ci-edilac-bf.odoo.com";

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm>
    with SingleTickerProviderStateMixin {
  final _formKey = new GlobalKey<FormState>();
  bool isobscureText = true;
  var isLoading = false;
  bool selected = false;
  bool hasInternet = false;
  String _errorMessage = "";
  StreamSubscription? internetconnection;

  ConnectivityResult result = ConnectivityResult.none;
  // Animation<double> containersize;
  final _storage = new FlutterSecureStorage();

  final _conUserEmail = TextEditingController();
  final _conPassword = TextEditingController();
  final _conUserId = TextEditingController();
  final _conUrl = TextEditingController();
  MyStorageFunctions storageFunctions = MyStorageFunctions();
  var sessionCookie;
  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });

    var apiProvider = StockApiProvider();

    await apiProvider.getAllStock();
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  startTime(userData) async {
    var duration = Duration(seconds: 3);
    return new Timer(duration, route(userData));
  }

  route(userData) async {
    await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => TaskForm(user_id: userData.id)));
    setState(() {});
  }

  redirection(email_p, passw_) {
    DBProvider.instance.getLoginUser(email_p, passw_).then((userData) async {
      if (userData != null) {
        _formKey.currentState!.save();
        print(userData.login);
        print(" User id : ${userData.id}");
        _conUserId.text = userData.id.toString();
        // print(userData.id);
        return startTime(userData);
      } else {
        // connexion(login, pass);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erreur'),
              content: Text(
                  'Le nom d\'utilisateur ou le mot de passe est incorrect.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        setState(() {
          _errorMessage = "Email ou mot de passe erroné";
        });
      }
    }).catchError((error) {
      print(error);
      setState(() {
        _errorMessage = error.message;
      });
    });
  }

  register_user(id, name, login, password) async {
    var res = await DBProvider.instance.getUserId(id);
    if (res != null) {
      print("$res exist");
      redirection(res.login, res.password);
    } else {
      var result = await DBProvider.instance.createEmployee(UserModel(
        id: id,
        name: name,
        login: login,
        password: password,
      ));
      print("Première connexion resultat : ");
      print(result);

      redirection(login, password);

      //
    }
  }

  getemploye(email, passw, urls) async {
    if (hasInternet == true) {
      var url = Uri.https(urls, 'web/session/authenticate');
      var params_ = {
        "params": {
          // "db": "halltech-ci-edilac-bf-production-10008466",
          "login": email,
          "password": passw
        }
      };
      var response = await http.post(url, body: jsonEncode(params_), headers: {
        'Content-Type': "application/json",
      });

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        sessionCookie = response.headers['set-cookie'];
        print("Authentification");
        print(sessionCookie);
        if (body['result'] != null) {
          final data = body['result'];
          await storageFunctions.createStorage(sessionCookie, data['db'], urls,
              data['name'], data['uid'], 'commercial');
          register_user(body['result']['uid'], body['result']['name'],
              body['result']['username'], passw);
          // var apiProvider = StockApiProvider();
          // apiProvider.getAllStock();
        } else {
          redirection(email, passw);
          print("error");
        }
      } else {}
    } else {
      redirection(email, passw);
    }
  }

  login() async {
    String email_ = _conUserEmail.text;
    String passw = _conPassword.text;
    String urls = _conUrl.text;
    final prefs = await SharedPreferences.getInstance();
    if (_formKey.currentState!.validate()) {
      if (email_.isEmpty) {
        print("Entrez votre Mail");
        alertDialog("Entrez Votre Email");
      } else if (passw.isEmpty) {
        print("Entrez votre mot de pass");
      } else {
        getemploye(email_, passw, urls);
      }
    }
  }

  Widget _showErrorMessage() {
    if (_errorMessage.isNotEmpty) {
      return Container(
        color: Colors.red,
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            _errorMessage,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  get_user_info() async {
    // final storage = FlutterSecureStorage();
    // String? nameUser = await storage.read(key: 'name_user');
    Map<String, String> storageInfo = await storageFunctions.readStorageInfo();
    // String? sessionToken = storageInfo['session_token'];
    // String? database = storageInfo['database'];
    String? url = storageInfo['url'];
    // String? userId = storageInfo['user_id'];
    // String? profile = storageInfo['profile'];
    _conUrl.text = url!;
    setState(() {
      _conUrl.text = url!;
    });
  }

  @override
  void initState() {
    _errorMessage = "";

    get_user_info();

    super.initState();
    setState(() {
      _storage.write(key: "KEY_USERID", value: _conUserId.text);
      _storage.write(key: "KEY_USEREMAIL", value: _conUserEmail.text);
      _storage.write(key: "KEY_USERPASSW", value: _conPassword.text);
    });

    // final checkconn = CheckConnection();

    // checkconn.main();
    internetconnection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // whenevery connection status is changed.
      if (result == ConnectivityResult.none) {
        //there is no any connection
        setState(() {
          hasInternet = false;
        });
      } else if (result == ConnectivityResult.mobile) {
        //connection is mobile data network
        setState(() {
          hasInternet = true;
          _loadFromApi();
        });
      } else if (result == ConnectivityResult.wifi) {
        //connection is from wifi
        setState(() {
          hasInternet = true;
          _loadFromApi();
        });
      }
    });

    // Step 2 <- SEE HERE
  }

  @override
  dispose() {
    super.dispose();
    internetconnection!.cancel();
    //cancel internent connection subscription after you are done
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '',
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[500],
        centerTitle: true,
        actions: <Widget>[
          // Container(
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          //       Colors.blue.shade400,
          //       Colors.blue.shade200,
          //       Colors.blue.shade100,
          //     ]),
          //   ),
          //   padding: EdgeInsets.only(right: 10.0),
          //   child: IconButton(
          //     icon: Icon(Icons.settings_input_antenna),
          //     onPressed: () async {
          //       await _loadFromApi();
          //       // print('Bouttonn Ok!!!');
          //     },
          //   ),
          // ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Container(
          // padding: EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
              Colors.blue.shade400,
              Colors.blue.shade200,
              Colors.white,
            ]),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                child:
                    errmsg("Aucune connexion Internet disponible", hasInternet),
                //to show internet connection message on isoffline = true.
              ),
              Stack(
                children: <Widget>[
                  Image.asset(
                    "assets/images/Mask-Group-88-1.jpg",
                    width: 800,
                    height: 220,
                    fit: BoxFit.fill,
                  ),
                  // BackdropFilter(filter: filter)
                ],
              ),
              SizedBox(
                height: 0,
              ),

              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    // height: 100,
                    padding: EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: <Widget>[
                          // SizedBox(
                          //   height: 60,
                          // ),
                          Container(
                            // padding: EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(75, 54, 143, 245),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                )
                              ],
                            ),
                            child: Column(
                              children: <Widget>[
                                const SizedBox(
                                  height: 12,
                                ),
                                getTextFormField(
                                  controller: _conUrl,
                                  icon: Icons.dataset_outlined,
                                  inputType: TextInputType.url,
                                  hintName: 'URL',
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                getTextFormField(
                                  controller: _conUserEmail,
                                  icon: Icons.email,
                                  inputType: TextInputType.emailAddress,
                                  hintName: 'Email',
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                getTextFormField(
                                  controller: _conPassword,
                                  icon: Icons.lock,
                                  suffixicon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isobscureText = !isobscureText;
                                      });
                                    },
                                    child: Icon(isobscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                  ),
                                  inputType: TextInputType.text,
                                  hintName: 'Mot de Passe',
                                  isobscureText: isobscureText,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 70,
                          ),
                          new Container(
                            width: 150.0,
                            height: 60.0,
                            alignment: FractionalOffset.center,
                            decoration: new BoxDecoration(
                              color: Color.fromARGB(255, 88, 166, 245),
                              borderRadius: new BorderRadius.all(
                                  const Radius.circular(30.0)),
                            ),
                            child: new TextButton(
                              onPressed: () async {
                                await login();
                              },
                              child: Text(
                                'Valider',
                                style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // )
            ],
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
        padding: EdgeInsets.all(10.00),
        margin: EdgeInsets.only(bottom: 10.00),
        color: Colors.red,
        child: Row(children: [
          Container(
            margin: EdgeInsets.only(right: 6.00),
            child: Icon(Icons.info, color: Colors.white),
          ), // icon for error message

          Text(text, style: TextStyle(color: Colors.white)),
          //show error message text
        ]),
      );
    } else {
      return Container();
      //if error is false, return empty container.
    }
  }
}

void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text("Alert!!"),
        content: new Text("You are awesome!"),
        actions: <Widget>[
          new TextButton(
            child: new Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
