import 'package:flutter/material.dart';
import 'package:syncz/confiqs/shared.dart/constant.dart';
import 'package:syncz/confiqs/shared.dart/shared_pref.dart';
import 'package:syncz/confiqs/shared.dart/ui_navigation.dart';
import 'package:syncz/views/splash.dart';

class UiAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isBack;
  final Color bgColor;
  final Color iconcolor;

  final Widget? leadingWidget;
  final Widget? title;
  const UiAppBar(
      {super.key,
      required this.isBack,
      required this.bgColor,
      required this.title,
      this.leadingWidget,
      required this.iconcolor});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: isBack
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: iconcolor,
              icon: const Icon(
                Icons.chevron_left,
                size: 40,
              ),
            )
          : leadingWidget,
      automaticallyImplyLeading: isBack,
      backgroundColor: bgColor,
      title: title,
      actions: [
        IconButton(
            onPressed: () {
              SharedPreferenceHelper.shared.setLoginStatus(false);
              NavByMe.pushCompleteReplacement(context, const Splashscreen());
            },
            icon: const Icon(
              Icons.logout,
              color: Constant.appPrimary,
            ))
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
