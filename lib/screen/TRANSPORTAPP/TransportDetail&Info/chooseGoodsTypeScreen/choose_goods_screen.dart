import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:yesgo_cab_customer/controller/CAB/homeController/home_controller.dart';
import 'package:yesgo_cab_customer/controller/TRANSPORT/homeController/home_controller_trans.dart';
import 'package:yesgo_cab_customer/controller/TRANSPORT/transportTripController/transport_trip_controller.dart';
import 'package:yesgo_cab_customer/utils/appcolors/app_colors.dart';
import 'package:yesgo_cab_customer/utils/helper/helper.dart';
import 'package:yesgo_cab_customer/widget/appbar/appbar.dart';
import 'package:yesgo_cab_customer/widget/buttons/button.dart';
import 'package:yesgo_cab_customer/widget/textwidget/text_widget.dart';

class ChooseGoodsTypeScreen extends StatefulWidget {
  const ChooseGoodsTypeScreen({super.key});

  @override
  State<ChooseGoodsTypeScreen> createState() => _ChooseGoodsTypeScreenState();
}

class _ChooseGoodsTypeScreenState extends State<ChooseGoodsTypeScreen> {
  HomeControllerTrans homeControllerTrans = Get.find();
  TransportController transportController = Get.find();
  int selectdIndex = -1;
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      transportController.getGoodsListDetails();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HelperAppBar.appbarHelper(title: "Select Goods Type"),
      body: Obx(() => transportController.isLoading.value
          ? Helper.pageLoading()
          : ListView.builder(
              itemCount: transportController.goodsCatList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {
                    if (transportController.selectedGoodsCatID.contains(
                        transportController.goodsCatList[index].goodsId!)) {
                      transportController.selectedGoodsCatID.remove(
                          transportController.goodsCatList[index].goodsId!);
                      transportController.selectedGoodsCatName.remove(
                          transportController.goodsCatList[index].goodsName!);
                    } else {
                      transportController.selectedGoodsCatID.add(
                          transportController.goodsCatList[index].goodsId!);
                      transportController.selectedGoodsCatName.add(
                          transportController.goodsCatList[index].goodsName!);
                    }
                    log("message ${transportController.selectedGoodsCatID}");
                    setState(() {});
                  },
                  title: TextWidget(
                      text:
                          "${transportController.goodsCatList[index].goodsName}",
                      maxLine: 2,
                      textSize: 14),
                  subtitle: TextWidget(
                    text: "${transportController.goodsCatList[index].goodsDes}",
                    textSize: 12,
                    maxLine: 2,
                  ),
                  selected: transportController.selectedGoodsCatID.contains(
                          transportController.goodsCatList[index].goodsId)?true:false,
                  visualDensity: VisualDensity.compact,selectedTileColor: AppColors.grey1Color,
                  trailing: transportController.selectedGoodsCatID.contains(
                          transportController.goodsCatList[index].goodsId)
                      ? Icon(Icons.check, color: AppColors.darkGreenColor)
                      : null,
                );
              },
            )),
      bottomNavigationBar: Obx(() => transportController.isLoading.value
          ? const SizedBox()
          : Padding(
              padding: EdgeInsets.all(10),
              child: AppButton.primaryButton(
                  onButtonPressed: () {
                    Get.back();
                  },
                  title: "Done"),
            )),
    );
  }
}
