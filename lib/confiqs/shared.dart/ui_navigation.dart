import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NavByMe {
  static Future<dynamic> push(BuildContext context, Widget screen) async {
    return await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => screen));
  }

  static Future<dynamic> pushNamed(BuildContext context, String routeName,
      {dynamic arguments}) async {
    return await Navigator.of(context)
        .pushNamed(routeName, arguments: arguments);
  }

  static void pushCompleteReplacement(BuildContext context, Widget screen) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => screen),
        (Route<dynamic> route) => false);
  }

  static void pushReplacement(BuildContext context, Widget screen) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => screen));
  }

  static void pop(BuildContext context) {
    Navigator.pop(context);
  }

  static void maybePop(BuildContext context) {
    Navigator.maybePop(context);
  }

  static void popTwice(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  static void popToRoot(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  static void popUntil(BuildContext context, int screenNo) {
    int count = 0;
    Navigator.popUntil(context, (route) {
      return count++ == screenNo;
    });
  }

  static exitFromApp(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      SystemNavigator.pop();
    }
  }
}
