import 'package:flutter/material.dart';

class getTextFormField extends StatelessWidget {
  TextEditingController controller;
  String hintName;
  IconData icon;
  bool isobscureText;
  Widget? suffixicon;
  TextInputType inputType;
  bool isEnable;

  getTextFormField(
      {required this.controller,
      required this.hintName,
      required this.icon,
      this.isobscureText = false,
      this.suffixicon,
      this.inputType = TextInputType.text,
      this.isEnable = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.green.shade200,
          ),
        ),
      ),
      // padding: EdgeInsets.symmetric(horizontal: 20.0),
      // margin: EdgeInsets.only(top: 20.0),
      child: TextFormField(
        controller: controller,
        obscureText: isobscureText,
        enabled: isEnable,
        keyboardType: inputType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Entrez $hintName";
          }
          // if (hintName == "Email") {
          //   return 'Entrez un Email Valide';
          // }
          return null;
        },
        decoration: InputDecoration(
            suffixIcon: suffixicon,
            prefixIcon: Icon(
              icon,
              color: Colors.blue.shade300,
            ),
            hintText: hintName,
            // labelText: hintName,
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none),
      ),
    );
  }
}
