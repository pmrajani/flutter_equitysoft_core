import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/color_utils.dart';
import '../../../utils/function_utils.dart';
import '../../controller/normal_login_controller.dart';
import '../../auth_service/social_media_auth_service.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  final NormalLoginController controller = Get.put(NormalLoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In With Email And Password"),
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
              height: 30.0,
            ),
            ElevatedButton(
              onPressed: () {
                if (!GetUtils.isEmail(
                    controller.emailTextController.value.text)) {
                  return CommonValidate.snackBar(
                      title: "Email Not Correct",
                      message: "Please enter valid email address");
                } else {
                  _sendLink();
                }
              },
              child: const Text(
                "Forgot Password",
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

  Future<void> _sendLink() async {
    bool result = await SocialMediaAuthService.forgotPassword(
      email: controller.emailTextController.value.text,
    );

    if (result) {
      CommonValidate.snackBar(
        title: "Success",
        message: "Forgot password reset link sent successfully to your email",
        isSuccess: true,
      );
    } else {
      CommonValidate.snackBar(
        title: "Email Not Found",
        message: "Please check your email and try again",
      );
    }
  }
}
