
import 'package:flutter/material.dart';

import '../../utils/appcolors/app_colors.dart';

tickWidget() {
  return Padding(
    padding: const EdgeInsets.only(left: 8),
    child: Icon(
      Icons.verified,
      color: AppColors.greenColor,
    ),
  );
}
