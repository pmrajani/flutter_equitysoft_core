import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'color_utils.dart';

class CommonValidate {
  static void closeKeyBoard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static void snackBar({
    required String title,
    required String message,
    bool isSuccess = false,
  }) {
    Get.snackbar(
      title,
      message,
      colorText: AppColors.whiteColor,
      borderRadius: 10.0,
      backgroundColor: !isSuccess ? AppColors.redColor : AppColors.appColorBlue,
      dismissDirection: DismissDirection.vertical,
      isDismissible: true,
      snackPosition: SnackPosition.BOTTOM,
      forwardAnimationCurve: Curves.decelerate,
      reverseAnimationCurve: Curves.decelerate,
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(15.0),
    );
  }
}
