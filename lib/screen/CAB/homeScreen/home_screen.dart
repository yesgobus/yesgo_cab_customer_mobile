import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yesgo_cab_customer/controller/CAB/cabTripController/cab_trip_controller.dart';
import 'package:yesgo_cab_customer/screen/CAB/cabSelectScreen/cab_select_screen.dart';
import 'package:yesgo_cab_customer/screen/CAB/paymentScreen/payment_screen.dart';
import 'package:yesgo_cab_customer/screen/drawerScreen/drawer_screen.dart';
import 'package:yesgo_cab_customer/screen/CAB/homeScreen/homeWidget/address_choose_widget.dart';
import 'package:yesgo_cab_customer/utils/constant/app_var.dart';
import 'package:yesgo_cab_customer/utils/getStore/get_store.dart';
import 'package:yesgo_cab_customer/utils/helper/helper.dart';
import 'package:yesgo_cab_customer/utils/helper/helper_sncksbar.dart';
import 'package:yesgo_cab_customer/widget/appbar/appbar.dart';
import 'package:map_picker/map_picker.dart';
import 'package:yesgo_cab_customer/widget/buttons/button.dart';
import '../../../controller/CAB/homeController/home_controller.dart';
import '../../../controller/TRANSPORT/homeController/home_controller_trans.dart';
import '../../../controller/TRANSPORT/transportTripController/transport_trip_controller.dart';
import '../../../model/CABMODELS/tripModel/trip_model.dart';
import '../../../model/TRANSPORTMODEL/transTripModel/trans_trip_model.dart';
import '../../../utils/apiService/api_base.dart';
import '../../../utils/appcolors/app_colors.dart';
import 'package:socket_io_client/socket_io_client.dart' as client;

import '../../TRANSPORTAPP/paymentScreenTransport/trans_payment_screen.dart';
import '../../TRANSPORTAPP/transRideAcceptScreen/trans_ride_accepted_screen.dart';
import '../rideAcceptScreen/ride_accepted_screen.dart';

client.Socket socket = client.io(
  'http://ec2-13-127-219-49.ap-south-1.compute.amazonaws.com:8000',
  <String, dynamic>{
    'transports': ['websocket'],
    "autoConnect": true
  },
);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.put(HomeController());
  CabController cabController = Get.put(CabController());

  HomeControllerTrans homeControllerTrans = Get.put(HomeControllerTrans());
  TransportController transportController = Get.put(TransportController());
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  @override
  void initState() {
    connectToServer();
    super.initState();
  }

  void connectToServer() {
    try {
      socket.connect();
      socket.onError((data) => log("message $data"));
      socket.onConnect((_) {
        log('++++++++++++++++++ onConnect ++++++++++++++++++++++++');
        socket.emit('register-customer', GetStoreData.getStore.read('id'));
      });

      socket.on("pickup-status", (data) async {
        log("pickup-status + $data");
        homeController.ongoingStatus.value = data['status'];
        homeController.ongoingMessage.value = data['message'];
        if (homeController.ongoingStatus.value == 'completed') {
          cabController.isLoading.value = true;
          Get.to(() => const PaymentScreen());
        }
      });
      socket.on("restart-ride-status", (data) async {
        log("ride-request + $data");
        TripDetailModel tripDetail = TripDetailModel.fromJson(data);
        cabController.tripData = tripDetail;
        homeController.ongoingStatus.value = cabController.tripData!.status!;
        homeController.ongoingMessage.value =
            cabController.tripData!.statusMessage!;
        cabController.rideId = cabController.tripData!.rideId!;
        Get.to(const RideAcceptedScreen());
      });

      //transport
      socket.on("pickup-transport-status", (data) async {
        log("pickup-transport-status + $data");
        homeControllerTrans.ongoingStatus.value = data['status'];
        homeControllerTrans.ongoingMessage.value = data['message'];
        if (homeControllerTrans.ongoingStatus.value == 'completed') {
          transportController.isLoading.value = true;
          Get.to(() => const PaymentScreenTrans());
        }
      });
      socket.on("restart-transport-ride-status", (data) async {
        log("restart-transport-ride-status + $data");
        TransTripDetailModel transTripDetail =
            TransTripDetailModel.fromJson(data);
        transportController.transTripData = transTripDetail;
        homeControllerTrans.ongoingStatus.value =
            transportController.transTripData!.status!;
        homeControllerTrans.ongoingMessage.value =
            transportController.transTripData!.statusMessage!;
        transportController.transportRideId =
            transportController.transTripData!.rideId!;
        Get.to(const RideAcceptedScreenTrans());
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
        // floatingActionButton: FloatingActionButton(onPressed: () {
        //   Get.to(PaymentScreen());
        // }),
        drawer: const DrawerWidget(),
        appBar: HelperAppBar.appbarHelper(title: "YesGo Cab", hideBack: true),
        body: Obx(
          () => homeController.isLoading.value
              ? Helper.pageLoading()
              : Stack(
                  children: [
                    MapPicker(
                      mapPickerController: homeController.mapPickerController,
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
                              child: Icon(
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
                        initialCameraPosition: homeController.cameraPosition,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                        onCameraMove: (cameraPosition) {
                          homeController.cameraPosition = cameraPosition;
                        },
                        onCameraMoveStarted: () {
                          homeController.mapPickerController.mapMoving!();
                        },
                        onCameraIdle: () async {
                          homeController.isAddressSelected = true;
                          homeController
                              .mapPickerController.mapFinishedMoving!();
                          var response = await ApiBase.getRequestGoogle(
                              extendedURL:
                                  'https://maps.googleapis.com/maps/api/geocode/json?latlng=${homeController.cameraPosition.target.latitude},${homeController.cameraPosition.target.longitude}&key=${googleAPIKey}');

                          var data = jsonDecode(response.body.toString());
                          String getAddress = data['results'][0]
                                  ['formatted_address']
                              .toString();
                          homeController.fromAddress.text = getAddress;
                          homeController.fromLatLng = LatLng(
                              homeController.cameraPosition.target.latitude,
                              homeController.cameraPosition.target.longitude);
                          setState(() {});
                        },
                      ),
                    ),
                    const AddressChooseWidget(),
                    Positioned(
                      bottom: 12,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: AppButton.primaryButton(
                            width: Get.width - 24,
                            onButtonPressed: () {
                              if (homeController.fromLatLng.latitude != 0 &&
                                  homeController.toLatLng.latitude != 0) {
                                Get.to(() => const CabSelectScreen());
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
