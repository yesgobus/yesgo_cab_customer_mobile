// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:yesgo_cab_customer/controller/CAB/cabTripController/cab_trip_controller.dart';
import 'package:yesgo_cab_customer/controller/CAB/homeController/home_controller.dart';
import 'package:yesgo_cab_customer/screen/CAB/cabDetail&Info/cabdetail_info_screen.dart';
import 'package:yesgo_cab_customer/utils/constant/png_asset_constant.dart';
import 'package:yesgo_cab_customer/utils/helper/helper.dart';
import 'package:yesgo_cab_customer/widget/buttons/button.dart';
import 'package:yesgo_cab_customer/widget/textwidget/text_widget.dart';

import '../../../utils/appcolors/app_colors.dart';
import '../../../utils/constant/app_var.dart';
import '../../../utils/getStore/get_store.dart';
import '../../../utils/locationService/location_service.dart';
import 'dart:math' show atan2, cos, pi, sin;

class CabSelectScreen extends StatefulWidget {
  const CabSelectScreen({super.key});

  @override
  State<CabSelectScreen> createState() => _CabSelectScreenState();
}

class _CabSelectScreenState extends State<CabSelectScreen> {
  HomeController homeController = Get.find();
  CabController cabListingController = Get.put(CabController());
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
          CameraPosition(target: homeController.fromLatLng, zoom: 14);
      cabListingController.getCabList();
      _createPolylines();

      // _loadCabIcon();
      // _moveCabAlongPolyline();
    });

    super.initState();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  StreamSubscription<Position>? _positionStreamSubscription;
  late BitmapDescriptor _cabIcon;
  late Marker _cabMarker;
  LatLng _currentPosition = const LatLng(37.4219999, -122.0840575);
  Future<void> _loadCabIcon() async {
    _cabIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      PngAssetPath.car1Img,
    );
    _cabMarker = Marker(
      markerId: const MarkerId('cab'),
      position: _currentPosition,
      icon: _cabIcon,
    );
    _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
    )).listen((Position position) {
      _currentPosition = LatLng(position.latitude, position.longitude);

      double bearing = _calculateBearing(
          _polylineCoordinates.first, _polylineCoordinates[1]);
      _cabMarker = _cabMarker.copyWith(
        positionParam: _currentPosition,
        rotationParam: bearing,
      );

      _markers.add(_cabMarker);
      setState(() {});
      _moveCamera(_currentPosition);
    });
  }

  double _calculateBearing(LatLng start, LatLng end) {
    final double lat1 = start.latitude * (3.141592653589793 / 180.0);
    final double lon1 = start.longitude * (3.141592653589793 / 180.0);
    final double lat2 = end.latitude * (3.141592653589793 / 180.0);
    final double lon2 = end.longitude * (3.141592653589793 / 180.0);

    final double dLon = (lon2 - lon1);
    final double y = sin(dLon) * cos(lat2);
    final double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    final double brng = atan2(y, x) * (180.0 / 3.141592653589793);
    return (brng + 360.0) % 360.0;
  }

  void _moveCabAlongPolyline() {
    int index = 0;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (index < _polylineCoordinates.length - 1) {
        LatLng newPosition = _polylineCoordinates[index];
        LatLng nextPosition = _polylineCoordinates[index + 1];
        double bearing = _calculateBearing(newPosition, nextPosition);

        setState(() {
          _cabMarker = _cabMarker.copyWith(
            positionParam: newPosition,
            rotationParam: bearing,
          );
        });

        index++;
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _moveCamera(LatLng position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: position,
      zoom: 13.0,
    )));
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
                                      text: homeController.fromAddress.text,
                                      textSize: 14,
                                      fontWeight: FontWeight.w500,
                                      maxLine: 3,
                                    ),
                                    const Divider(
                                      thickness: 0.8,
                                    ),
                                    TextWidget(
                                      text: homeController.toAddress.text,
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
                          const SizedBox(height: 8),
                          Obx(() => cabListingController.isLoading.value
                              ? Expanded(
                                  child: Center(
                                  child: Helper.pageLoading(),
                                ))
                              : Expanded(
                                  child: cabListingController.cabList.isEmpty
                                      ? const Center(
                                          child: TextWidget(
                                              text:
                                                  "Currently, no cabs are available\nat your location",
                                              align: TextAlign.center,
                                              textSize: 16),
                                        )
                                      : ListView.builder(
                                          itemCount: cabListingController
                                              .cabList.length,
                                          padding:
                                              const EdgeInsets.only(bottom: 8),
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: selectedCab == index
                                                        ? AppColors.primaryColor
                                                        : AppColors
                                                            .transparentColor,
                                                    width: selectedCab == index
                                                        ? 2
                                                        : 0),
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              child: ListTile(
                                                onTap: () {
                                                  selectedCab = index;
                                                  homeController.selectedCabId =
                                                      cabListingController
                                                          .cabList[index].id
                                                          .toString();
                                                  setState(() {});
                                                },
                                                dense: true,
                                                leading: Image.network(
                                                  cabListingController
                                                      .cabList[index].imageUrl!,
                                                  width: 65,
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                title: TextWidget(
                                                    text:
                                                        "${cabListingController.cabList[index].carType}",
                                                    textSize: 15),
                                                subtitle: TextWidget(
                                                    text:
                                                        "${cabListingController.cabList[index].tagline}",
                                                    textSize: 10),
                                                trailing: TextWidget(
                                                  text:
                                                      "${cabListingController.cabList[index].fareAmountDisplay}",
                                                  textSize: 16,
                                                  fontWeight:
                                                      FontWeight.w500,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                )),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: AppButton.primaryButton(
                                onButtonPressed: () {
                                  if (cabListingController.cabList.isNotEmpty) {
      cabListingController.getCabDetails(homeController.selectedCabId);

                                  }
                                },
                                title: "Book Now"),
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

  final Set<Polyline> _polylines = {};
  final List<LatLng> _polylineCoordinates = [];

  PolylinePoints polylinePoints = PolylinePoints();
  PolylineResult result = PolylineResult();
  _createPolylines() async {
    try {
      result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPIKey,
        PointLatLng(homeController.fromLatLng.latitude,
            homeController.fromLatLng.longitude),
        PointLatLng(homeController.toLatLng.latitude,
            homeController.toLatLng.longitude),
        travelMode: TravelMode.transit,
      );

      // log("message${result.points}");
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
        position: homeController.fromLatLng,
        icon: customMarker,
        infoWindow: InfoWindow(
          title: 'From',
          snippet: result.startAddress,
        ),
      ),
      Marker(
        markerId: const MarkerId('to'),
        position: homeController.toLatLng,
        icon: customMarker2,
        infoWindow: InfoWindow(
          title: '${result.distance} - ${result.duration}',
          snippet: result.endAddress,
        ),
      ),
    });
    List<LatLng> positions = [
      homeController.fromLatLng,
      homeController.toLatLng,
    ];

    var bounds = boundsFromLatLngList(positions);
    CameraUpdate u2 = CameraUpdate.newLatLngBounds(bounds, 120);
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(u2);
    setState(() {});
  }

  final DraggableScrollableController _c = DraggableScrollableController();
  int selectedCab = 0;
}
