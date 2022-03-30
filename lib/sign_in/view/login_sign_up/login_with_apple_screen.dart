import 'package:flutter/material.dart';
import 'package:flutter_equitysoft_core/utils/image_utils.dart';
import 'package:get/get.dart';

import '../../../utils/function_utils.dart';
import '../../controller/sign_in_with_controller.dart';
import '../../auth_service/social_media_auth_service.dart';

class LoginWithApple extends StatelessWidget {
  LoginWithApple({Key? key}) : super(key: key);

  final SignInWithController controller = Get.put(SignInWithController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In With Google"),
      ),
      body: _bodyWidget(),
    );
  }

  Widget _bodyWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _getAppleLogIn(),
          ],
        ),
      ),
    );
  }

  Widget _getAppleLogIn() {
    // if (Platform.isIOS) {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.0),
        border: Border.all(
          color: Colors.white,
        ),
      ),
      child: ElevatedButton(
        onPressed: () {
          _signInWithApple();
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Image.asset(
                ImageUtils.appleLogo,
                height: 27.0,
                width: 27.0,
              ),
            ),
            const Spacer(),
            const Text(
              "Sign in with Apple",
            ),
            const Spacer(),
          ],
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Colors.black,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
    // } else {
    //   return const Text("Device Not Found...");
    // }
  }

  Future<void> _signInWithApple() async {
    controller.user = await SocialMediaAuthService.appleSignIn();

    if (controller.user != null) {
      CommonValidate.snackBar(
        title: "Success",
        message: "Sign in successfully with apple",
        isSuccess: true,
      );
    } else {
      CommonValidate.snackBar(
        title: "Failed",
        message: "Please Try Again",
      );
    }
  }
}
