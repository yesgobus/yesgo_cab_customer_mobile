import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/appcolors/app_colors.dart';
import '../textwidget/text_widget.dart';

class AppButton {
  static Widget primaryButton({
    required void Function()? onButtonPressed,
    required String title,
    double? height,
    Color? bgColor,
    Color? textColor,
    double? width,
    double? fontSize,
    double? borderRadius,
  }) {
    return InkWell(
      onTap: onButtonPressed,
      child: Container(
        width: width ?? Get.width,
        height: height ?? 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 100),
          color: bgColor ?? AppColors.primaryColor,
        ),
        child: Center(
          child: TextWidget(
            text: title,
            textSize: fontSize ?? 15,
            fontWeight: FontWeight.w500,
            color: textColor ?? AppColors.whiteColor,
          ),
        ),
      ),
    );
  }

  static Widget outlineButton({
    required void Function()? onButtonPressed,
    required String title,
    double? height,
    Color? bgColor,
    Color? borderColor,
    double? width,
  }) {
    return Container(
      width: width ?? Get.width,
      height: height ?? 45,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor ?? AppColors.blackColor),
        borderRadius: BorderRadius.circular(100),
        color: bgColor ?? AppColors.transparentColor,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          minimumSize: const Size.fromHeight(4),
          shape: StadiumBorder(),
          backgroundColor: bgColor ?? AppColors.transparentColor,
        ),
        onPressed: onButtonPressed,
        child: TextWidget(
          text: title,
          textSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.blackColor,
        ),
      ),
    );
  }
}
