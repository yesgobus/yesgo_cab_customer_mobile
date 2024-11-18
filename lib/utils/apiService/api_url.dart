class ApiUrl {
  /// base url
  static const String baseUrl =
      "http://ec2-3-109-123-180.ap-south-1.compute.amazonaws.com:3000/";
  // static const String baseUrl = "https://cab-booking-m2ct.onrender.com/";
  static const String loginUrl = "user/login";
  static const String signupUrl = "user/signup";
  static const String verifyOTPUrl = "user/verify_otp";
  static const String resendOTPUrl = "user/resend_otp";
  static const String cabListUrl = "cab/cab-listing?";
  static const String cabDetailUrl = "cab/cab-details";
  static const String cabBookHistoryUrl = "cab/booking-history";
  static const String cabBookRideReqUrl = "cab/trigger-ride-request";
  static const String cabCancelReqUrl = "cab/ride/cancel";
  static const String cabRideCompleteUrl = "cab/ride/completed";

  static const String transportListUrl = "transport/transport-listing?";
  static const String transportDetailsUrl = "transport/transport-details";
  static const String goodsCategoryListUrl = "transport/goods-list/";
  static const String transportRideReqUrl = "transport/trigger-parcel-request";
  static const String transportCancelUrl = "transport/cancel";
  static const String transportRideCompleteUrl = "transport/completed";


  
}
