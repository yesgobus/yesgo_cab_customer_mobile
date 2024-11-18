import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:yesgo_cab_customer/controller/CAB/cabTripController/cab_trip_controller.dart';
import 'package:yesgo_cab_customer/screen/drawerScreen/drawer_screen.dart';
import 'package:yesgo_cab_customer/utils/appcolors/app_colors.dart';
import 'package:yesgo_cab_customer/utils/constant/app_var.dart';
import 'package:yesgo_cab_customer/utils/constant/png_asset_constant.dart';
import 'package:yesgo_cab_customer/widget/appbar/appbar.dart';
import 'package:yesgo_cab_customer/widget/textwidget/text_widget.dart';

import '../../utils/helper/helper.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int selectedTab = 0;
  CabController cabController = Get.put(CabController());
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      cabController.getCabBookHistory();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const DrawerWidget(),
        backgroundColor: AppColors.grey1Color,
        appBar: HelperAppBar.appbarHelper(title: "Bookings", hideBack: true),
        body: Obx(
          () => cabController.isLoading.value
              ? Helper.pageLoading()
              : Column(
                  children: [
                    sizedTextfield,
                    Row(
                      children: [
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              selectedTab = 0;
                              setState(() {});
                            },
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 6),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: selectedTab == 0
                                          ? AppColors.transparentColor
                                          : AppColors.black45),
                                  borderRadius: BorderRadius.circular(8),
                                  color: selectedTab == 0
                                      ? AppColors.primaryColor
                                      : AppColors.whiteColor),
                              child: Center(
                                  child: TextWidget(
                                      text: "Completed",
                                      color: selectedTab == 0
                                          ? AppColors.whiteColor
                                          : AppColors.blackColor,
                                      textSize: 16)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              selectedTab = 1;
                              setState(() {});
                            },
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 6),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: selectedTab == 1
                                          ? AppColors.transparentColor
                                          : AppColors.black45),
                                  borderRadius: BorderRadius.circular(8),
                                  color: selectedTab == 1
                                      ? AppColors.primaryColor
                                      : AppColors.whiteColor),
                              child: Center(
                                  child: TextWidget(
                                      text: "Cancelled",
                                      color: selectedTab == 1
                                          ? AppColors.whiteColor
                                          : AppColors.blackColor,
                                      textSize: 16)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                    ),
                    sizedTextfield,
                    selectedTab == 0 ? completed() : canceled()
                  ],
                ),
        ));
  }

  completed() {
    return Expanded(
      child: cabController.completed.isEmpty
          ? const Center(
              child: TextWidget(
                text: "No Data Found",
                textSize: 16,
                fontWeight: FontWeight.w500,
              ),
            )
          : ListView.separated(
              separatorBuilder: (context, index) {
                return const SizedBox(height: 18);
              },
              padding: const EdgeInsets.all(12),
              itemCount: cabController.completed.length,
              itemBuilder: (BuildContext context, int index) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      // padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          border: Border.all(color: AppColors.grey5Color),
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        children: [
                          Container(
                            height: 100,
                            width: Get.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8)),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(cabController
                                        .completed[index].carImage!))),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        text:
                                            "${cabController.completed[index].carName}",
                                        textSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CircleAvatar(
                                              radius: 5,
                                              backgroundColor:
                                                  AppColors.greenColor),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: TextWidget(
                                              text:
                                                  "${cabController.completed[index].startLocation}",
                                              textSize: 14,
                                              maxLine: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CircleAvatar(
                                              radius: 5,
                                              backgroundColor:
                                                  AppColors.redColor),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: TextWidget(
                                              text:
                                                  "${cabController.completed[index].endLocation}",
                                              textSize: 14,
                                              maxLine: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextWidget(
                                            text: cabController
                                                .completed[index].amountPaid!,
                                            textSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          SizedBox(width: 12),
                                          TextWidget(
                                            text: cabController
                                                .completed[index].kmCovered
                                                .toString(),
                                            textSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: -10,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 2),
                        decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.grey5Color)),
                        child: TextWidget(
                          text: "${cabController.completed[index].date}",
                          textSize: 12,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
    );
  }

  canceled() {
    return Expanded(
        child: cabController.cancelled.isEmpty
            ? const Center(
                child: TextWidget(
                  text: "No Data Found",
                  textSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              )
            : ListView.separated(
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 18);
                },
                padding: const EdgeInsets.all(12),
                itemCount: cabController.cancelled.length,
                itemBuilder: (BuildContext context, int index) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            border: Border.all(color: AppColors.grey5Color),
                            borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          children: [
                            Container(
                              height: 100,
                              width: Get.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8)),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(cabController
                                          .cancelled[index].carImage!))),
                            ),
                            const SizedBox(width: 12),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextWidget(
                                          text: cabController
                                              .cancelled[index].carName!,
                                          textSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CircleAvatar(
                                                radius: 5,
                                                backgroundColor:
                                                    AppColors.greenColor),
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: TextWidget(
                                                text:
                                                    "${cabController.cancelled[index].startLocation}",
                                                textSize: 14,
                                                maxLine: 2,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CircleAvatar(
                                                radius: 5,
                                                backgroundColor:
                                                    AppColors.redColor),
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: TextWidget(
                                                text:
                                                    "${cabController.cancelled[index].endLocation}",
                                                textSize: 14,
                                                maxLine: 2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 12)
                          ],
                        ),
                      ),
                      Positioned(
                        top: -10,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 2),
                          decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.grey5Color)),
                          child: TextWidget(
                            text: "${cabController.cancelled[index].date}",
                            textSize: 12,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      )
                    ],
                  );
                },
              ));
  }
}
