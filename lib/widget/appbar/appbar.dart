import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/appcolors/app_colors.dart';
import '../textwidget/text_widget.dart';

class HelperAppBar {
  static appbarHelper({
    required String title,
    List<Widget>? action,
    PreferredSizeWidget? bottom,
    Color? bgColor,
    bool? hideBack,
  }) {
    return PreferredSize(
        preferredSize: Size(0, 56),
        child: AppBar(
          backgroundColor: bgColor,
          elevation: 0, titleSpacing: 0,
          iconTheme: IconThemeData(color: AppColors.blackColor),
          title: TextWidget(
              text: title,
              fontWeight: FontWeight.w500,
              maxLine: 2,
              textSize: 17),
          bottom: bottom,
          // automaticallyImplyLeading: hideBack == true ? false : true,
          actions: action,
          leading: hideBack == true
              ? null
              : IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_sharp,
                    size: 20,
                    color: AppColors.blackColor,
                  ),
                ),
        ));
  }
}
