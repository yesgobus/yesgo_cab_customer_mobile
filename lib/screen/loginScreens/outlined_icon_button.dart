import 'package:flutter/material.dart';

import '../../../utils/appcolors/app_colors.dart';

class CustomOutlinedIconButton extends StatelessWidget {
  const CustomOutlinedIconButton({
    super.key,
    this.onPressed,
    required this.label,
    this.radius = 12,
    this.color,
    required this.icon,
    this.borderWidth,
    this.size = const Size(200, 45),
  });
  final void Function()? onPressed;
  final Widget label;
  final Widget icon;
  final Size size;
  final double radius;
  final Color? color;
  final double? borderWidth;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(foregroundColor: AppColors.blackColor,
          minimumSize: size,
          side: BorderSide(
              color: color ?? theme.colorScheme.outlineVariant,
              width: borderWidth ?? 1),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius))),
      onPressed: onPressed,
      label: label,
      icon: icon,
    );
  }
}
