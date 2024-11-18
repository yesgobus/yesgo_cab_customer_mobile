import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/appcolors/app_colors.dart';
import '../textwidget/text_widget.dart';

class MyCustomTextField {
  static Widget textField({
    required String hintText,
    String? valText,
    int? maxLine,
    int? maxLength,
    bool readonly = false,
    bool obcureText = false,
    Color? borderClr,
    double? borderRadius,
    Color? fillColor,
    Color? textClr,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Function()? onTap,
    required TextEditingController controller,
    TextInputType? textInputType,
  }) {
    return TextFormField(
      readOnly: readonly,
      maxLines: maxLine ?? 1,
      controller: controller,
      maxLength: textInputType == TextInputType.phone ? 10 : maxLength,
      keyboardType: textInputType,
      style: TextStyle(
        color: textClr ?? AppColors.blackColor,
        fontSize: 15,
      ),
      validator: (value) {
        if (value == '') {
          if (valText != null) {
            return valText;
          }
        }
        return null;
      },
      onTap: onTap,
      obscureText: obcureText, 
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: textClr ?? AppColors.black65,
            fontSize: 13,fontWeight: FontWeight.w400
          ),
          // labelText: hintText,
          alignLabelWithHint: true,
          // labelStyle: TextStyle(color: AppColors.blackColor, fontSize: 13),
          // label: TextWidget(text: hintText, textSize: 15),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 6),
              borderSide: BorderSide(
                  color: borderClr ?? AppColors.black65, width: 1.5)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 6),
              borderSide: BorderSide(
                  color: borderClr ?? AppColors.black65, width: 1.5)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 6),
              borderSide: BorderSide(
                  color: borderClr ?? AppColors.black65, width: 1.5)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 6),
              borderSide: BorderSide(
                  color: borderClr ?? AppColors.black65, width: 1.5)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 6),
              borderSide: BorderSide(
                  color: borderClr ?? AppColors.black65, width: 1.5)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 6),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          counterText: "",
          suffixIcon: suffixIcon,
          // constraints: BoxConstraints(maxHeight: 50),
          prefixIcon: prefixIcon),
    );
  }

  static textFieldPassword({
    required String hintText,
    required bool isObscureText,
    required String valText,
    int? maxLine,
    required TextEditingController controller,
    bool? isPasswordField,
  }) {
    RxBool isVisible = true.obs;
    isVisible.value = isObscureText;
    return Obx(() {
      return TextFormField(
        maxLines: maxLine ?? 1,
        controller: controller,
        decoration: InputDecoration(
          counterText: '',
          alignLabelWithHint: true,
          filled: true,
          fillColor: AppColors.whiteColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: AppColors.black65),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: AppColors.black65),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: AppColors.black65),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          hintText: hintText.tr,
          hintStyle: TextStyle(color: AppColors.black65,fontWeight: FontWeight.w400, fontSize: 14),
          // constraints: BoxConstraints(maxHeight: 50),
          suffixIcon: isPasswordField != null
              ? InkWell(
                  onTap: () {
                    isVisible.value = !isVisible.value;
                  },
                  child: Icon(
                    !isVisible.value ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.black65,
                  ),
                )
              : const SizedBox(),
        ),
        obscureText: isVisible.value,
        validator: (value) {
          if (value == '') {
            return valText;
          }
          return null;
        },
      );
    });
  }

  static textFieldPhone({
    required String hintText,
    String? valText,
    int? maxLine,
    bool readonly = false,
    Color? borderClr,
    Color? fillColor,
    Color? textClr,
    double? borderRadius,
    required TextEditingController controller,
    TextInputType? textInputType,
  }) {
    return TextFormField(
      readOnly: readonly,
      maxLines: maxLine ?? 1,
      controller: controller,
      style: TextStyle(
        color: textClr ?? AppColors.blackColor,
        fontSize: 15,
      ),
      maxLength: 10,
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == '') {
          if (valText != null) {
            return valText;
          }
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: textClr ?? AppColors.black65,
          fontSize: 13,fontWeight: FontWeight.w400
        ),
        constraints: BoxConstraints(minHeight: 40),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 6),
            borderSide: BorderSide(
                color: borderClr ?? AppColors.blackColor, width: 1.5)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 6),
            borderSide: BorderSide(
                color: borderClr ?? AppColors.blackColor, width: 1.5)),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 6),
            borderSide: BorderSide(
                color: borderClr ?? AppColors.blackColor, width: 1.5)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 6.0),
          borderSide:
              BorderSide(color: borderClr ?? AppColors.blackColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 6),
            borderSide:
                BorderSide(color: borderClr ?? AppColors.black65, width: 1.5)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 6),
            borderSide:
                BorderSide(color: borderClr ?? AppColors.black65, width: 1.5)),
        counterText: "",
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        prefixIcon: SizedBox(
            width: 60,
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextWidget(
                    text: "+91",
                    align: TextAlign.center,
                    color: borderClr ?? AppColors.blackColor,
                    textSize: 16),
                const SizedBox(width: 10),
                Container(
                  height: 30,
                  width: 1.5,
                  color: borderClr ?? AppColors.black65,
                ),
                const SizedBox(width: 10),
              ],
            ))),
        prefixStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  static textFieldSearch({
    required String hintText,
    String? valText,
    int? maxLine,
    bool readonly = false,
    Color? borderClr,
    Color? fillColor,
    Color? textClr,
    required TextEditingController controller,
    TextInputType? textInputType,
  }) {
    return TextFormField(
      readOnly: readonly,
      maxLines: maxLine ?? 1,
      controller: controller,
      maxLength: textInputType == TextInputType.phone ? 10 : null,
      keyboardType: textInputType,
      validator: (value) {
        if (value == '') {
          if (valText != null) {
            return valText;
          }
        }
        return null;
      },
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: textClr ?? AppColors.black65,
            fontSize: 13,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: AppColors.grey3Color)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: AppColors.grey3Color)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: AppColors.grey3Color)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          filled: true,
          fillColor: AppColors.grey1Color,
          suffixIcon: Padding(
            padding: EdgeInsets.all(8),
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(6)),
              child: Icon(
                Icons.search,
                color: AppColors.whiteColor,
              ),
            ),
          )),
    );
  }
}
