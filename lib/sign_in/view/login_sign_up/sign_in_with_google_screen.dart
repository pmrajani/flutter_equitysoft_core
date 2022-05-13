import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/function_utils.dart';
import '../../../utils/image_utils.dart';
import '../../controller/sign_in_with_controller.dart';
import '../../auth_service/social_media_auth_service.dart';

class SignInWithGoogleScreen extends StatelessWidget {
  SignInWithGoogleScreen({Key? key}) : super(key: key);

  final SignInWithController controller = Get.put(SignInWithController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _signOut();
        return Future<bool>.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Sign In With Google"),
        ),
        body: _bodyWidget(),
      ),
    );
  }

  Widget _bodyWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _getGoogleLogIn(),
          ],
        ),
      ),
    );
  }

  Widget _getGoogleLogIn() {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          _signInWithGoogle();
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Image.asset(
                ImageUtils.googleLogo,
                height: 35.0,
                width: 35.0,
              ),
            ),
            const Spacer(),
            const Text(
              "Sign In With Google",
            ),
            const Spacer(),
          ],
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Colors.redAccent,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    controller.user = await SocialMediaAuthService.googleSignIn();

    if (controller.user != null) {
      CommonValidate.snackBar(
        title: "Success",
        message: "Sign in successfully with google",
        isSuccess: true,
      );
    } else {
      CommonValidate.snackBar(
        title: "Failed",
        message: "Please Try Again",
      );
    }
  }

  Future<void> _signOut() async {
    if (controller.user != null) {
      await SocialMediaAuthService.signOutGoogle();
    }
    Get.back();
  }
}
