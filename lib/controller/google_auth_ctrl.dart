import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:syncz/controller/state_update.dart';

class GoogleAuthCtrl extends ProviderState {
  //initializations
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? user;
  dynamic lastLoginTime;

//googleAuth
  signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    var result = (await firebaseAuth.signInWithCredential(credential));
    user = result.user;
    lastLoginTime = user!.metadata.lastSignInTime;
    debugPrint(user.toString());
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  getTimeAndDate(value) {
    return super.getTimeAndDate(lastLoginTime);
  }

  @override
  update(Function() method) {
    signInWithGoogle();
    return super.update(method);
  }
}
