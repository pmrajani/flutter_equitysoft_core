import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/color_utils.dart';
import 'login_sign_up/anonymously_login_screen.dart';
import 'login_sign_up/forgot_password_screen.dart';
import 'login_sign_up/login_with_apple_screen.dart';
import 'login_sign_up/normal_login_screen.dart';
import 'login_sign_up/normal_sign_up_screen.dart';
import 'login_sign_up/sign_in_with_face_book_screen.dart';
import 'login_sign_up/sign_in_with_google_screen.dart';
import 'login_sign_up/sign_in_with_phone_screen.dart';

class SignInDetailsScreen extends StatelessWidget {
  const SignInDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
      body: _bodyWidget(context),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _cardView(
              title: "Google",
              subTitle: "Sign In With Google",
              onTap: () {
                Get.to(() => SignInWithGoogleScreen());
              },
            ),
            _cardView(
              title: "FaceBook",
              subTitle: "Sign In With FaceBook",
              onTap: () {
                Get.to(() => SignInWithFaceBookScreen());
              },
            ),
            _cardView(
              title: "Apple",
              subTitle: "Sign In With Apple",
              onTap: () {
                Get.to(() => LoginWithApple());
              },
            ),
            _cardView(
              title: "Email And Password",
              subTitle: "Sign Up With Email and Password",
              onTap: () {
                Get.to(() => NormalSignUpScreen());
              },
            ),
            _cardView(
              title: "Email And Password",
              subTitle: "Sign In With Email and Password",
              onTap: () {
                Get.to(() => NormalLoginScreen());
              },
            ),
            _cardView(
              title: "Anonymously",
              subTitle: "Sign In With Anonymously",
              onTap: () {
                Get.to(() => AnonymouslyLoginScreen());
              },
            ),
            _cardView(
              title: "Phone",
              subTitle: "Sign in with Phone",
              onTap: () {
                Get.to(() => SignInWithPhoneScreen());
              },
            ),
            _cardView(
              title: "Forgot Password",
              subTitle: "Sent forgot password reset link",
              onTap: () {
                Get.to(() => ForgotPasswordScreen());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardView({
    required String title,
    required String subTitle,
    required Function onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 17.0,
            color: AppColors.appColorBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            subTitle,
            style: TextStyle(
              fontSize: 14.0,
              color: AppColors.blackColor.withOpacity(0.75),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        iconColor: AppColors.appColorBlue,
        trailing: const Icon(Icons.keyboard_arrow_right),
        onTap: () {
          onTap();
        },
      ),
    );
  }

  Widget _roundV(String txt) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.appColorBlue,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 7.0,
        horizontal: 11.0,
      ),
      margin: const EdgeInsets.all(7.0),
      child: Text(
        txt,
        style: const TextStyle(
          color: AppColors.whiteColor,
          fontSize: 15.0,
        ),
      ),
    );
  }
}
