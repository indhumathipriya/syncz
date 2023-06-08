import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:syncz/confiqs/shared.dart/ui_loading_text.dart';
import 'package:syncz/controller/home_ctrl.dart';
import 'package:syncz/model/post_model.dart';

import '../confiqs/shared.dart/constant.dart';
import '../confiqs/shared.dart/ui_snackbar.dart';
import '../controller/google_auth_ctrl.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Provider.of<HomeCtrl>(context);
    final googleAuthData = Provider.of<GoogleAuthCtrl>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Code to execute after the frame is rendered
      updateLastLogin(context, googleAuthData);
    });

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: Constant.appDefaultPadding,
                ),
                const Text(
                  "Syncz",
                  textScaleFactor: 1.7,
                  style: TextStyle(
                      color: Constant.appPrimary,
                      fontSize: 28,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w400),
                ),
                const Text(
                  "Sync to the world through syncz. Enjoy safe with privacy ",
                  style: TextStyle(
                      color: Constant.appPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: Constant.appDefaultPadding * 2,
                ),
                _buildAllPost(homeCtrl, context)
              ],
            ),
          ),
        ),
      ),
    );
  }

//Fetching data from DB
  _buildAllPost(HomeCtrl homeCtrl, BuildContext context) {
    return StreamBuilder<List<PostModel>>(
      stream: homeCtrl.allPost(),
      builder: (BuildContext context, AsyncSnapshot<List<PostModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const UiLoadingText();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                PostModel post = snapshot.data![index];
                //converting base64 to Image
                homeCtrl.decoImage = post.imageSrc;
                debugPrint(homeCtrl.decoImage);
                homeCtrl.bytesImage =
                    const Base64Decoder().convert(homeCtrl.decoImage);
                return _buildPOstContainer(context, post, homeCtrl);
              },
              separatorBuilder: (
                BuildContext context,
                int index,
              ) {
                return _buildSeperated(snapshot.data!.elementAt(index).caption);
              },
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

//creating Post Container
  _buildPOstContainer(BuildContext context, PostModel post, HomeCtrl homeCtrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flex(
          direction: Axis.horizontal,
          children: [
            Text(
              post.userName,
              style: const TextStyle(
                  color: Constant.appSecondary,
                  fontSize: 24,
                  fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                homeCtrl.forUpdateFriends(true);
              },
              child: const Text(
                "Follow",
                style: TextStyle(
                    color: Constant.appSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        const SizedBox(height: Constant.appDefaultPadding),
        Container(
          height: MediaQuery.of(context).size.height / 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Constant.appDefaultPadding),
            border: Border.all(color: Constant.appPrimary, width: 1.5),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: MemoryImage(homeCtrl.bytesImage),
            ),
          ),
          child: Column(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(Constant.appDefaultPadding / 2),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        post.like == true
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: post.like == true ? Colors.red : Colors.white,
                        size: 32,
                      ),
                      onPressed: () {
                        homeCtrl.updatePost(homeCtrl, post);
                      },
                    ),
                    const SizedBox(width: Constant.appDefaultPadding / 2),
                    IconButton(
                      icon: const Icon(Icons.comment_sharp, size: 32),
                      onPressed: () {
                        _showBottomSheet(context, post);
                      },
                      color: Colors.white,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () async {},
                      icon: const Icon(
                        Icons.share,
                        size: 32,
                      ),
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

//creating caption
  _buildSeperated(String caption) {
    return SizedBox(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          caption,
          style: const TextStyle(
              color: Constant.appSecondary,
              fontSize: 20,
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  updateLastLogin(BuildContext context, GoogleAuthCtrl googleAuthData) async {
    var data = googleAuthData.lastLoginTime;
    debugPrint(data);
    SnackMesage.exception("Last Login Time $data", context);
  }

  _showBottomSheet(BuildContext context, PostModel post) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constant.appDefaultPadding * 2),
      ),
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 500,
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(Constant.appDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: Constant.appDefaultPadding * 2,
                ),
                const Text(
                  "Comments",
                  style: TextStyle(
                      color: Constant.appPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w500),
                ),
                const Divider(
                  color: Constant.appPrimary,
                ),
                Text(
                  post.comment.toString(),
                  style: const TextStyle(
                      color: Constant.appBalck,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          )),
        );
      },
    );
  }
}
