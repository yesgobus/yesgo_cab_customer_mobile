import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:yesgo_cab_customer/controller/TRANSPORT/homeController/home_controller_trans.dart';
import 'package:yesgo_cab_customer/controller/TRANSPORT/transportTripController/transport_trip_controller.dart';
import 'package:yesgo_cab_customer/model/TRANSPORTMODEL/transTripModel/trans_trip_model.dart';
import 'package:yesgo_cab_customer/screen/CAB/homeScreen/home_screen.dart';
import 'package:yesgo_cab_customer/screen/CAB/rideAcceptScreen/ride_accepted_screen.dart';
import 'package:yesgo_cab_customer/screen/TRANSPORTAPP/homeScreen/home_screen_transport.dart';
import 'package:yesgo_cab_customer/screen/TRANSPORTAPP/transRideAcceptScreen/trans_ride_accepted_screen.dart';
import 'package:yesgo_cab_customer/utils/constant/png_asset_constant.dart';
import 'package:yesgo_cab_customer/utils/helper/helper_sncksbar.dart';
import 'package:yesgo_cab_customer/widget/buttons/button.dart';
import 'package:yesgo_cab_customer/widget/textwidget/text_widget.dart';
import '../../../model/CABMODELS/tripModel/trip_model.dart';

class VehicleSearchScreen extends StatefulWidget {
  VehicleSearchScreen({
    super.key,
  });

  @override
  State<VehicleSearchScreen> createState() => _VehicleSearchScreenState();
}

class _VehicleSearchScreenState extends State<VehicleSearchScreen> {
  TransportController transportController = Get.put(TransportController());
  HomeControllerTrans homeControllerTrans = Get.put(HomeControllerTrans());
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

      socket.on("trip-driver-transport-accepted", (data) {
        print("trip-driver-transport-accepted $data");
        TransTripDetailModel transTripDetailModel= TransTripDetailModel.fromJson(data);
        transportController.transTripData = transTripDetailModel;
        Get.to(const RideAcceptedScreenTrans());
      });

      socket.on("trip-driver-transport-not-found", (data) {
        print("trip-driver-transport-not-found $data");
        Get.offAll(HomeScreenTransport());
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
    socket.off("trip-driver-transport-not-found");
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
                transportController.cancelReq(context);
              },
              title: "Cancel Request"),
        ),
      ),
    );
  }
}
