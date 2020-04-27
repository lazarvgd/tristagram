import 'package:flutter/material.dart';

Widget circularProgress() {
  return Container(
    padding: const EdgeInsets.only(top: 8.0),
    alignment: Alignment.center,
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.purple),
    ),
  );
}

Widget linearProgress() {
  return Container(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.purple),
    ),
  );
}
