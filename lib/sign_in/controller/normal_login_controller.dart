import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NormalLoginController extends GetxController {
  Rx<TextEditingController> emailTextController = TextEditingController().obs,
      passwordTextController = TextEditingController().obs,
      phoneTextController = TextEditingController().obs;

  String userId = "", verificationId = "", otp = "";

  RxBool isLoading = false.obs, isOtpSent = false.obs;
}
