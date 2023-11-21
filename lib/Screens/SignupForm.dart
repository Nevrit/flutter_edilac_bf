import 'package:flutter/material.dart';
import '../Common/genLoginSignupHeader.dart';
import '../Common/genTextFormField.dart';

import '../DatabaseHandler/db_provider.dart';
import '../Model/UserModel.dart';
import 'LoginForm.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = new GlobalKey<FormState>();

  final _conUserId = TextEditingController();
  final _conUserName = TextEditingController();
  final _conUserEmail = TextEditingController();
  final _conPassword = TextEditingController();
  final _conCPassword = TextEditingController();
  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DBProvider;
  }

  signUp() async {
    int uid = int.parse(_conUserId.text);
    String email_ = _conUserEmail.text;
    String name = _conUserName.text;
    String passw = _conPassword.text;
    String cpassw = _conCPassword.text;

    if (_formKey.currentState!.validate()) {
      if (cpassw != passw) {
        print("Mot de Passe non correcte");
        // alertDialog(context, "Mot de Passe non correcte");
      } else {
        _formKey.currentState!.save();

        await DBProvider.instance
            .createEmployee(
                UserModel(id: uid, name: name, login: email_, password: passw))
            .then((userData) {
          // alertDialog(context, "Successfully Saved");
          print({email_, name, passw});

          Navigator.push(
              context, MaterialPageRoute(builder: (_) => LoginForm()));
        }).catchError((error) {
          print(error);
          // alertDialog(context, "Error: Data Save Fail");
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Créer un Compte',
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  genLoginSignupHeader("S'inscrire"),
                  // getTextFormField(
                  //   controller: _conUserId,
                  //   icon: Icons.person,
                  //   inputType: TextInputType.name,
                  //   hintName: 'User Id',
                  // ),
                  getTextFormField(
                    controller: _conUserName,
                    icon: Icons.person,
                    inputType: TextInputType.name,
                    hintName: 'Nom & Prénom',
                  ),
                  getTextFormField(
                    controller: _conUserEmail,
                    icon: Icons.email,
                    inputType: TextInputType.emailAddress,
                    hintName: 'Email',
                  ),
                  getTextFormField(
                    controller: _conPassword,
                    icon: Icons.lock,
                    hintName: 'Mot de Passe',
                    isobscureText: true,
                  ),
                  getTextFormField(
                    controller: _conCPassword,
                    icon: Icons.lock,
                    hintName: 'Confirme Mot de Passe',
                    isobscureText: true,
                  ),
                  Container(
                    margin: EdgeInsets.all(30.0),
                    width: double.infinity,
                    child: TextButton(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side: BorderSide(color: Colors.blue)))),
                      onPressed: signUp,
                      child: Text(
                        "S'inscrire",
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
