import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncz/confiqs/common_widget/ui_appbar.dart';
import 'package:syncz/confiqs/shared.dart/constant.dart';
import 'package:syncz/controller/friends_ctrl.dart';
import 'package:syncz/model/user_model.dart';

import '../../confiqs/shared.dart/ui_loading_text.dart';

class FollowingsView extends StatelessWidget {
  const FollowingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Provider.of<FriendsCtrl>(context);
    return Scaffold(
      appBar: const UiAppBar(
          isBack: true,
          bgColor: Constant.appWhite,
          title: Text(
            "Followings",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Constant.appPrimary),
          ),
          iconcolor: Constant.appPrimary),
      body: StreamBuilder<List<UserModel>>(
        stream: ctrl.allPost(),
        builder:
            (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const UiLoadingText();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            if (snapshot.data != []) {
              //creating Followings
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView.separated(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    UserModel post = snapshot.data![index];
                    //converting base64 to Image
                    ctrl.decoImage = post.imageSrc;
                    debugPrint(ctrl.decoImage);
                    ctrl.bytesImage =
                        const Base64Decoder().convert(ctrl.decoImage);
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Constant.appWhite,
                        backgroundImage: MemoryImage(ctrl.bytesImage),
                      ),
                      title: Text(
                        post.name,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Constant.appPrimary),
                      ),
                      trailing: TextButton(
                        onPressed: () {
                          ctrl.forUpdateFollower(true);
                        },
                        child: const Text(
                          "Follow Back",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Constant.appSecondary),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (
                    BuildContext context,
                    int index,
                  ) {
                    return const SizedBox(
                      height: Constant.appDefaultPadding * 2,
                    );
                  },
                ),
              );
            } else {
              return const UiLoadingText();
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
