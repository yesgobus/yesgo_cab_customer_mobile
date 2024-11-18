import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:yesgo_cab_customer/controller/CAB/cabTripController/cab_trip_controller.dart';
import 'package:yesgo_cab_customer/controller/CAB/homeController/home_controller.dart';
import 'package:yesgo_cab_customer/screen/CAB/cabSearchScreen/cab_search_screen.dart';
import 'package:yesgo_cab_customer/utils/appcolors/app_colors.dart';
import 'package:yesgo_cab_customer/utils/constant/app_var.dart';
import 'package:yesgo_cab_customer/utils/constant/png_asset_constant.dart';
import 'package:yesgo_cab_customer/utils/helper/helper.dart';
import 'package:yesgo_cab_customer/widget/buttons/button.dart';
import 'package:yesgo_cab_customer/widget/text_field/text_field.dart';
import 'package:yesgo_cab_customer/widget/textwidget/text_widget.dart';

class CabDetailInfoScreen extends StatefulWidget {
  const CabDetailInfoScreen({super.key});

  @override
  State<CabDetailInfoScreen> createState() => _CabDetailInfoScreenState();
}

class _CabDetailInfoScreenState extends State<CabDetailInfoScreen> {
  HomeController homeController = Get.find();
  CabController cabListingController = Get.find();
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.grey1Color,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          automaticallyImplyLeading: false,
          toolbarHeight: 0,
        ),
        body: Obx(
          () => cabListingController.isLoading.value
              ? Helper.pageLoading()
              : Column(
                  children: [
                    Container(
                      color: AppColors.whiteColor,
                      padding: const EdgeInsets.only(
                          top: 4, left: 12, right: 12, bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: const Icon(Icons.arrow_back)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextWidget(
                                  text:
                                      "${cabListingController.cabDetailData!.route}",
                                  textSize: 14,maxLine: 2,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 36, top: 4),
                            child: TextWidget(
                                text:
                                    "${cabListingController.cabDetailData!.date} - Pickup in ${cabListingController.cabDetailData!.pickupTime}",
                                textSize: 13),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            sizedTextfield,
                            carDetails(),
                            sizedTextfield,
                            cabDriverDetail(),
                            sizedTextfield,
                            inclusionExclusion(),
                            sizedTextfield,
                            // contactDetail(),
                            // sizedTextfield,
                            if(cabListingController.cabDetailData!.additionalInfo!.isNotEmpty)
                            readBeforeBook(),
                            sizedTextfield,
                            AppButton.primaryButton(
                                onButtonPressed: () {
                                  cabListingController.bookkingReq(
                                      context, homeController.selectedCabId);
                                },
                                borderRadius: 0,
                                title: "Done")
                          ],
                        ),
                      ),
                    )
                  ],
                ),
        ));
  }

  carDetails() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.grey3Color),
          color: AppColors.whiteColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.network(
                cabListingController.cabDetailData!.car!.imageUrl!,
                height: 65,
                width: 80,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text:
                          "${cabListingController.cabDetailData!.car!.carName}",
                      textSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border:
                                    Border.all(color: AppColors.grey4Color)),
                            child: TextWidget(
                                text:
                                    "${cabListingController.cabDetailData!.car!.category}",
                                textSize: 10)),
                        const SizedBox(width: 8),
                        Icon(Icons.ac_unit, size: 15, color: AppColors.black65),
                        const SizedBox(width: 2),
                        cabListingController.cabDetailData!.car!.ac!
                            ? const TextWidget(text: "Ac", textSize: 10)
                            : const TextWidget(text: "Non Ac", textSize: 10),
                        const SizedBox(width: 8),
                        Icon(Icons.airline_seat_recline_normal,
                            size: 15, color: AppColors.black65),
                        const SizedBox(width: 2),
                        TextWidget(
                            text:
                                "${cabListingController.cabDetailData!.car!.passengerCapacity} Passenger",
                            textSize: 10),
                        const SizedBox(width: 8),
                        Icon(Icons.luggage, size: 15, color: AppColors.black65),
                        const SizedBox(width: 2),
                        TextWidget(
                            text:
                                "${cabListingController.cabDetailData!.car!.luggageCapacity} Bag",
                            textSize: 10),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          const Divider(),
          Row(
            children: [
              TextWidget(
                  text: "${cabListingController.cabDetailData!.car!.carSize}",
                  textSize: 15,
                  fontWeight: FontWeight.w500),
              const SizedBox(width: 8),
              // Container(
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(6),
              //       border: Border.all(
              //           color: AppColors.darkGreenColor, width: 1.5)),
              //   child: Row(
              //     children: [
              //       Container(
              //         padding: const EdgeInsets.symmetric(
              //             horizontal: 6, vertical: 2),
              //         decoration: BoxDecoration(
              //             color: AppColors.darkGreenColor,
              //             borderRadius: BorderRadius.circular(4)),
              //         child: Row(
              //           children: [
              //             const Icon(Icons.star,
              //                 size: 12, color: AppColors.whiteColor),
              //             const SizedBox(width: 2),
              //             TextWidget(
              //                 text:
              //                     "${cabListingController.cabDetailData!.car!.rating}",
              //                 color: AppColors.whiteColor,
              //                 textSize: 12),
              //           ],
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 6),
              //         child: TextWidget(
              //             text:
              //                 "${cabListingController.cabDetailData!.car!.totalRatings}",
              //             color: AppColors.black65,
              //             textSize: 12),
              //       )
              //     ],
              //   ),
              // )
         
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_location_outlined,
                      color: AppColors.primaryColor,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    TextWidget(text: "Extra Km Fare", textSize: 14)
                  ],
                ),
              ),
              Expanded(
                child: TextWidget(
                  text:
                      "${cabListingController.cabDetailData!.car!.extraKmFare} after ${cabListingController.cabDetailData!.inclusions!.includedKms}",
                  textSize: 14,
                  maxLine: 2,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.swap_calls,
                      color: AppColors.primaryColor,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    TextWidget(text: "Fuel Type", textSize: 14)
                  ],
                ),
              ),
              Expanded(
                  child: TextWidget(
                text: "${cabListingController.cabDetailData!.car!.fuelType}",
                textSize: 15,
                fontWeight: FontWeight.w500,
              ))
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      color: AppColors.primaryColor,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    TextWidget(text: "Cancellation", textSize: 14)
                  ],
                ),
              ),
              Expanded(
                  child: TextWidget(
                text:
                    "${cabListingController.cabDetailData!.car!.cancellationPolicy}",
                textSize: 14,
                fontWeight: FontWeight.w500,
                maxLine: 2,
              ))
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.timer_sharp,
                  size: 20, color: AppColors.primaryColor),
              const SizedBox(width: 4),
              TextWidget(
                  text:
                      "Free waiting upto ${cabListingController.cabDetailData!.car!.freeWaitingTime}",
                  fontWeight: FontWeight.w500,
                  textSize: 16),
            ],
          )
        ],
      ),
    );
  }

  cabDriverDetail() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.grey3Color),
          color: AppColors.whiteColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextWidget(
              text: "Cab & driver details",
              textSize: 15,
              fontWeight: FontWeight.w500),
          const Divider(),
          // const TextWidget(
          //   text:
          //       "Your cab and driver details will be shared via whatsapp & SMS on your registered mobile number by",
          //   textSize: 13,
          //   maxLine: 2,
          // ),
          // const SizedBox(height: 4),
          // const TextWidget(
          //   text: "05 Jul 2023 at 10:00 am",
          //   textSize: 14,
          //   fontWeight: FontWeight.w500,
          // ),
          // const Divider(),
          const TextWidget(
            text: "About our drivers",
            textSize: 14,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.check,
                color: AppColors.greenColor,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                  child: TextWidget(
                      text:
                          "${cabListingController.cabDetailData!.driverDetails!.verification}",
                      maxLine: 2,
                      textSize: 13)),
            ],
          ),
          // const Divider(),
          // const TextWidget(
          //   text: "Ratings & reviews",
          //   textSize: 14,
          //   fontWeight: FontWeight.w500,
          // ),
          // const SizedBox(height: 6),
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Container(
          //       margin: const EdgeInsets.only(top: 4),
          //       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          //       decoration: BoxDecoration(
          //           color: AppColors.darkGreenColor,
          //           borderRadius: BorderRadius.circular(4)),
          //       child: Row(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           const Icon(Icons.star,
          //               size: 12, color: AppColors.whiteColor),
          //           const SizedBox(width: 2),
          //           TextWidget(
          //               text:
          //                   "${cabListingController.cabDetailData!.car!.rating}",
          //               color: AppColors.whiteColor,
          //               textSize: 12),
          //         ],
          //       ),
          //     ),
          //     const SizedBox(width: 8),
          //     Expanded(
          //       child: TextWidget(
          //         text:
          //             "Based on ${cabListingController.cabDetailData!.car!.totalRatings} aggregated ratings of supplier for this vehicle category",
          //         textSize: 13,
          //         maxLine: 2,
          //       ),
          //     )
          //   ],
          // ),
          // const SizedBox(height: 6),
          // Row(
          //   children: [
          //     Expanded(
          //       child: Row(
          //         children: [
          //           const TextWidget(
          //             text: "Driver rating",
          //             textSize: 13,
          //             maxLine: 2,
          //           ),
          //           const SizedBox(width: 8),
          //           Row(
          //             mainAxisSize: MainAxisSize.min,
          //             children: [
          //               Icon(Icons.star,
          //                   size: 12, color: AppColors.darkGreenColor),
          //               const SizedBox(width: 2),
          //               TextWidget(
          //                   text:
          //                       "${cabListingController.cabDetailData!.driverDetails!.driverRating}",
          //                   color: AppColors.blackColor,
          //                   textSize: 12),
          //             ],
          //           ),
          //         ],
          //       ),
          //     ),
          //     Expanded(
          //       child: Row(
          //         children: [
          //           const TextWidget(
          //             text: "Cab  rating",
          //             textSize: 13,
          //             maxLine: 2,
          //           ),
          //           const SizedBox(width: 8),
          //           Row(
          //             mainAxisSize: MainAxisSize.min,
          //             children: [
          //               Icon(Icons.star,
          //                   size: 12, color: AppColors.darkGreenColor),
          //               const SizedBox(width: 2),
          //               TextWidget(
          //                   text:
          //                       "${cabListingController.cabDetailData!.driverDetails!.cabRating}",
          //                   color: AppColors.blackColor,
          //                   textSize: 12),
          //             ],
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  inclusionExclusion() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.grey3Color),
          color: AppColors.whiteColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextWidget(
            text: "Inclusions & exclusions",
            textSize: 16,
            fontWeight: FontWeight.w500,
          ),
          const Divider(),
          const TextWidget(
            text: "Included in your fare",
            textSize: 14,
            fontWeight: FontWeight.w500,
          ),
          Row(
                  crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    TextWidget(
                        text:
                            "● ${cabListingController.cabDetailData!.inclusions!.includedKms}",
                        textSize: 13),
                    if (cabListingController
                        .cabDetailData!.inclusions!.stateTaxes!)
                      const SizedBox(height: 6),
                    if (cabListingController
                        .cabDetailData!.inclusions!.stateTaxes!)
                      const TextWidget(text: "● State Taxes", textSize: 13),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    TextWidget(
                        text:
                            "● ${cabListingController.cabDetailData!.inclusions!.pickupDrop}",
                        textSize: 13),
                    if (cabListingController
                        .cabDetailData!.inclusions!.tollCharges!)
                      const SizedBox(height: 6),
                    if (cabListingController
                        .cabDetailData!.inclusions!.tollCharges!)
                      const TextWidget(text: "● Toll Charges", textSize: 13),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const TextWidget(
            text: "Extra charges (based on your usage)",
            textSize: 14,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 6),
          TextWidget(
              text:
                  "● Fare beyond ${cabListingController.cabDetailData!.inclusions!.includedKms} : ${cabListingController.cabDetailData!.extraCharges!.fareBeyondIncludedDistance}",
              textSize: 13),
          const SizedBox(height: 6),
          TextWidget(
              text:
                  "● Waiting charges ${cabListingController.cabDetailData!.extraCharges!.waitingChargesBeyondFreeTime} after ${cabListingController.cabDetailData!.car!.freeWaitingTime}",
              textSize: 13),
        ],
      ),
    );
  }

  contactDetail() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.grey3Color),
          color: AppColors.whiteColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextWidget(
            text: "Contact Details",
            textSize: 15,
            fontWeight: FontWeight.w500,
          ),
          const Divider(),
          const TextWidget(
              text: "Email", textSize: 14, fontWeight: FontWeight.w500),
          const SizedBox(height: 8),
          MyCustomTextField.textField(
              hintText: "Enter Email",
              borderClr: AppColors.black65,
              controller: homeController.emailController),
          const SizedBox(height: 8),
          const TextWidget(
              text: "Mobile Number", textSize: 14, fontWeight: FontWeight.w500),
          const SizedBox(height: 8),
          MyCustomTextField.textFieldPhone(
              hintText: "Enter Mobile Number",
              borderClr: AppColors.black65,
              controller: homeController.emailController),
        ],
      ),
    );
  }

  readBeforeBook() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.grey3Color),
          color: AppColors.whiteColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextWidget(
              text: "Read before you book!",
              textSize: 15,
              fontWeight: FontWeight.w500),
          const Divider(),
          const TextWidget(
            text: "Highlights",
            textSize: 14,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 8),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                cabListingController.cabDetailData!.additionalInfo!.length,
                (index) => Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextWidget(
                      text:
                          "● ${cabListingController.cabDetailData!.additionalInfo![index]}",
                      maxLine: 2,
                      textSize: 14),
                ),
              )),
        ],
      ),
    );
  }
}
