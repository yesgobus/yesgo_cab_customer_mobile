import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yesgo_cab_customer/controller/TRANSPORT/homeController/home_controller_trans.dart';

import '../../../../model/AddressModel/search_address_details.dart';
import '../../../../model/AddressModel/search_responce_model.dart';
import '../../../../utils/appcolors/app_colors.dart';
import '../../../../utils/placeService/place_services.dart';

class AddressChooseWidgetTrans extends StatefulWidget {
  const AddressChooseWidgetTrans({super.key});

  @override
  State<AddressChooseWidgetTrans> createState() => _AddressChooseWidgetTransState();
}

class _AddressChooseWidgetTransState extends State<AddressChooseWidgetTrans> {
  final placesService = PlacesService();
  List<Prediction> searchResults = [];
  HomeControllerTrans homeControllerTrans = Get.find();
  bool fromAddress = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.black45),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                        radius: 6, backgroundColor: AppColors.darkGreenColor),
                    Container(
                        height: 31,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        width: 1,
                        color: AppColors.blackColor),
                    CircleAvatar(
                        radius: 6, backgroundColor: AppColors.redColor),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: homeControllerTrans.fromAddress,
                      onChanged: (val) {
                        fromAddress = true;
                        homeControllerTrans.isAddressSelected = false;
                        placesService.getAutocomplete(val).then((value) {
                          final searchResponse =
                              searchAddressListFromJson(value);

                          searchResults = searchResponse.predictions!;
                        });
                        setState(() {});
                      },
                      decoration: InputDecoration(
                          suffixIconConstraints:
                              BoxConstraints.tight(const Size(24, 20)),
                          suffixIcon: homeControllerTrans.fromAddress.text.isNotEmpty
                              ? InkWell(
                                  onTap: () {
                                    homeControllerTrans.fromAddress.clear();
                                    fromAddress = false;
                                    homeControllerTrans.isAddressSelected = true;
                                    homeControllerTrans.fromLatLng = const LatLng(0, 0);
                                    setState(() {});
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: CircleAvatar(
                                      radius: 8,
                                      backgroundColor: AppColors.black65,
                                      child: Icon(Icons.close,
                                          size: 16,
                                          color: AppColors.whiteColor),
                                    ),
                                  ),
                                )
                              : null,
                          hintText: 'Your Current Location',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontSize: 14, color: AppColors.black45)),
                    ),
                    const Divider(
                      height: 0,
                    ),
                    TextField(
                      controller: homeControllerTrans.toAddress,
                      onChanged: (val) {
                        placesService.getAutocomplete(val).then((value) {
                          final searchResponse =
                              searchAddressListFromJson(value);
                          searchResults = searchResponse.predictions!;
                          fromAddress = false;
                          homeControllerTrans.isAddressSelected = false;
                          setState(() {});
                        });
                      },
                      decoration: InputDecoration(
                        suffixIconConstraints:
                            BoxConstraints.tight(const Size(24, 20)),
                        suffixIcon: homeControllerTrans.toAddress.text.isNotEmpty
                            ? InkWell(
                                onTap: () {
                                  homeControllerTrans.toAddress.clear();
                                  fromAddress = false;
                                  homeControllerTrans.isAddressSelected = true;
                                  homeControllerTrans.toLatLng = const LatLng(0, 0);
                                  setState(() {});
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: CircleAvatar(
                                    radius: 8,
                                    backgroundColor: AppColors.black65,
                                    child: Icon(Icons.close,
                                        size: 16, color: AppColors.whiteColor),
                                  ),
                                ),
                              )
                            : null,
                        hintText: 'Enter Destination',
                        hintStyle:
                            TextStyle(fontSize: 14, color: AppColors.black45),
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: (homeControllerTrans.fromAddress.text.isNotEmpty ||
                  homeControllerTrans.toAddress.text.isNotEmpty) &&
              homeControllerTrans.isAddressSelected == false,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Container(
              height: Get.height * 0.3,
              width: Get.width - 32,
              decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(10)),
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        dense: true,
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -4),
                        contentPadding:
                            const EdgeInsets.only(left: 12, right: 12),
                        title: Text(
                          // change
                          searchResults[index].description.toString(),
                          style: TextStyle(
                              color: AppColors.blackColor, fontSize: 16),
                        ),
                        onTap: () async {
                          String id = searchResults[index].placeId.toString();
                          placesService.getPlace(id).then((value) async {
                            final searchResponse =
                                searchAddressDetailsFromJson(value);
                            homeControllerTrans.isAddressSelected = true;
                            if (fromAddress) {
                              homeControllerTrans.fromLatLng = LatLng(
                                  searchResponse
                                      .result!.geometry!.location!.lat!,
                                  searchResponse
                                      .result!.geometry!.location!.lng!);
                              homeControllerTrans.fromAddress.text =
                                  searchResults[index].description!;
                              setState(() {});
                            } else {
                              homeControllerTrans.toLatLng = LatLng(
                                  searchResponse
                                      .result!.geometry!.location!.lat!,
                                  searchResponse
                                      .result!.geometry!.location!.lng!);
                              homeControllerTrans.toAddress.text =
                                  searchResults[index].description!;
                              setState(() {});
                            }
                          });
                        },
                      ),
                      Divider(
                        color: AppColors.black45,
                        height: 4,
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
