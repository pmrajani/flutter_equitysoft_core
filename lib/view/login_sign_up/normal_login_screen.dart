import 'package:flutter/material.dart';
import 'package:flutter_equitysoft_core/controller/normal_login_controller.dart';
import 'package:flutter_equitysoft_core/service/auth_service.dart';
import 'package:flutter_equitysoft_core/utils/color_utils.dart';
import 'package:get/get.dart';

import '../../utils/function_utils.dart';

class NormalLoginScreen extends StatelessWidget {
  NormalLoginScreen({Key? key}) : super(key: key);

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
          title: const Text("Sign In With Email And Password"),
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
              enabled: false,
              decoration: InputDecoration(
                labelText: "email".tr,
                hintText: "enterEmail".tr,
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
              enabled: false,
              decoration: InputDecoration(
                labelText: "password".tr,
                hintText: "enterPassword".tr,
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
                _signIn();
              },
              child: const Text(
                "Sign In",
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

  Future<void> _signIn() async {
    controller.userId = await AuthService.singIn(
      email: controller.emailTextController.value.text,
      password: controller.passwordTextController.value.text,
    );

    if (controller.userId.isNotEmpty) {
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
