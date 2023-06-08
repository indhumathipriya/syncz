import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncz/controller/friends_ctrl.dart';
import 'package:syncz/controller/google_auth_ctrl.dart';
import 'package:syncz/controller/home_ctrl.dart';

import 'package:syncz/controller/profile_cttrl.dart';
import 'package:syncz/controller/state_update.dart';

import 'package:syncz/views/splash.dart';

class SynczApp extends StatelessWidget {
  const SynczApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => GoogleAuthCtrl())),
        ChangeNotifierProvider(create: ((context) => HomeCtrl())),
        ChangeNotifierProvider(create: ((context) => ProviderState())),
        ChangeNotifierProvider(create: ((context) => ProfileCtrl())),
        ChangeNotifierProvider(create: ((context) => FriendsCtrl())),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Splashscreen(),
      ),
    );
  }
}
