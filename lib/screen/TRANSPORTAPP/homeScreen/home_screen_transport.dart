import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_picker/map_picker.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:yesgo_cab_customer/controller/TRANSPORT/homeController/home_controller_trans.dart';
import 'package:yesgo_cab_customer/controller/TRANSPORT/transportTripController/transport_trip_controller.dart';
import 'package:yesgo_cab_customer/model/TRANSPORTMODEL/transTripModel/trans_trip_model.dart';
import 'package:yesgo_cab_customer/screen/TRANSPORTAPP/homeScreen/homeWidget/address_choose_widget.dart';
import 'package:yesgo_cab_customer/screen/TRANSPORTAPP/paymentScreenTransport/trans_payment_screen.dart';
import 'package:yesgo_cab_customer/screen/TRANSPORTAPP/reciverScreen/reciver_screen.dart';
import 'package:yesgo_cab_customer/screen/TRANSPORTAPP/transRideAcceptScreen/trans_ride_accepted_screen.dart';
import 'package:yesgo_cab_customer/screen/drawerScreen/drawer_screen.dart';
import 'package:yesgo_cab_customer/widget/appbar/appbar.dart';

import '../../../utils/apiService/api_base.dart';
import '../../../utils/appcolors/app_colors.dart';
import '../../../utils/constant/app_var.dart';
import '../../../utils/getStore/get_store.dart';
import '../../../utils/helper/helper.dart';
import '../../../utils/helper/helper_sncksbar.dart';
import '../../../widget/buttons/button.dart';
import '../../CAB/homeScreen/home_screen.dart';

class HomeScreenTransport extends StatefulWidget {
  const HomeScreenTransport({super.key});

  @override
  State<HomeScreenTransport> createState() => _HomeScreenTransportState();
}

class _HomeScreenTransportState extends State<HomeScreenTransport> {
  HomeControllerTrans homeControllerTrans = Get.put(HomeControllerTrans());
  TransportController transportController = Get.put(TransportController());

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  @override
  void initState() {
    // connectToServer();
    super.initState();
  }

  void connectToServer() {
    try {
      socket.connect();
      socket.onError((data) => log("message $data"));
      socket.onConnect((_) {
        log('++++++++++++++++++ onConnect ++++++++++++++++++++++++');
      });


      socket.onDisconnect((_) {
        log('+++++++++++++++ disconnect ++++++++++++++++++++++++');
      });
      socket.on('fromServer', (_) => log(_));
    } catch (e) {
      log("><><><" + e.toString());
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const DrawerWidget(),
        appBar:
            HelperAppBar.appbarHelper(title: "YesGo Transport", hideBack: true),
        body: Obx(
          () => homeControllerTrans.isLoading.value
              ? Helper.pageLoading()
              : Stack(
                  children: [
                    MapPicker(
                      mapPickerController: homeControllerTrans.mapPickerController,
                      iconWidget: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: AppColors.primaryColor.withOpacity(0.7),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: AppColors.primaryColor,
                              ),
                              child: const Icon(
                                Icons.circle,
                                size: 12,
                                color: AppColors.whiteColor,
                              ),
                            ),
                          ),
                          Container(
                            height: 22,
                            width: 2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColors.blackColor,
                            ),
                          ),
                        ],
                      ),
                      child: GoogleMap(
                        mapType: MapType.normal,
                        zoomControlsEnabled: false,
                        zoomGesturesEnabled: true,
                        initialCameraPosition: homeControllerTrans.cameraPosition,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                        onCameraMove: (cameraPosition) {
                          homeControllerTrans.cameraPosition = cameraPosition;
                        },
                        onCameraMoveStarted: () {
                          homeControllerTrans.mapPickerController.mapMoving!();
                        },
                        onCameraIdle: () async {
                          homeControllerTrans.isAddressSelected = true;
                          homeControllerTrans
                              .mapPickerController.mapFinishedMoving!();
                          var response = await ApiBase.getRequestGoogle(
                              extendedURL:
                                  'https://maps.googleapis.com/maps/api/geocode/json?latlng=${homeControllerTrans.cameraPosition.target.latitude},${homeControllerTrans.cameraPosition.target.longitude}&key=${googleAPIKey}');

                          var data = jsonDecode(response.body.toString());
                          String getAddress = data['results'][0]
                                  ['formatted_address']
                              .toString();
                          homeControllerTrans.fromAddress.text = getAddress;
                          homeControllerTrans.fromLatLng = LatLng(
                              homeControllerTrans.cameraPosition.target.latitude,
                              homeControllerTrans.cameraPosition.target.longitude);
                          setState(() {});
                        },
                      ),
                    ),
                    const AddressChooseWidgetTrans(),
                    Positioned(
                      bottom: 12,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: AppButton.primaryButton(
                            width: Get.width - 24,
                            onButtonPressed: () {
                              if (homeControllerTrans.fromLatLng.latitude != 0 &&
                                  homeControllerTrans.toLatLng.latitude != 0) {
                                Get.to(() => const ReciverScreen());
                              } else {
                                HelperSnackBar.snackBar(
                                    "Error", "Choose From & To Address");
                              }
                            },
                            title: "Continue"),
                      ),
                    ),
                  ],
                ),
        ));
  }
}
