import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:yesgo_cab_customer/controller/CAB/homeController/home_controller.dart';
import 'package:yesgo_cab_customer/utils/getStore/get_store.dart';
import 'package:yesgo_cab_customer/utils/helper/helper_sncksbar.dart';

import '../../../model/CABMODELS/bookingModel/booking_model.dart';
import '../../../model/CABMODELS/cabDetailsModel/cab_details_moedl.dart';
import '../../../model/CABMODELS/cabListModel/cab_list_model.dart';
import '../../../model/CABMODELS/completeTripModel/complete_trip_model.dart';
import '../../../model/CABMODELS/tripModel/trip_model.dart';
import '../../../screen/CAB/cabDetail&Info/cabdetail_info_screen.dart';
import '../../../screen/CAB/homeScreen/home_screen.dart';
import '../../../screen/CAB/cabSearchScreen/cab_search_screen.dart';
import '../../../utils/apiService/api_base.dart';
import '../../../utils/apiService/api_url.dart';
import '../../../utils/helper/helper.dart';

class CabController extends GetxController {
  RxBool isLoading = false.obs;
  HomeController homeController = Get.put(HomeController());
  List<Cab> cabList = [];
  Future getCabList() async {
    try {
      isLoading.value = true;
      cabList.clear();
      var response = await ApiBase.getRequest(
          extendedURL:
              "${ApiUrl.cabListUrl}${"startLat=${homeController.fromLatLng.latitude}&startLng=${homeController.fromLatLng.longitude}&endLat=${homeController.toLatLng.latitude}&endLng=${homeController.toLatLng.longitude}"}");
      log(response.body);
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        CabListModel cabListModel = CabListModel.fromJson(data);
        cabList.addAll(cabListModel.data!.cabs!);
        homeController.selectedCabId = cabList.first.id.toString();
      }
    } catch (e) {
      log("getCabList $e");
    } finally {
      isLoading.value = false;
    }
  }

  CabDetailsData? cabDetailData;
  Future getCabDetails(String id) async {
    try {
      isLoading.value = true;
      var response = await ApiBase.postRequest(body: {
        'start_lat': homeController.fromLatLng.latitude,
        'start_lng': homeController.fromLatLng.longitude,
        'end_lat': homeController.toLatLng.latitude,
        "end_lng": homeController.toLatLng.longitude,
        'car_id': id
      }, extendedURL: ApiUrl.cabDetailUrl, withToken: true);
      log(response.body);
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        CabDetailModel cabDetailModel = CabDetailModel.fromJson(data);
        cabDetailData = cabDetailModel.data!;
        Get.to(() => const CabDetailInfoScreen());
      }
    } catch (e) {
      log("getCabDetail $e");
    } finally {
      isLoading.value = false;
    }
  }

  List<OngoingAndCompletedBooking> completed = [];
  List<CancelledBooking> cancelled = [];
  Future getCabBookHistory() async {
    try {
      completed.clear();
      cancelled.clear();
      isLoading.value = true;
      var response =
          await ApiBase.getRequest(extendedURL: ApiUrl.cabBookHistoryUrl);
      log(response.body);
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        BookingHisModel bookingHisModel = BookingHisModel.fromJson(data);
        completed.addAll(bookingHisModel.data!.ongoingAndCompletedBookings!);
        cancelled.addAll(bookingHisModel.data!.cancelledBookings!);
      }
    } catch (e) {
      log("getCabHistory $e");
    } finally {
      isLoading.value = false;
    }
  }

  String rideId = "";
  Future bookkingReq(context, cabId) async {
    Helper.loader(context);
    var body = {
      "userId": "${GetStoreData.getStore.read('id')}",
      "cab_id": cabId,
      "pickup_address": homeController.fromAddress.text,
      "pickup_lat": homeController.fromLatLng.latitude,
      "pickup_lng": homeController.fromLatLng.longitude,
      "drop_address": homeController.toAddress.text,
      "drop_lat": homeController.toLatLng.latitude,
      "drop_lng": homeController.toLatLng.longitude
    };
    var response = await ApiBase.postRequest(
        body: body, extendedURL: ApiUrl.cabBookRideReqUrl, withToken: true);
    log(response.body);
    var data = json.decode(response.body);
    if (data["status"] == true) {
      Get.back();
      rideId = data['data']['ride_id'];
      Get.to(CabSearchScreen());
    } else {
      Get.back();
      HelperSnackBar.snackBar("Error", data['message']);
    }
  }

  TripDetailModel? tripData;
  Future cancelReq(context) async {
    Helper.loader(context);
    var body = {
      "ride_id": rideId,
    };
    var response = await ApiBase.postRequest(
        body: body, extendedURL: ApiUrl.cabCancelReqUrl, withToken: true);
    log(response.body);
    var data = json.decode(response.body);
    if (data["status"] == true) {
      Get.offAll(const HomeScreen());
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
      var body = {'ride_id': rideId};
      var response = await ApiBase.postRequest(
          body: body, extendedURL: ApiUrl.cabRideCompleteUrl, withToken: true);
      log(response.body);
      var data = json.decode(response.body);
      if (data["status"] == true) {
        CompleteTripModel completeTripModel = CompleteTripModel.fromJson(data);
        tripComplete = completeTripModel.data!;
        homeController.ongoingMessage.value = "";
        homeController.ongoingStatus.value = "";
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
