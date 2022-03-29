import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

import '../../controller/normal_login_controller.dart';
import '../../service/firebase_auth/auth_service.dart';
import '../../utils/color_utils.dart';
import '../../utils/function_utils.dart';
import '../../utils/logger_utils.dart';

class SignInWithPhoneScreen extends StatelessWidget {
  SignInWithPhoneScreen({Key? key}) : super(key: key);

  final NormalLoginController controller = Get.put(NormalLoginController());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _signOut();
        return Future<bool>.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Sign In With Phone"),
        ),
        body: _bodyWidget(context),
      ),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CupertinoActivityIndicator(),
        );
      } else {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  controller.isOtpSent.value
                      ? _otpView(context)
                      : TextFormField(
                          controller: controller.phoneTextController.value,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: "Phone",
                            hintText: "Enter Phone Number",
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
                      if (controller.phoneTextController.value.text.length !=
                          10) {
                        return CommonValidate.snackBar(
                            title: "Phone Number Not Valid",
                            message: "Please enter valid phone number");
                      } else {
                        if (controller.isOtpSent.value) {
                          _verifyOTP();
                        } else {
                          _sendOTP();
                        }
                      }
                    },
                    child: Text(
                      controller.isOtpSent.value ? "Verify OTP" : "Send OTP",
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          AppColors.appColorBlue),
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
          ),
        );
      }
    });
  }

  Widget _otpView(BuildContext context) {
    return OTPTextField(
      length: 6,
      width: Get.width - 20,
      fieldWidth: 30,
      style: const TextStyle(fontSize: 17),
      textFieldAlignment: MainAxisAlignment.spaceAround,
      fieldStyle: FieldStyle.underline,
      keyboardType: TextInputType.number,
      onChanged: (String? val) {},
      onCompleted: (String? pin) {
        CommonValidate.closeKeyBoard(context);
        if (pin != null) {
          controller.isLoading.value = true;
          controller.otp = pin;
          _verifyOTP();
        }
      },
    );
  }

  Future<void> _sendOTP() async {
    controller.isLoading.value = true;

    await _auth.verifyPhoneNumber(
      phoneNumber: "+91" + controller.phoneTextController.value.text,
      verificationCompleted: _verificationCompleted,
      verificationFailed: _verificationFailed,
      codeSent: _codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      timeout: const Duration(seconds: 60),
    );
  }

  void codeAutoRetrievalTimeout(String verificationId) {}

  void _verificationFailed(FirebaseAuthException error) {
    if (error.code == 'invalid-phone-number') {
      CommonValidate.snackBar(
        title: "Not Valid",
        message: "The provided mobile no. is not valid",
      );

      controller.isLoading.value = false;
    } else {
      logger.e(error);
      logger.e(error.code);

      CommonValidate.snackBar(title: "ERROR", message: error.code);

      controller.isLoading.value = false;
    }
  }

  void _verificationCompleted(PhoneAuthCredential phoneAuthCredential) {
    logger.w(phoneAuthCredential.smsCode!);
    _verifyOTP(phoneAuthCredential: phoneAuthCredential);
  }

  void _codeSent(String verificationId, int? forceResendingToken) {
    controller.verificationId = verificationId;
    controller.isLoading.value = false;
    controller.isOtpSent.value = true;
    logger.wtf("Code Sent");
    CommonValidate.snackBar(
      title: "success".tr,
      message:
          "OTP has been sent on +91${controller.phoneTextController.value.text}",
      isSuccess: true,
    );
  }

  Future<void> _verifyOTP({PhoneAuthCredential? phoneAuthCredential}) async {
    try {
      controller.isLoading.value = true;

      phoneAuthCredential ??= PhoneAuthProvider.credential(
          verificationId: controller.verificationId, smsCode: controller.otp);

      UserCredential user =
          await _auth.signInWithCredential(phoneAuthCredential);

      if (user.user != null) {
        CommonValidate.snackBar(
          title: "Success",
          message: "Sign in successfully with phone",
          isSuccess: true,
        );
        controller.phoneTextController.value.text = "";
        controller.isOtpSent.value = false;
      } else {
        CommonValidate.snackBar(
          title: "Failed",
          message: "Please Try Again",
        );
      }
    } catch (e) {
      logger.e(e);
      controller.isLoading.value = false;
      if (e.toString() == AuthService.errWrongOTP) {
        CommonValidate.snackBar(
            title: "Incorrect OTP".tr,
            message: "Please check your OTP and re-enter OTP".tr);
      } else {
        CommonValidate.snackBar(
          title: "failed".tr,
          message: "reOTPAndTryAgain".tr,
        );
      }
    }
    controller.isLoading.value = false;
  }

  Future<void> _signOut() async {
    if (controller.userId.isNotEmpty) {
      await AuthService.signOut();
    }
    Get.back();
  }
}
