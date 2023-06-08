import 'package:flutter/material.dart';

import '../shared.dart/constant.dart';

class UiPrimaryButton extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final Color backgroundColor;
  final Color foregroundColor;
  const UiPrimaryButton(
      {super.key, required this.onPressed, required this.text, required this.backgroundColor, required this.foregroundColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(Constant.appDefaultPadding / 2)),
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor),
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          )),
    );
  }
}
