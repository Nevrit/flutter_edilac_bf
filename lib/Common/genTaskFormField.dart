import 'package:flutter/material.dart';

import 'comHelper.dart';

class getTaskFormField extends StatelessWidget {
  TextEditingController? controller;
  TextInputType inputType;
  TextStyle? style;
  String title;
  EdgeInsets? margin;

  getTaskFormField(
      {this.controller,
      required this.title,
      required this.inputType,
      this.margin,
      this.style});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: margin,
        // height: 50,
        decoration: BoxDecoration(
            // border: Border(
            //   bottom: BorderSide(
            //     color: Colors.green.shade200,
            //   ),
            // ),
            ),
        child: TextFormField(
          autocorrect: true,
          // decoration: InputDecoration(border: InputBorder.none),
          readOnly: true,
          controller: controller,
          keyboardType: inputType,

          style: style,
          decoration: InputDecoration(
            hintText: title,
            hintStyle: TextStyle(color: Colors.pink.shade100),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

class getCashField extends StatelessWidget {
  TextEditingController? controller;
  TextInputType inputType;
  String title;
  BoxDecoration? border;
  bool isEnable;

  getCashField(
      {this.controller,
      required this.title,
      required this.inputType,
      this.border,
      this.isEnable = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: border,
      child: SizedBox(
        width: 200,
        child: TextFormField(
          // autocorrect: true,
          // decoration: InputDecoration(border: InputBorder.none),
          controller: controller,
          keyboardType: inputType,
          enabled: isEnable,
          textAlign: TextAlign.center,

          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),

          decoration: InputDecoration(
            // hintText: title,
            labelText: title,
            hintStyle: TextStyle(color: Colors.blue.shade100),
            border: InputBorder.none,
            // enabledBorder: OutlineInputBorder(
            //   //<-- SEE HERE
            //   borderSide: BorderSide(width: 1, color: Colors.blue.shade100),
            // ),
          ),
        ),
      ),
    );
  }
}
