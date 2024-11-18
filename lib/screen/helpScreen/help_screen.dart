import 'package:flutter/material.dart';
import 'package:yesgo_cab_customer/utils/appcolors/app_colors.dart';
import 'package:yesgo_cab_customer/utils/constant/app_var.dart';
import 'package:yesgo_cab_customer/utils/constant/png_asset_constant.dart';
import 'package:yesgo_cab_customer/widget/buttons/button.dart';
import 'package:yesgo_cab_customer/widget/textwidget/text_widget.dart';

import '../../widget/appbar/appbar.dart';
import '../drawerScreen/drawer_screen.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey1Color,
      drawer: const DrawerWidget(),
      appBar: HelperAppBar.appbarHelper(title: "Help", hideBack: true),
      body: Column(
        children: [
          Container(
            // padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.grey3Color),
                color: AppColors.whiteColor),
            child: Column(
              children: [
                ListTile(
                  visualDensity: VisualDensity.compact,
                  leading: const Icon(
                    Icons.bus_alert,
                    color: AppColors.primaryColor,
                  ),
                  title: const TextWidget(
                      text: "Bus Booking Help",
                      fontWeight: FontWeight.w500,
                      textSize: 16),
                  subtitle: const TextWidget(
                      text: "Bus availability / Child fare / Luggage.",
                      textSize: 12),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.black45,
                    size: 20,
                  ),
                ),
                const Divider(height: 0),
                ListTile(
                  visualDensity: VisualDensity.compact,
                  leading: const Icon(
                    Icons.money,
                    color: AppColors.primaryColor,
                  ),
                  title: const TextWidget(
                      text: "Offers",
                      fontWeight: FontWeight.w500,
                      textSize: 16),
                  subtitle: const TextWidget(
                      text: "Need help with offers ?", textSize: 12),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.black45,
                    size: 20,
                  ),
                ),
                const Divider(height: 0),
                ListTile(
                  visualDensity: VisualDensity.compact,
                  leading: const Icon(
                    Icons.settings_applications_sharp,
                    color: AppColors.primaryColor,
                  ),
                  title: const TextWidget(
                      text: "Technical Issues",
                      fontWeight: FontWeight.w500,
                      textSize: 16),
                  subtitle: const TextWidget(
                      text: "Need some technical help ?", textSize: 12),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.black45,
                    size: 20,
                  ),
                ),
                const Divider(height: 0),
                ListTile(
                  visualDensity: VisualDensity.compact,
                  leading: const Icon(
                    Icons.wallet,
                    color: AppColors.primaryColor,
                  ),
                  title: const TextWidget(
                      text: "Yesgobus Wallet Help",
                      fontWeight: FontWeight.w500,
                      textSize: 16),
                  subtitle: const TextWidget(
                      text: "Need any help with yesgobus wallet ?",
                      textSize: 12),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.black45,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          sizedTextfield,
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.grey3Color),
                color: AppColors.whiteColor),
            child: Column(
              children: [
                Image.asset(PngAssetPath.supportImg),
                const SizedBox(height: 10),
                const TextWidget(
                  text:
                      "I am here to help you with your travel related queries",
                  textSize: 14,
                  maxLine: 2,
                ),
                sizedTextfield,
                AppButton.primaryButton(
                    onButtonPressed: () {}, title: "Contact Us")
              ],
            ),
          )
        ],
      ),
    );
  }
}
