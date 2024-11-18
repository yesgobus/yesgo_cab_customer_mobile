import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/loginController/login_controller.dart';
import '../../../utils/appcolors/app_colors.dart';
import '../../../utils/constant/png_asset_constant.dart';
import '../../../widget/buttons/button.dart';
import '../../../widget/text_field/otp_text_field.dart';
import '../../../widget/textwidget/text_widget.dart';

class OtpPage extends StatefulWidget {
  OtpPage({
    super.key,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  LoginMobileController loginMobileController =
      Get.put(LoginMobileController());

  int _timerSeconds = 60;
  late Timer _timer;
  bool _isTimerRunning = false;

  void _startTimer() {
    _isTimerRunning = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          _isTimerRunning = false;
          _timer.cancel();
        }
      });
    });
  }

  void _resendOTP() {
    // Simulate OTP resend functionality
    // Replace this with your actual OTP sending logic
    print("OTP resent successfully!");
    // Start the timer
    if (!_isTimerRunning) {
      _timerSeconds = 60;
      loginMobileController.resendOTP(context);
      loginMobileController.otpcontroller.clear();
      _startTimer();
    }
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    _startTimer();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white10, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              PngAssetPath.otpVerification,
              height: 174,
              width: 200,
            ),
            SizedBox(height: 20),
            Text(
              'Enter Verification Code',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'We have just sent a verification code to your ${loginMobileController.phoneController.text} mobile number',
              style:
                  theme.textTheme.bodyMedium?.copyWith(color: Colors.black45),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            OtpTextField(
              pinLength: 6,
              controller: loginMobileController.otpcontroller,
              onCompleted: (String st) {},
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                _resendOTP();
              },
              child: TextWidget(
                text: "Resend ${_isTimerRunning ? ": $_timerSeconds sec" : ""}",
                textSize: 16,
                color: AppColors.primaryColor,
              ),
            ),
            // const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(12),
        child: AppButton.primaryButton(
            title: 'Verify',
            onButtonPressed: () {
              loginMobileController.verifyOtpApi(context);
            }),
      ),
    );
  }
}
