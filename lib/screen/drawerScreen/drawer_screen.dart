import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yesgo_cab_customer/screen/TRANSPORTAPP/homeScreen/home_screen_transport.dart';
import 'package:yesgo_cab_customer/screen/accountScreen/account_screen.dart';
import 'package:yesgo_cab_customer/screen/helpScreen/help_screen.dart';
import 'package:yesgo_cab_customer/screen/CAB/homeScreen/home_screen.dart';
import 'package:yesgo_cab_customer/utils/getStore/get_store.dart';

import '../../controller/profileController/profile_controller.dart';
import '../../utils/appcolors/app_colors.dart';
import '../../widget/dilogue/logout.dart';
import '../../widget/textwidget/text_widget.dart';
import '../bookingScreen/booking_screen.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final ProfileController profileController = Get.put(ProfileController());

  // final LogoutDialog _logout = LogoutDialog();
  List<String> items = [
    "Home",
    "Booking",
    "Transport",
    // "Account",
    // "Help",
  ];
  List<IconData> icons = [
    Icons.home,
    Icons.confirmation_num,
    Icons.local_shipping,
    Icons.person_rounded,
    Icons.support_agent,
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Get.to(() => AccountScreen());
                  },
                  child: Container(
                    color: AppColors.primaryColor,
                    height: 160,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const SizedBox(width: 20),
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: AppColors.whiteColor,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: const Icon(
                                  Icons.person,
                                  size: 60,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextWidget(
                                  text:
                                      '${GetStoreData.getStore.read('name') ?? ""}',
                                  textSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.whiteColor,
                                ),
                                SizedBox(height: 6),
                                TextWidget(
                                  text:
                                      "Mobile: ${GetStoreData.getStore.read('phone') ?? ""}",
                                  textSize: 14,
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w600,
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: items.length,
                    padding: const EdgeInsets.only(
                      top: 20,
                      bottom: 10,
                      right: 16,
                      left: 0,
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) => InkWell(
                      onTap: () {
                        profileController.selectedVal.value = index;

                        if (index == 0) {
                          Get.to(() => const HomeScreen());
                        } else if (index == 1) {
                          Get.to(() => const BookingScreen());
                        } else if (index == 2) {
                          Get.to(() => const HomeScreenTransport());
                        } else if (index == 3) {
                          Get.to(() => const AccountScreen());
                        } else if (index == 4) {
                          Get.to(() => const HelpScreen());
                        }
                        // Get.to(() => profileController.onTapList[index]);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            color: index == profileController.selectedVal.value
                                ? AppColors.primaryColor.withOpacity(0.3)
                                : Colors.transparent,
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(100),
                                bottomRight: Radius.circular(100))),
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: index == 4 || index == 7 ? 5 : 8,
                              top: index == 5 || index == 8 ? 5 : 8,
                              left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                icons[index],
                                color: AppColors.blackColor,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              TextWidget(
                                  text: items[index],
                                  textSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.blackColor,
                                  maxLine: 1,
                                  align: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                    ),
                    separatorBuilder: (BuildContext context, int index) {
                      return index == 4 || index == 7
                          ? const Divider(
                              height: 20,
                              thickness: 1,
                            )
                          : const SizedBox(
                              height: 5,
                            );
                    },
                  ),
                ),
                Divider(
                  color: AppColors.black45,
                  height: 30,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              showLogoutPopup(context);
            },
            child: Container(
              padding: const EdgeInsets.only(left: 20, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.logout),
                  const SizedBox(
                    width: 20,
                  ),
                  TextWidget(
                      text: "Logout",
                      textSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black65,
                      maxLine: 1,
                      align: TextAlign.center),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
