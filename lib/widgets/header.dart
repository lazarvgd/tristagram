import 'package:flutter/material.dart';

AppBar header(BuildContext context, {bool isAppTitle = false, String title}) {
  return AppBar(
    title: Text(
      isAppTitle ? "Tristagram" : title,
      style: TextStyle(
        color: Colors.white,
        fontFamily: isAppTitle ? 'Signatra' : '',
        fontSize: isAppTitle ? 50.0 : 22.0,
      ),
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
  );
}
