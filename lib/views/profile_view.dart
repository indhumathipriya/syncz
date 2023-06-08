import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncz/confiqs/common_widget/ui_appbar.dart';
import 'package:syncz/confiqs/shared.dart/constant.dart';
import 'package:syncz/controller/profile_cttrl.dart';
import 'package:syncz/views/authentiction/signup_view.dart';
import 'package:syncz/views/friends/followers_view.dart';
import 'package:syncz/views/friends/followings_view.dart';

import '../confiqs/shared.dart/ui_loading_text.dart';
import '../confiqs/shared.dart/ui_navigation.dart';
import '../model/post_model.dart';
import '../model/user_model.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});
  final ctrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final profileCtrl = Provider.of<ProfileCtrl>(context);

    return Scaffold(
      appBar: const UiAppBar(
        isBack: false,
        iconcolor: Constant.appPrimary,
        bgColor: Constant.appWhite,
        title: Text(
          "Profile",
          textScaleFactor: 1,
          style: TextStyle(
              color: Constant.appPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  NavByMe.push(
                      context,
                      const SignUpView(
                        isEdit: true,
                      ));
                },
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "EDIT",
                    style: TextStyle(
                        color: Constant.appSecondary,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              _buildProfilePicture(profileCtrl),
              const SizedBox(
                height: Constant.appDefaultPadding * 2,
              ),
              _buildFriendsDetils(context),
              const SizedBox(
                height: Constant.appDefaultPadding * 2,
              ),
              _buildPostGrid(profileCtrl, context),
            ],
          ),
        ),
      ),
    );
  }

  _buildProfilePicture(ProfileCtrl profileCtrl) {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      return Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 50,
            backgroundImage: NetworkImage(firebaseUser.photoURL.toString()),
          ),
          Text(
            firebaseUser.displayName ?? "Not Authenticated",
            style: const TextStyle(fontSize: 18, color: Constant.appPrimary),
          ),
        ],
      );
    }
    return FutureBuilder<UserModel>(
      future: profileCtrl.getImage(),
      builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const UiLoadingText();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          profileCtrl.profileImage = snapshot.data!.imageSrc;
          profileCtrl.name = snapshot.data!.name;
          profileCtrl.bytesImage = base64Decode(profileCtrl.profileImage);

          return Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 50,
                backgroundImage: MemoryImage(profileCtrl.bytesImage),
              ),
              const SizedBox(
                height: Constant.appDefaultPadding * 2,
              ),
              Text(
                profileCtrl.name,
                style:
                    const TextStyle(fontSize: 18, color: Constant.appPrimary),
              ),
            ],
          );
        } else {
          return const CircleAvatar(
            radius: 50,
            backgroundColor: Constant.appPrimary,
            child: Icon(Icons.person),
          );
        }
      },
    );
  }
}

_buildFriendsDetils(BuildContext context) {
  return Flex(
    mainAxisAlignment: MainAxisAlignment.center,
    direction: Axis.horizontal,
    children: [
      GestureDetector(
        onTap: () {
          NavByMe.push(context, const FollowingsView());
        },
        child: const Column(
          children: [
            Text(
              "Followings",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Constant.appBlue),
            ),
            Text("0")
          ],
        ),
      ),
      const SizedBox(
        width: Constant.appDefaultPadding * 2,
      ),
      GestureDetector(
        onTap: () {
          NavByMe.push(context, const FollowersView());
        },
        child: const Column(
          children: [
            Text(
              "Followers",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Constant.appBlue),
            ),
            Text("0")
          ],
        ),
      )
    ],
  );
}

//Fetching data from DB
_buildPostGrid(ProfileCtrl profileCtrl, BuildContext context) {
  return FutureBuilder<List<PostModel>>(
    future: profileCtrl.allPost(context),
    builder: (BuildContext context, AsyncSnapshot<List<PostModel>> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const UiLoadingText();
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else if (snapshot.hasData) {
        return GridView.builder(
          itemCount: snapshot.data!.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 5),
          itemBuilder: (BuildContext context, int index) {
            PostModel post = snapshot.data!.elementAt(index);
            profileCtrl.decoImage = post.imageSrc;
            debugPrint(profileCtrl.decoImage);

            profileCtrl.bytesImage =
                const Base64Decoder().convert(profileCtrl.decoImage);
            return _buildPostContainer(context, post, profileCtrl);
          },
        );
      } else {
        return const Center(
          child: Text("Add Post"),
        );
      }
    },
  );
}

_showBottomSheet(
  BuildContext context,
  PostModel post,
) {
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
              ),
            ],
          ),
        )),
      );
    },
  );
}

//creating Post Container
_buildPostContainer(
    BuildContext context, PostModel post, ProfileCtrl profileCtrl) {
  return GestureDetector(
    onTap: () async {
      _showAlertDialog(context, post);
    },
    child: Container(
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Constant.appDefaultPadding),
        border: Border.all(color: Constant.appPrimary, width: 1.5),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: MemoryImage(profileCtrl.bytesImage),
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
                    post.like == true ? Icons.favorite : Icons.favorite_border,
                    color: post.like == true ? Colors.red : Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    profileCtrl.updatePost(profileCtrl, post);
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
                const Icon(Icons.share, color: Colors.white, size: 28),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

_showAlertDialog(BuildContext context, PostModel post) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: const Text("Delete Post?"),
        actions: [
          TextButton(
              onPressed: () {
                final CollectionReference usersCollection =
                    FirebaseFirestore.instance.collection('post');

                final DocumentReference userDocRef =
                    usersCollection.doc(post.userId);
                userDocRef.delete();
                Navigator.pop(context);
                
              },
              child: const Text("Yes")),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No"))
        ],
      );
    },
  );
}
