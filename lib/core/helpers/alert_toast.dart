import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prosto_doc/core/helpers/colors.dart';

void showAlertToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    gravity: ToastGravity.TOP,
    backgroundColor: AppColors.greyColor.withOpacity(0.1),
    textColor: Colors.black,
    timeInSecForIosWeb: 3,
    toastLength: Toast.LENGTH_LONG,
    fontSize: 16,
  );
}
