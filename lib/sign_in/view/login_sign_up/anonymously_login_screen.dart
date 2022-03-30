import 'package:flutter/material.dart';
import 'package:flutter_equitysoft_core/utils/color_utils.dart';
import 'package:get/get.dart';

import '../../../utils/function_utils.dart';
import '../../controller/sign_in_with_controller.dart';
import '../../auth_service/social_media_auth_service.dart';

class AnonymouslyLoginScreen extends StatelessWidget {
  AnonymouslyLoginScreen({Key? key}) : super(key: key);

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
          title: const Text("Sign In As Anonymously"),
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
            _getAnonymouslyLogIn(),
          ],
        ),
      ),
    );
  }

  Widget _getAnonymouslyLogIn() {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          _signIn();
        },
        child: const Text(
          "Sign In As Anonymously",
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            AppColors.appColorBlue,
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

  Future<void> _signIn() async {
    controller.user = await SocialMediaAuthService.singInAnonymously();

    if (controller.user != null) {
      CommonValidate.snackBar(
        title: "Success",
        message: "Sign in successfully with Anonymously",
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
      await SocialMediaAuthService.signOut();
    }
    Get.back();
  }
}
