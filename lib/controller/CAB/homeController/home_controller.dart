import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_picker/map_picker.dart';

import '../../../utils/getStore/get_store.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;
  var selectedCabId = "";

  var ongoingStatus = "".obs;
  var ongoingMessage = "".obs;
  TextEditingController fromAddress = TextEditingController();
  TextEditingController toAddress = TextEditingController();
  LatLng fromLatLng = const LatLng(0, 0);
  LatLng toLatLng = const LatLng(0, 0);
  bool isAddressSelected = false;
  final MapPickerController mapPickerController = MapPickerController();
  CameraPosition cameraPosition = CameraPosition(
    target: LatLng(
        GetStoreData.getStore.read('lat'), GetStoreData.getStore.read('long')),
    zoom: 14.4746,
  );

  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
}
