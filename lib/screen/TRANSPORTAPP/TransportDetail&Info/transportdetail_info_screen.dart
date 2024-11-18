import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:yesgo_cab_customer/controller/CAB/homeController/home_controller.dart';
import 'package:yesgo_cab_customer/controller/TRANSPORT/homeController/home_controller_trans.dart';
import 'package:yesgo_cab_customer/controller/TRANSPORT/transportTripController/transport_trip_controller.dart';
import 'package:yesgo_cab_customer/screen/TRANSPORTAPP/homeScreen/home_screen_transport.dart';
import 'package:yesgo_cab_customer/utils/appcolors/app_colors.dart';
import 'package:yesgo_cab_customer/utils/constant/app_var.dart';
import 'package:yesgo_cab_customer/utils/constant/png_asset_constant.dart';
import 'package:yesgo_cab_customer/widget/buttons/button.dart';
import 'package:yesgo_cab_customer/widget/text_field/text_field.dart';
import 'package:yesgo_cab_customer/widget/textwidget/text_widget.dart';

import '../../CAB/cabSearchScreen/cab_search_screen.dart';
import 'chooseGoodsTypeScreen/choose_goods_screen.dart';

class TransportDetailInfoScreen extends StatefulWidget {
  const TransportDetailInfoScreen({super.key});

  @override
  State<TransportDetailInfoScreen> createState() =>
      _TransportDetailInfoScreenState();
}

class _TransportDetailInfoScreenState extends State<TransportDetailInfoScreen> {
  HomeControllerTrans homeControllerTrans = Get.find();
  TransportController transportController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey1Color,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.whiteColor,
            padding:
                const EdgeInsets.only(top: 4, left: 12, right: 12, bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(Icons.arrow_back)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextWidget(
                        text: "${transportController.vehicleDetailData!.route}",
                        textSize: 16,
                        maxLine: 2,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 36, top: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                          text:
                              "Pickup at ${transportController.vehicleDetailData!.pickupTime}",
                          textSize: 13),
                      const SizedBox(width: 8),
                      TextWidget(
                          text:
                              "${transportController.vehicleDetailData!.currentDate}",
                          textSize: 13),
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  sizedTextfield,
                  tempoDetails(),
                  sizedTextfield,
                  farePrice(),
                  sizedTextfield,
                  if (transportController.selectedGoodsCatID.isNotEmpty)
                    goodsType(),
                  if (transportController.selectedGoodsCatID.isNotEmpty)
                    sizedTextfield,
                  readBeforeBook(),
                  sizedTextfield,
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: AppButton.primaryButton(
          onButtonPressed: () {
            if (transportController.selectedGoodsCatID.isEmpty) {
              Get.to(const ChooseGoodsTypeScreen())!
                  .whenComplete(() => setState(() {}));
            } else {
              transportController.bookkingReq(
                  context: context,
                  cabId: homeControllerTrans.selectedVehicleId);
            }
          },
          borderRadius: 0,
          title: transportController.selectedGoodsCatID.isEmpty
              ? "Choose Goods Type"
              : "Done"),
    );
  }

  tempoDetails() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.grey3Color),
          color: AppColors.whiteColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.network(
                '${transportController.vehicleDetailData!.image}',
                width: 80,
                height: 65,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text:
                          "${transportController.vehicleDetailData!.vehicleName}",
                      textSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                    TextWidget(
                      text:
                          "${transportController.vehicleDetailData!.pickupDuration} away",
                      textSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkGreenColor,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.timer,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: TextWidget(
                              text:
                                  "Free ${transportController.vehicleDetailData!.includedLoadingTime} Loading/UnLoading Time Included",
                              maxLine: 2,
                              textSize: 10),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                        radius: 6, backgroundColor: AppColors.darkGreenColor),
                    Container(
                        height: 32,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        width: 1,
                        color: AppColors.blackColor),
                    CircleAvatar(
                        radius: 6, backgroundColor: AppColors.redColor),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: homeControllerTrans.fromAddress.text,
                      textSize: 14,
                      fontWeight: FontWeight.w500,
                      maxLine: 3,
                    ),
                    const Divider(
                      thickness: 0.8,
                    ),
                    TextWidget(
                      text: homeControllerTrans.toAddress.text,
                      textSize: 14,
                      fontWeight: FontWeight.w500,
                      maxLine: 3,
                    )
                  ],
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }

  farePrice() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.grey3Color),
          color: AppColors.whiteColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextWidget(
              text: "Fare Summary", textSize: 15, fontWeight: FontWeight.w500),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TextWidget(text: "Trip Fare(include toll)", textSize: 15),
              TextWidget(
                  text: "${transportController.vehicleDetailData!.fare}",
                  fontWeight: FontWeight.w500,
                  textSize: 15),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TextWidget(
                  text: "Amount Payable (rounded)",
                  fontWeight: FontWeight.w500,
                  textSize: 15),
              TextWidget(
                  text: "${transportController.vehicleDetailData!.roundedFare}",
                  color: AppColors.darkGreenColor,
                  fontWeight: FontWeight.w500,
                  textSize: 18),
            ],
          ),
        ],
      ),
    );
  }

  goodsType() {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.grey3Color),
          color: AppColors.whiteColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                  text:
                      "Goods Type (${transportController.selectedGoodsCatName.length} Qty)",
                  textSize: 15,
                  fontWeight: FontWeight.w500),
              InkWell(
                onTap: () {
                  Get.to(const ChooseGoodsTypeScreen())!
                      .whenComplete(() => setState(() {}));
                  setState(() {});
                },
                child: TextWidget(
                  text: "Change",
                  color: AppColors.mediumBlueColor,
                  textSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
          const Divider(),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transportController.selectedGoodsCatName.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextWidget(
                    text: transportController.selectedGoodsCatName[index],
                    textSize: 14),
              );
            },
          ),
        ],
      ),
    );
  }

  readBeforeBook() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.grey3Color),
          color: AppColors.whiteColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextWidget(
              text: "Read before you book!",
              textSize: 15,
              fontWeight: FontWeight.w500),
          const Divider(),
          const TextWidget(
            text: "Highlights",
            textSize: 14,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 8),
          ListView.builder(
            itemCount:
                transportController.vehicleDetailData!.highlights!.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextWidget(
                    text:
                        "● ${transportController.vehicleDetailData!.highlights![index]}",
                    maxLine: 2,
                    textSize: 14),
              );
            },
          ),
        ],
      ),
    );
  }
}
