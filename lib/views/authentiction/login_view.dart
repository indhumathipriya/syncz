import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncz/confiqs/common_widget/ui_button.dart';
import 'package:syncz/confiqs/shared.dart/shared_pref.dart';
import 'package:syncz/confiqs/shared.dart/ui_snackbar.dart';
import 'package:syncz/controller/google_auth_ctrl.dart';
import 'package:syncz/views/authentiction/signup_view.dart';
import 'package:syncz/views/dashboard/dashboard_view.dart';
import '../../confiqs/shared.dart/constant.dart';
import '../../confiqs/shared.dart/ui_navigation.dart';
import '../../controller/state_update.dart';

class LoginAuthView extends StatelessWidget {
  const LoginAuthView({super.key});

  @override
  Widget build(BuildContext context) {
    final googleAuthData = context.watch<GoogleAuthCtrl>();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Constant.appPrimary,
        body: Padding(
          padding: const EdgeInsets.all(Constant.appDefaultPadding / 2),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Creating Images
                _buildFirstImage(),
                _buildSecondImage(),
                _buildThirdImage(),
                const SizedBox(
                  height: Constant.appDefaultPadding,
                ),

                const Text(
                  "Let's Syncz ",
                  textScaleFactor: 1.7,
                  style: TextStyle(
                      color: Constant.appSecondary,
                      fontSize: 30,
                      fontWeight: FontWeight.w400),
                ),
                const Text(
                  "Sync to the world through syncz. \nEnjoy safe with privacy ",
                  style: TextStyle(
                      color: Constant.appWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: Constant.appDefaultPadding * 2,
                ),

                //continue with google button
                UiPrimaryButton(
                    backgroundColor: Constant.appSecondary,
                    foregroundColor: Constant.appWhite,
                    onPressed: () {
                      handleLogin(googleAuthData, context);
                    },
                    text: "Continue with Google"),
                const SizedBox(
                  height: Constant.appDefaultPadding,
                ),

                //signUp method
                Align(
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                      text: "Didn't have an account?",
                      style: const TextStyle(
                          color: Constant.appWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.w300),
                      children: [
                        TextSpan(
                          text: " Register",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpView(),
                                ),
                              );
                            },
                          style: const TextStyle(
                              color: Constant.appSecondary,
                              fontSize: 22,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

//handling Login Method

  void handleLogin(GoogleAuthCtrl googleAuthData, BuildContext context) async {
    var user = await googleAuthData.signInWithGoogle();
    if (user != null) {
      SharedPreferenceHelper.shared.setUserId(googleAuthData.user!.uid);
      SharedPreferenceHelper.shared.setLoginStatus(true);
      // ignore: use_build_context_synchronously
      Provider.of<ProviderState>(context, listen: false)
          .setId(googleAuthData.user!.uid);

      // ignore: use_build_context_synchronously
      NavByMe.pushCompleteReplacement(context, const Dashboard());
    } else {
      // ignore: use_build_context_synchronously
      SnackMesage.exception("Try Again Later", context);
    }
  }

  _buildFirstImage() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Constant.appDefaultPadding),
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          height: 150,
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Constant.appDefaultPadding),
            image: const DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/man.jpg'),
            ),
          ),
        ),
      ),
    );
  }

  _buildSecondImage() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Constant.appDefaultPadding),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Transform.rotate(
          angle: 50.5,
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Constant.appDefaultPadding),
              image: const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/woman_01.jpg'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildThirdImage() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Constant.appDefaultPadding),
      child: Align(
        alignment: Alignment.centerRight,
        child: Transform.rotate(
          angle: 50.02,
          child: Container(
            height: 180,
            width: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Constant.appDefaultPadding),
              image: const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/woman_02.png'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
