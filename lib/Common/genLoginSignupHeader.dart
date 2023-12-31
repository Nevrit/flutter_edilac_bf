import 'package:flutter/material.dart';

class genLoginSignupHeader extends StatelessWidget {
  String headerName;

  genLoginSignupHeader(this.headerName);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        SizedBox(
          height: 50.0,
        ),
        Text(
          "Login",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 30.0),
        ),
        SizedBox(
          height: 10.0,
        ),
        Image.asset(
          'assets/images/logo.jpg',
          height: 150.0,
          width: 150.0,
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          "EDILAC LIVRAISON",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black38,
              fontSize: 25.0),
        ),
      ]),
    );
  }
}
