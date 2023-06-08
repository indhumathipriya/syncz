import 'package:flutter/material.dart';
import 'package:syncz/confiqs/shared.dart/constant.dart';

class UiAlertDialog extends StatelessWidget {
  final VoidCallback onGallery;
  final VoidCallback onCamera;
  const UiAlertDialog({super.key, required this.onGallery, required this.onCamera});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Constant.appPrimary,
      title: const Text(
        "Choose option",style: TextStyle(color: Constant.appWhite),
      ),
      content: SingleChildScrollView(
        child: ListBody(

          children: [
            const Divider(height: 1),
            ListTile(
              onTap: onGallery,
              title: const Text('Gallery',style: TextStyle(color: Constant.appWhite),),
            ),
            const Divider(
              height: 1,
              color:  Constant.appWhite
            ),
            ListTile(
              onTap: onCamera,
              title: const Text('Camera',style: TextStyle(color: Constant.appWhite),),
            ),
          ],
        ),
      ),
    );
  }
}