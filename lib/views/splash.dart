import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncz/confiqs/shared.dart/constant.dart';
import 'package:syncz/views/authentiction/login_view.dart';
import 'package:syncz/views/dashboard/dashboard_view.dart';
import '../confiqs/shared.dart/asset.dart';
import '../confiqs/shared.dart/shared_pref.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<bool> _check() async {
    splash();
    return true;
  }

  splash() async {
    bool isLoggedIn =
        await SharedPreferenceHelper.shared.getLoginStatus() ?? false;
    debugPrint(isLoggedIn.toString());
    String? type = await SharedPreferenceHelper.shared.getUserType();
    debugPrint(type.toString());
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) {
          if (isLoggedIn) {
            return const Dashboard();
          } else {
            return const LoginAuthView();
          }
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(asset, height: 250, color: Constant.appPrimary),
          ],
        ),
      ),
    );
  }
}
