import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yesgo_cab_customer/controller/TRANSPORT/homeController/home_controller_trans.dart';
import 'package:yesgo_cab_customer/model/TRANSPORTMODEL/goodsCategoryModel.dart/goods_cat_model.dart';
import 'package:yesgo_cab_customer/screen/TRANSPORTAPP/TransportDetail&Info/transportdetail_info_screen.dart';
import 'package:yesgo_cab_customer/screen/TRANSPORTAPP/homeScreen/home_screen_transport.dart';

import '../../../model/CABMODELS/completeTripModel/complete_trip_model.dart';
import '../../../model/TRANSPORTMODEL/transTripModel/trans_trip_model.dart';
import '../../../model/TRANSPORTMODEL/transportListModel/transport_list_model.dart';
import '../../../model/TRANSPORTMODEL/vehicleDetailsModel/vehicle_details_moedl.dart';
import '../../../screen/TRANSPORTAPP/vehicleSearchScreen/vehicle_search_screen.dart';
import '../../../utils/apiService/api_base.dart';
import '../../../utils/apiService/api_url.dart';
import '../../../utils/getStore/get_store.dart';
import '../../../utils/helper/helper.dart';
import '../../../utils/helper/helper_sncksbar.dart';

class TransportController extends GetxController {
  RxBool isLoading = false.obs;
  HomeControllerTrans homeControllerTrans = Get.put(HomeControllerTrans());
  List<TransportVehicle> vehicleList = [];

  List<int> selectedGoodsCatID = [];
  List<String> selectedGoodsCatName = [];

  Future getVehicleList() async {
    try {
      isLoading.value = true;
      vehicleList.clear();
      var response = await ApiBase.getRequest(
          extendedURL:
              "${ApiUrl.transportListUrl}${"startLat=${homeControllerTrans.fromLatLng.latitude}&startLng=${homeControllerTrans.fromLatLng.longitude}&endLat=${homeControllerTrans.toLatLng.latitude}&endLng=${homeControllerTrans.toLatLng.longitude}"}");
      log(response.body);
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        VehicleListModel cabListModel = VehicleListModel.fromJson(data);
        vehicleList.addAll(cabListModel.data!.transportVehicles!);
        homeControllerTrans.selectedVehicleId = vehicleList.first.id.toString();
      }
    } catch (e) {
      log("getCabList $e");
    } finally {
      isLoading.value = false;
    }
  }

  VehicleDetailData? vehicleDetailData;
  Future getVehicleDetails(String id) async {
    try {
      isLoading.value = true;
      var response = await ApiBase.postRequest(body: {
        'start_lat': homeControllerTrans.fromLatLng.latitude,
        'start_lng': homeControllerTrans.fromLatLng.longitude,
        'end_lat': homeControllerTrans.toLatLng.latitude,
        "end_lng": homeControllerTrans.toLatLng.longitude,
        'vehicle_id': id
      }, extendedURL: ApiUrl.transportDetailsUrl, withToken: true);
      log(response.body);
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        VehicleDetailsModel vehicleDetailsModel =
            VehicleDetailsModel.fromJson(data);
        vehicleDetailData = vehicleDetailsModel.data!;
        Get.to(() => const TransportDetailInfoScreen());
      }
    } catch (e) {
      log("getVehicleDetail $e");
    } finally {
      isLoading.value = false;
    }
  }

  List<GoodsCatList> goodsCatList = [];
  Future getGoodsListDetails() async {
    try {
      isLoading.value = true;
      goodsCatList.clear();
      var response = await ApiBase.getRequest(
          extendedURL: ApiUrl.goodsCategoryListUrl +
              homeControllerTrans.selectedVehicleId);
      log(response.body);
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        GoodsCategoryListModel goodsCategoryListModel =
            GoodsCategoryListModel.fromJson(data);
        goodsCatList.addAll(goodsCategoryListModel.data!);
      }
    } catch (e) {
      log("getVehicleDetail $e");
    } finally {
      isLoading.value = false;
    }
  }

  TextEditingController receiverNameController = TextEditingController();
  TextEditingController receiverPhoneController = TextEditingController();
  String transportType = "Local";
  String transportRideId = "";
  Future bookkingReq({required context, required cabId}) async {
    Helper.loader(context);
    var body = {
      "vehicle_id": cabId,
      "pickup_address": homeControllerTrans.fromAddress.text,
      "pickup_lat": homeControllerTrans.fromLatLng.latitude,
      "pickup_lng": homeControllerTrans.fromLatLng.longitude,
      "drop_address": homeControllerTrans.toAddress.text,
      "drop_lat": homeControllerTrans.toLatLng.latitude,
      "drop_lng": homeControllerTrans.toLatLng.longitude,
      'reciever_name': receiverNameController.text,
      'reciever_mobileNumber': receiverPhoneController.text,
      'transport_type': transportType.toLowerCase(),
      'goods_type': selectedGoodsCatID,
    };
    var response = await ApiBase.postRequest(
        body: body, extendedURL: ApiUrl.transportRideReqUrl, withToken: true);
    log(response.body);
    var data = json.decode(response.body);
    if (data["status"] == true) {
      Get.back();
      transportRideId = data['data']['ride_id'];
      Get.to(VehicleSearchScreen());
    } else {
      Get.back();
      HelperSnackBar.snackBar("Error", data['message']);
    }
  }

  TransTripDetailModel? transTripData;
  Future cancelReq(context) async {
    Helper.loader(context);
    var body = {
      "ride_id": transportRideId,
    };
    var response = await ApiBase.postRequest(
        body: body, extendedURL: ApiUrl.transportCancelUrl, withToken: true);
    log(response.body);
    var data = json.decode(response.body);
    if (data["status"] == true) {
      Get.offAll(const HomeScreenTransport());
      HelperSnackBar.snackBar("Success", data['message']);
    } else {
      Get.back();
      HelperSnackBar.snackBar("Error", data['message']);
    }
  }

  TripComplete tripComplete = TripComplete();
  Future postCompleteRide() async {
    try {
      isLoading.value = true;
      var body = {'ride_id': transportRideId};
      var response = await ApiBase.postRequest(
          body: body,
          extendedURL: ApiUrl.transportRideCompleteUrl,
          withToken: true);
      log(response.body);
      var data = json.decode(response.body);
      if (data["status"] == true) {
        CompleteTripModel completeTripModel = CompleteTripModel.fromJson(data);
        tripComplete = completeTripModel.data!;
        homeControllerTrans.ongoingMessage.value = "";
        homeControllerTrans.ongoingStatus.value = "";
      } else {
        HelperSnackBar.snackBar("Error", data["message"]);
      }
    } catch (e) {
      log("complete ride $e ");
    } finally {
      isLoading.value = false;
    }
  }
}
