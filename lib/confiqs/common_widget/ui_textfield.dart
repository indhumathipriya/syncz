import 'package:flutter/material.dart';

import '../shared.dart/constant.dart';

class UiTextField extends StatelessWidget {
  final TextEditingController ctrl;
  final String text;
  const UiTextField({super.key, required this.ctrl, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: ctrl,
      maxLines: 5,
      decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          hintText: text,
          hintStyle: const TextStyle(color: Constant.appgrey),
          filled: true,
          fillColor: Constant.appWhite,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0)),
    );
  }
}
