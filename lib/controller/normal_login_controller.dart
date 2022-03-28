import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NormalLoginController extends GetxController {
  Rx<TextEditingController> emailTextController =
          TextEditingController(text: "abc@gmail.com").obs,
      passwordTextController = TextEditingController(text: "qwerty").obs;

  String userId = "";
}
