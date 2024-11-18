// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/appcolors/app_colors.dart';
import '../textwidget/text_widget.dart';

class DropDownWidget extends StatefulWidget {
  final String status;

  final Color? color;
  final List<String> statusList;
  final Function(String?) onChanged;
  final double? circleVal;
  final double? height;
  final RxBool? isValidate;

  const DropDownWidget(
      {Key? key,
      required this.status,
      required this.statusList,
      required this.onChanged,
      this.circleVal,
      this.isValidate,
       this.color,
      this.height})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DropDownWidgetState createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 50,
      padding: const EdgeInsets.only(left: 12, right: 12),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(widget.circleVal ?? 15),
        border: Border.all(color: AppColors.black65, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          isExpanded: true,
          hint: TextWidget(
              text: widget.status,
              textSize: 14,
              color: AppColors.blackColor,
              maxLine: 2,
              align: TextAlign.left),
          iconEnabledColor: AppColors.blackColor,
          iconDisabledColor: AppColors.blackColor,
          isDense: false,
          borderRadius: BorderRadius.circular(4),
          dropdownColor: AppColors.whiteColor,
          items: widget.statusList.map((String value) {
            return DropdownMenuItem(
                value: value,
                child: TextWidget(
                  text: value,
                  color: AppColors.blackColor,
                  textSize: 16,
                  fontWeight: FontWeight.w400,
                ));
          }).toList(),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
