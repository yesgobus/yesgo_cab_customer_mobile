import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

import '../../utils/constant/app_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/loginController/login_controller.dart';
import '../../../utils/appcolors/app_colors.dart';
import '../../../utils/constant/png_asset_constant.dart';
import '../../../utils/helper/helper_sncksbar.dart';
import '../../../widget/buttons/button.dart';
import '../../../widget/text_field/text_field.dart';
import '../../../widget/textwidget/text_widget.dart';
import '../../utils/helper/helper.dart';
import '../../utils/locationService/location_service.dart';
import 'otp_page.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  LoginMobileController loginMobileController =
      Get.put(LoginMobileController());
  @override
  void initState() {
    loginMobileController.isLogin = false;
    _checkPermissions();
    super.initState();
  }

  @override
  void dispose() {
    loginMobileController.isLogin = true;

    super.dispose();
  }

  GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                // const Spacer(),
                Center(
                  child: Image.asset(
                    PngAssetPath.appLogo,
                    color: AppColors.blackColor,
                    height: 120,
                    width: 120,
                  ),
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Welcome ',
                      style: const TextStyle(
                          fontSize: 24,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'YesGoBus',
                            style: TextStyle(color: AppColors.blackColor)),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                    child: TextWidget(
                  text: 'Signup with your mobile number',
                  color: AppColors.blackColor,
                  textSize: 12,
                )),
                const SizedBox(height: 20),
                // InkWell(
                //   onTap: () {
                //     loginMobileController.openCameraGallery(isCamera: false);
                //     Get.back();
                //   },
                //   child: Stack(
                //     alignment: Alignment.bottomRight,
                //     children: [
                //       Padding(
                //         padding: const EdgeInsets.all(2.0),
                //         child: CircleAvatar(
                //           radius: 40,
                //           backgroundColor: AppColors.whiteColor,
                //           child: GetBuilder<LoginMobileController>(
                //             builder: (c) {
                //               if (c.image != null) {
                //                 return ClipRRect(
                //                   borderRadius: BorderRadius.circular(100),
                //                   child: Image.file(
                //                     File(
                //                       c.image!.path,
                //                     ),
                //                     height: 80,
                //                     width: 80,
                //                     fit: BoxFit.fill,
                //                   ),
                //                 );
                //               } else {
                //                 return Padding(
                //                   padding: EdgeInsets.all(6.0),
                //                   child: Icon(
                //                     Icons.person,
                //                     size: 40,
                //                     color: AppColors.grey5Color,
                //                   ),
                //                 );
                //               }
                //             },
                //           ),
                //         ),
                //       ),
                //       Card(
                //         elevation: 5,
                //         color: AppColors.primaryColor,
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(50.0),
                //         ),
                //         margin: const EdgeInsets.all(0),
                //         child: Padding(
                //           padding: EdgeInsets.all(3.0),
                //           child: Icon(
                //             Icons.camera_alt,
                //             size: 20,
                //             color: AppColors.whiteColor,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // TextWidget(
                //     text: "Mobile Number",
                //     color: AppColors.blackColor,
                //     textSize: 16),
                // const SizedBox(height: 4),
                MyCustomTextField.textFieldPhone(
                    textInputType: TextInputType.phone,
                    borderRadius: 100,
                    controller: loginMobileController.phoneController,
                    borderClr: AppColors.blackColor,
                    textClr: AppColors.blackColor,
                    valText: "Please enter mobile number",
                    hintText: "Enter Mobile Number"),
                sizedTextfield,
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // TextWidget(
                          //     text: "First Name",
                          //     color: AppColors.blackColor,
                          //     textSize: 16),
                          // const SizedBox(height: 4),
                          MyCustomTextField.textField(
                              controller:
                                  loginMobileController.firstNameController,
                              borderClr: AppColors.blackColor,
                              textClr: AppColors.blackColor,
                              borderRadius: 100,
                              valText: "Please enter first name",
                              hintText: "Enter First Name"),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // TextWidget(
                          //     text: "Last Name",
                          //     color: AppColors.blackColor,
                          //     textSize: 16),
                          // const SizedBox(height: 4),
                          MyCustomTextField.textField(
                              controller:
                                  loginMobileController.lastNameController,
                              borderClr: AppColors.blackColor,
                              borderRadius: 100,
                              textClr: AppColors.blackColor,
                              valText: "Please enter last name",
                              hintText: "Enter Last Name"),
                        ],
                      ),
                    ),
                  ],
                ),
                sizedTextfield,

                // TextWidget(
                //     text: "Email",
                //     color: AppColors.blackColor,
                //     align: TextAlign.start,
                //     textSize: 16),
                // const SizedBox(height: 4),
                MyCustomTextField.textField(
                    controller: loginMobileController.emailController,
                    borderClr: AppColors.blackColor,
                    borderRadius: 100,
                    textClr: AppColors.blackColor,
                    hintText: "Enter Email"),
                sizedTextfield,
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: AppButton.primaryButton(
          title:
              _isPermissionGranted == true ? 'SIGN UP' : "Turn On Permission",
          onButtonPressed: () {
            if (_isPermissionGranted) {
              Helper.loader(Get.context);
              getCurrentLocation().then((value) async {
                if (formkey.currentState!.validate()) {
                  if (loginMobileController.passwordController.text ==
                      loginMobileController.conPasswordController.text) {
                    loginMobileController.signupApi(context);
                  } else {
                    HelperSnackBar.snackBar("Error", "Password not matched");
                  }
                }
              });
            } else {
              _checkPermissions();
            }
          },
        ),
      ),
    );
  }

  bool _isPermissionGranted = false;
  Future<void> _checkPermissions() async {
    // Check foreground location permission
    PermissionStatus foregroundStatus =
        await Permission.locationWhenInUse.status;

    if (foregroundStatus.isDenied ||
        foregroundStatus.isPermanentlyDenied ||
        foregroundStatus.isRestricted) {
      // Request foreground location permission
      PermissionStatus newForegroundStatus =
          await Permission.location.request();
      if (newForegroundStatus.isGranted) {
        _isPermissionGranted = true;
        setState(() {});
      }
    } else if (foregroundStatus.isGranted) {
      _isPermissionGranted = true;
      setState(() {});
    } else {
      _isPermissionGranted = false;
      setState(() {});
      // openAppSettings();
    }
  }
}

