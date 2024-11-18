import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yesgo_cab_customer/controller/TRANSPORT/homeController/home_controller_trans.dart';
import 'package:yesgo_cab_customer/controller/TRANSPORT/transportTripController/transport_trip_controller.dart';
import 'package:yesgo_cab_customer/screen/CAB/homeScreen/home_screen.dart';
import 'package:yesgo_cab_customer/widget/buttons/button.dart';
import 'package:yesgo_cab_customer/widget/textwidget/text_widget.dart';

import '../../../controller/CAB/cabTripController/cab_trip_controller.dart';
import '../../../controller/CAB/homeController/home_controller.dart';
import '../../../utils/appcolors/app_colors.dart';
import '../../../utils/constant/app_var.dart';
import '../../../utils/constant/png_asset_constant.dart';
import '../../../utils/getStore/get_store.dart';
import '../../../utils/locationService/location_service.dart';

class RideAcceptedScreenTrans extends StatefulWidget {
  const RideAcceptedScreenTrans({super.key});

  @override
  State<RideAcceptedScreenTrans> createState() => _RideAcceptedScreenTransState();
}

class _RideAcceptedScreenTransState extends State<RideAcceptedScreenTrans> {
  HomeControllerTrans homeControllerTrans = Get.find();
  CameraPosition cameraPosition = CameraPosition(
    target: LatLng(
        GetStoreData.getStore.read('lat'), GetStoreData.getStore.read('long')),
    zoom: 14.4746,
  );
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  TransportController transportController = Get.find();

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      cameraPosition =
          CameraPosition(target: homeControllerTrans.fromLatLng, zoom: 14);
      _createPolylines();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Obx(() => Scaffold(
            body: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: cameraPosition,
                  polylines: _polylines,
                  zoomControlsEnabled: false,
                  compassEnabled: false,
                  markers: _markers,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: Get.width,
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12))),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            TextWidget(
                                text: "Driver Details",
                                textSize: 14,
                                fontWeight: FontWeight.w500),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                  transportController.transTripData!.driverImage!),
                              backgroundColor: AppColors.primaryColor,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  text: "${transportController.transTripData!.driverName}",
                                  textSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryColor,
                                ),
                                const SizedBox(height: 6),
                                TextWidget(
                                  text:
                                      "${transportController.transTripData!.pickupDistance} - ${transportController.transTripData!.pickupDuration} Away",
                                  textSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                            const Expanded(child: SizedBox()),
                            TextWidget(
                              text: "${transportController.transTripData!.tripAmount}",
                              textSize: 18,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryColor,
                            ),
                          ],
                        ),
                        sizedTextfield,
                        Container(
                          width: Get.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                              color: AppColors.grey1Color,
                              border: Border.all(color: AppColors.grey5Color),
                              borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 8,
                                    backgroundColor: AppColors.grey3Color,
                                    child: const CircleAvatar(
                                      backgroundColor: AppColors.greenColor,
                                      radius: 5,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const TextWidget(
                                          text: "Pickup From",
                                          textSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        const SizedBox(height: 4),
                                        TextWidget(
                                            text:
                                                "${transportController.transTripData!.pickupAddress}",
                                            textSize: 12,
                                            maxLine: 2,
                                            fontWeight: FontWeight.w500),
                                        const SizedBox(height: 4),
                                        TextWidget(
                                          text:
                                              "${transportController.transTripData!.pickupDistance} - ${transportController.transTripData!.pickupDuration} Away",
                                          textSize: 12,
                                          fontWeight: FontWeight.w500,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const Divider(height: 22),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 8,
                                    backgroundColor: AppColors.grey3Color,
                                    child: CircleAvatar(
                                      backgroundColor: AppColors.redColor,
                                      radius: 5,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const TextWidget(
                                          text: "Drop From",
                                          textSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        const SizedBox(height: 4),
                                        TextWidget(
                                            text:
                                                "${transportController.transTripData!.dropAddress}",
                                            textSize: 12,
                                            maxLine: 2,
                                            fontWeight: FontWeight.w500),
                                        const SizedBox(height: 4),
                                        TextWidget(
                                          text:
                                              "${transportController.transTripData!.tripDistance} - ${transportController.transTripData!.tripDuration} Away",
                                          textSize: 12,
                                          fontWeight: FontWeight.w500,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (homeControllerTrans.ongoingStatus.value != 'Ongoing' &&
                            homeControllerTrans.ongoingStatus.value != 'completed')
                          Column(
                            children: [
                              const TextWidget(
                                  text: "Send This OTP To Driver",
                                  textSize: 15,
                                  fontWeight: FontWeight.w500),
                              const SizedBox(height: 5),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                      transportController.transTripData!.otp!.length,
                                      (index) {
                                    List<String> otp =
                                        transportController.transTripData!.otp!.split('');

                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 8),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.black45),
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: TextWidget(
                                          text: otp[index], textSize: 18),
                                    );
                                  })),
                              TextWidget(
                                text:
                                    "Driver May Arrive By ${transportController.transTripData!.pickupTime}",
                                textSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                            ],
                          ),
                        if (homeControllerTrans.ongoingMessage.value.isNotEmpty)
                          const SizedBox(height: 12),
                        TextWidget(
                            text: homeControllerTrans.ongoingMessage.value,
                            textSize: 16,
                            maxLine: 3,
                            fontWeight: FontWeight.w500),
                        if (homeControllerTrans.ongoingMessage.value.isNotEmpty)
                          const SizedBox(height: 12),
                        if (homeControllerTrans.ongoingStatus.value != "PickingUp" &&
                            homeControllerTrans.ongoingStatus.value != 'Ongoing' &&
                            homeControllerTrans.ongoingStatus.value != 'completed')
                          AppButton.primaryButton(
                              height: 40,
                              onButtonPressed: () {
                                transportController.cancelReq(context);
                              },
                              title: "Cancel Ride"),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  final Set<Polyline> _polylines = {};
  final List<LatLng> _polylineCoordinates = [];

  PolylinePoints polylinePoints = PolylinePoints();
  PolylineResult result = PolylineResult();
  _createPolylines() async {
    try {
      result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPIKey,
        PointLatLng(homeControllerTrans.fromLatLng.latitude,
            homeControllerTrans.fromLatLng.longitude),
        PointLatLng(homeControllerTrans.toLatLng.latitude,
            homeControllerTrans.toLatLng.longitude),
        travelMode: TravelMode.transit,
      );

      log("message${result.points}");
      result.points.forEach((PointLatLng point) {
        _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      _polylines.add(Polyline(
        polylineId: const PolylineId('poly'),
        visible: true,
        points: _polylineCoordinates,
        width: 4,
        color: AppColors.primaryColor,
      ));
      _setCustomMarker();

      setState(() {});
    } catch (e) {
      log("message$e");
    }
  }

  // late BitmapDescriptor customIcon;
  final Set<Marker> _markers = {};

  void _setCustomMarker() async {
    final BitmapDescriptor customMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(45, 45)), PngAssetPath.pinGreenImg,
        mipmaps: true);
    final BitmapDescriptor customMarker2 =
        await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(20, 20)),
            PngAssetPath.pinRedImg,
            mipmaps: true);

    _markers.addAll({
      Marker(
        markerId: const MarkerId('from'),
        position: homeControllerTrans.fromLatLng,
        icon: customMarker,
        // infoWindow: InfoWindow(
        //   title: 'From',
        //   snippet: result.distanceText,
        // ),
      ),
      Marker(
        markerId: const MarkerId('to'),
        position: homeControllerTrans.toLatLng,
        icon: customMarker2,
        // infoWindow: InfoWindow(
        //   title: '${result.distance} - ${result.duration}',
        //   snippet: result.endAddress,
        // ),
      ),
    });
    List<LatLng> positions = [
      homeControllerTrans.fromLatLng,
      homeControllerTrans.toLatLng,
    ];

    var bounds = boundsFromLatLngList(positions);
    CameraUpdate u2 = CameraUpdate.newLatLngBounds(bounds, 120);
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(u2);
    setState(() {});
  }
}
