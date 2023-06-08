import 'package:flutter/material.dart';
import 'package:syncz/confiqs/shared.dart/constant.dart';

abstract class SnackMesage {
  static exception(String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Constant.appPrimary,
        behavior: SnackBarBehavior.floating,
        content: Text(message),
      ),
    );
  }
}
