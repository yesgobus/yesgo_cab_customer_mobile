import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:yesgo_cab_customer/controller/CAB/cabTripController/cab_trip_controller.dart';
import 'package:yesgo_cab_customer/controller/CAB/homeController/home_controller.dart';
import 'package:yesgo_cab_customer/screen/CAB/homeScreen/home_screen.dart';
import 'package:yesgo_cab_customer/screen/CAB/rideAcceptScreen/ride_accepted_screen.dart';
import 'package:yesgo_cab_customer/utils/constant/png_asset_constant.dart';
import 'package:yesgo_cab_customer/utils/helper/helper_sncksbar.dart';
import 'package:yesgo_cab_customer/widget/buttons/button.dart';
import 'package:yesgo_cab_customer/widget/textwidget/text_widget.dart';

import '../../../model/CABMODELS/tripModel/trip_model.dart';

class CabSearchScreen extends StatefulWidget {
  CabSearchScreen({
    super.key,
  });

  @override
  State<CabSearchScreen> createState() => _CabSearchScreenState();
}

class _CabSearchScreenState extends State<CabSearchScreen> {
  CabController cabController = Get.put(CabController());
  HomeController homeController = Get.put(HomeController());
  @override
  void initState() {
    connectToServer();

    super.initState();
  }

  void connectToServer() {
    try {
      log('+++++++++~~~~~~~~~~~+++++++++ call connect fun  ');
      socket.connect();
      socket.onConnect((_) {
        log('++++++++++++++++++ onConnect ++++++++++++++++++++++++');
      });

      socket.on("trip-driver-accepted", (data) {
        print("emit waiting $data");
        TripDetailModel tripDetail = TripDetailModel.fromJson(data);
        cabController.tripData = tripDetail;
        Get.to(const RideAcceptedScreen());
      });

      socket.on("trip-driver-not-found", (data) {
        print("trip-driver-not-found $data");
        Get.offAll(HomeScreen());
        HelperSnackBar.snackBar("Error", "${data['message']}");
      });
      socket.onDisconnect((_) {
        log('+++++++++++++++ disconnect ++++++++++++++++++++++++');
      });
      socket.on('fromServer', (_) => log(_));
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void dispose() {
    socket.off("trip-driver-not-found");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        // appBar: HelperAppBar.appbarHelper(
        //   title: "Searching For Cab",
        // ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(PngAssetPath.lottieRipple),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: TextWidget(
                text:
                    "Please wait a moment while we search for the nearest driver based on your location.",
                textSize: 16,
                fontWeight: FontWeight.w500,
                align: TextAlign.center,
                maxLine: 3,
              ),
            )
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(12),
          child: AppButton.primaryButton(
              onButtonPressed: () {
                cabController.cancelReq(context);
              },
              title: "Cancel Request"),
        ),
      ),
    );
  }
}
