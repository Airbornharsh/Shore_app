import 'package:flutter/material.dart';

void snackBar(BuildContext context, String msg, {int duration = 1500}) {
  var snackBar = SnackBar(
    content: Text(msg),
    duration: Duration(milliseconds: duration),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
