import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_equitysoft_core/controller/normal_login_controller.dart';
import 'package:flutter_equitysoft_core/service/firebase_auth/auth_service.dart';
import 'package:flutter_equitysoft_core/utils/color_utils.dart';
import 'package:get/get.dart';

import '../../utils/function_utils.dart';

class NormalSignUpScreen extends StatelessWidget {
  NormalSignUpScreen({Key? key}) : super(key: key);

  final NormalLoginController controller = Get.put(NormalLoginController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _signOut();
        return Future<bool>.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Sign Up With Email And Password"),
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
            TextFormField(
              controller: controller.emailTextController.value,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "Enter Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: controller.passwordTextController.value,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "Enter Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
              onPressed: () {
                if (!GetUtils.isEmail(
                    controller.emailTextController.value.text)) {
                  return CommonValidate.snackBar(
                      title: "Email Not Correct",
                      message: "Please enter valid email address");
                } else if (controller
                    .passwordTextController.value.text.isEmpty) {
                  return CommonValidate.snackBar(
                      title: "Password Is Empty",
                      message: "Please enter your password");
                } else {
                  _signUp();
                }
              },
              child: const Text(
                "Sign Up",
              ),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(AppColors.appColorBlue),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signUp() async {
    UserCredential? credential = await AuthService.signUp(
      email: controller.emailTextController.value.text,
      password: controller.passwordTextController.value.text,
    );

    if (credential!.user != null) {
      CommonValidate.snackBar(
        title: "Success",
        message: "Sign in successfully with email",
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
    if (controller.userId.isNotEmpty) {
      await AuthService.signOut();
    }
    Get.back();
  }
}
