import 'package:flutter/material.dart';
import 'package:syncz/confiqs/shared.dart/constant.dart';

class UiLoadingText extends StatefulWidget {
  const UiLoadingText({super.key});

  @override
  State<UiLoadingText> createState() => _UiLoadingTextState();
}

class _UiLoadingTextState extends State<UiLoadingText> {
  @override
  Widget build(BuildContext context) {
    return const Center(
            child: Text(
              "Loading....",
              style: TextStyle(
                  color: Constant.appPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
          );
  }
}