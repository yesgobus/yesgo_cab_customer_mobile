import 'package:flutter/material.dart';
import 'package:yesgo_cab_customer/screen/drawerScreen/drawer_screen.dart';
import 'package:yesgo_cab_customer/widget/appbar/appbar.dart';

import '../../utils/appcolors/app_colors.dart';
import '../../widget/textwidget/text_widget.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: HelperAppBar.appbarHelper(title: "Account", hideBack: true),
      body: Container(
        // padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.grey3Color),
            color: AppColors.whiteColor),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              visualDensity: VisualDensity.compact,
              leading: Icon(
                Icons.confirmation_num,
                color: AppColors.primaryColor,
              ),
              title: TextWidget(text: "Cancel Booking", textSize: 16),
            ),
            Divider(height: 0),
            ListTile(
              visualDensity: VisualDensity.compact,
              leading: Icon(
                Icons.money,
                color: AppColors.primaryColor,
              ),
              title: TextWidget(text: "Offers", textSize: 16),
            ),
            Divider(height: 0),
            ListTile(
              visualDensity: VisualDensity.compact,
              leading: Icon(
                Icons.info_outline_rounded,
                color: AppColors.primaryColor,
              ),
              title: TextWidget(text: "About Us", textSize: 16),
            ),
            Divider(height: 0),
            ListTile(
              visualDensity: VisualDensity.compact,
              leading: Icon(
                Icons.call,
                color: AppColors.primaryColor,
              ),
              title: TextWidget(text: "Contact Us", textSize: 16),
            ),
            Divider(height: 0),
            ListTile(
              visualDensity: VisualDensity.compact,
              leading: Icon(
                Icons.description,
                color: AppColors.primaryColor,
              ),
              title: TextWidget(text: "Terms & Conditions", textSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
