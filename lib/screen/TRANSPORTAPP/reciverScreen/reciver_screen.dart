import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yesgo_cab_customer/controller/TRANSPORT/homeController/home_controller_trans.dart';
import 'package:yesgo_cab_customer/controller/TRANSPORT/transportTripController/transport_trip_controller.dart';
import 'package:yesgo_cab_customer/utils/helper/helper.dart';
import 'package:yesgo_cab_customer/widget/text_field/text_field.dart';

import '../../../utils/appcolors/app_colors.dart';
import '../../../utils/constant/app_var.dart';
import '../../../utils/constant/png_asset_constant.dart';
import '../../../utils/getStore/get_store.dart';
import '../../../utils/locationService/location_service.dart';
import '../../../widget/buttons/button.dart';
import '../../../widget/textwidget/text_widget.dart';
import '../TransportDetail&Info/transportdetail_info_screen.dart';

class ReciverScreen extends StatefulWidget {
  const ReciverScreen({super.key});

  @override
  State<ReciverScreen> createState() => _ReciverStateScreen();
}

class _ReciverStateScreen extends State<ReciverScreen> {
  HomeControllerTrans homeControllerTrans = Get.find();
  TransportController transportController = Get.put(TransportController());
  CameraPosition cameraPosition = CameraPosition(
    target: LatLng(
        GetStoreData.getStore.read('lat'), GetStoreData.getStore.read('long')),
    zoom: 14.4746,
  );
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      cameraPosition =
          CameraPosition(target: homeControllerTrans.fromLatLng, zoom: 14);
      transportController.getVehicleList();
      _createPolylines();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: Get.height - 100,
            child: GoogleMap(
              initialCameraPosition: cameraPosition,
              polylines: _polylines,
              zoomControlsEnabled: false,
              compassEnabled: false,
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 36),
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.whiteColor,
                child: Icon(Icons.arrow_back),
              ),
            ),
          ),
          DraggableScrollableSheet(
              initialChildSize: 0.57,
              maxChildSize: 0.57,
              minChildSize: 0.30,
              controller: _c,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Container(
                      height: 430,
                      color: AppColors.whiteColor,
                      padding: const EdgeInsets.only(top: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 12),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                        radius: 6,
                                        backgroundColor:
                                            AppColors.darkGreenColor),
                                    Container(
                                        height: 32,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        width: 1,
                                        color: AppColors.blackColor),
                                    CircleAvatar(
                                        radius: 6,
                                        backgroundColor: AppColors.redColor),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      text:
                                          homeControllerTrans.fromAddress.text,
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
                          const Divider(height: 25, thickness: 1.5),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: TextWidget(
                              text: "Recommended for you",
                              textSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          isReciverInfoFill == false
                              ? receiverAddress()
                              : cabChooseList(),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: AppButton.primaryButton(
                                onButtonPressed: () {
                                  if (isReciverInfoFill) {
                                    transportController.getVehicleDetails(
                                        homeControllerTrans.selectedVehicleId);
                                  } else if (formkey.currentState!.validate()) {
                                    isReciverInfoFill = true;
                                    setState(() {});
                                  }
                                },
                                title: isReciverInfoFill
                                    ? "Book Now"
                                    : "Choose Vehicle"),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }

  GlobalKey<FormState> formkey = GlobalKey();

  bool isReciverInfoFill = false;
  cabChooseList() {
    return Obx(() => Expanded(
          child: transportController.isLoading.value
              ? Helper.pageLoading()
              : transportController.vehicleList.isEmpty
                  ? const Center(
                      child: TextWidget(
                          text:
                              "Currently, no cabs are available\nat your location",
                          align: TextAlign.center,
                          textSize: 16),
                    )
                  : ListView.builder(
                      itemCount: transportController.vehicleList.length,
                      padding: const EdgeInsets.only(bottom: 8, top: 8),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: selectedVehicle == index
                                    ? AppColors.primaryColor
                                    : AppColors.transparentColor,
                                width: selectedVehicle == index ? 2 : 0),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ListTile(
                            onTap: () {
                              selectedVehicle = index;
                              homeControllerTrans.selectedVehicleId =
                                  transportController.vehicleList[index].id
                                      .toString();
                              setState(() {});
                            },
                            dense: true,
                            leading: Image.network(
                              transportController.vehicleList[index].imageUrl!,
                              fit: BoxFit.cover,
                              width: 65,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            title: TextWidget(
                                text:
                                    "${transportController.vehicleList[index].transportModel}",
                                textSize: 15),
                            subtitle: TextWidget(
                                text:
                                    "${transportController.vehicleList[index].capacityInfo}",
                                textSize: 10),
                            trailing: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextWidget(
                                  text:
                                      "${transportController.vehicleList[index].fare}",
                                  textSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                SizedBox(height: 2),
                                TextWidget(
                                  text:
                                      "${transportController.vehicleList[index].ratePerKm}/km",
                                  textSize: 12,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ));
  }

  receiverAddress() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyCustomTextField.textField(
                      hintText: "Receiver Name",
                      valText: "Please Enter Receiver Name",
                      controller: transportController.receiverNameController),
                  sizedTextfield,
                  MyCustomTextField.textFieldPhone(
                      hintText: "Receiver Phone",
                      valText: "Please Enter Receiver Phone",
                      controller: transportController.receiverPhoneController),
                  const SizedBox(height: 12),
                  const TextWidget(
                    text: "Transport Type",
                    textSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: RadioListTile(
                            value: "Local",
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            groupValue: transportController.transportType,
                            contentPadding: const EdgeInsets.all(0),
                            title:
                                const TextWidget(text: "Local", textSize: 14),
                            onChanged: (val) {
                              transportController.transportType = val!;
                              setState(() {});
                            }),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 150,
                        child: RadioListTile(
                            value: "Outstation",
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            groupValue: transportController.transportType,
                            contentPadding: const EdgeInsets.all(0),
                            title: const TextWidget(
                                text: "Outstation", textSize: 14),
                            onChanged: (val) {
                          transportController.    transportType = val!;
                              setState(() {});
                            }),
                      ),
                    ],
                  )
                ],
              )),
        ),
      ),
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
        infoWindow: InfoWindow(
          title: 'From',
          snippet: result.distanceText,
        ),
      ),
      Marker(
        markerId: const MarkerId('to'),
        position: homeControllerTrans.toLatLng,
        icon: customMarker2,
        infoWindow: InfoWindow(
          title: '${result.distance} - ${result.duration}',
          snippet: result.endAddress,
        ),
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

  final DraggableScrollableController _c = DraggableScrollableController();
  int selectedVehicle = 0;
}