// Future<bool> chooseImage({
//   required BuildContext context,
//   required Function() onTapCamera,
//   required Function() onTapGallery,
// }) async {
//   final width = MediaQuery.of(context).size.width;
//   return await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//             contentPadding: const EdgeInsets.all(0),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Container(
//                   height: 60,
//                   width: 60,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(100),
//                       color: AppColors.primaryColor,
//                       border: Border.all(color: AppColors.white, width: 0)),
//                   child: const Icon(
//                     Icons.image,
//                     size: 40,
//                     color: AppColors.white,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 16,
//                 ),
//                 const TextWidget(
//                   text: AppText.uploadProfile,
//                   textSize: 18,
//                   color: AppColors.black,
//                   maxLine: 2,
//                   fontWeight: FontWeight.w600,
//                 ),
//                 const SizedBox(
//                   height: 12,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       ListTile(
//                         leading: Icon(
//                           Icons.camera_alt,
//                           color: AppColors.black65,
//                           size: 30,
//                         ),
//                         title: const TextWidget(
//                           text: "Take Photo",
//                           textSize: 16,
//                           color: Colors.black,
//                         ),
//                         onTap: onTapCamera,
//                       ),
//                       ListTile(
//                         leading: Icon(
//                           Icons.image,
//                           color: AppColors.black65,
//                           size: 30,
//                         ),
//                         title: const TextWidget(
//                             text: "Choose From Gallery",
//                             textSize: 16,
//                             color: Colors.black),
//                         onTap: onTapGallery,
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Divider(
//                   color: AppColors.grey3Color,
//                   height: 0,
//                   thickness: 1,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: InkWell(
//                         onTap: () {
//                           Get.back();
//                         },
//                         child: SizedBox(
//                           height: 45,
//                           child: Center(
//                             child: TextWidget(
//                               text: "cancel".toUpperCase(),
//                               color: Colors.black54,
//                               fontWeight: FontWeight.w500,
//                               textSize: 14,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ));
// }
