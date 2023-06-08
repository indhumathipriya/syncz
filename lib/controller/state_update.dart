import 'package:flutter/material.dart';

class ProviderState extends ChangeNotifier {
  String? id;
  update(Function() method) {
    method.call();
    notifyListeners();
  }

  void setId(String value) {
    id = value;
    notifyListeners();
  }

  DateTime? value;
  getTimeAndDate(value){
 value = value;
 notifyListeners();
  }
}
