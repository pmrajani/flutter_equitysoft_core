import 'package:flutter/material.dart';
import 'package:flutter_equitysoft_core/utils/image_utils.dart';
import 'package:get/get.dart';

import '../../controller/sign_in_with_controller.dart';
import '../../service/firebase_auth/auth_service.dart';
import '../../utils/function_utils.dart';

/// NOTE : CREATE YOUR HASE KEY :
/// https://tomeko.net/online_tools/hex_to_base64.php

class SignInWithFaceBookScreen extends StatelessWidget {
  SignInWithFaceBookScreen({Key? key}) : super(key: key);

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
          title: const Text("Sign In With FaceBook"),
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
            _getFacebookLogIn(),
          ],
        ),
      ),
    );
  }

  Widget _getFacebookLogIn() {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          _signInWithFB();
        },
        child: Row(
          children: [
            Image.asset(
              ImageUtils.fbLogo,
              height: 40.0,
              width: 40.0,
            ),
            const Spacer(),
            Text(
              "Log In With Facebook",
              style: Get.textTheme.bodyText2!.copyWith(
                color: Colors.white,
              ),
            ),
            const Spacer(),
          ],
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Colors.blue,
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

  Future<void> _signInWithFB() async {
    controller.user = await AuthService.faceBookSignIn();

    if (controller.user != null) {
      CommonValidate.snackBar(
        title: "Success",
        message: "Sign in successfully with facebook",
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
      await AuthService.signOutFaceBook();
    }
    Get.back();
  }
}
