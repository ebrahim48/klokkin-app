class ApiConstants {
  static const String baseUrl = "https://api.klokkin.com/api/v1";
  // static const String baseUrl = "https://mihad8080.ssh.bd/api/v1";
  static const String imageBaseUrl = "https://api.klokkin.com";

  static const String signUpEndPoint = "/auth/register";
  static const String loginEndPoint = "/auth/login";
  static const String changePassword = "/auth/change-password";
  static const String verifyEmailEndPoint = "/auth/verify-email";
  static const String forgotPasswordEndPoint = "/auth/forgot-password";
  static const String resetPasswordEndPoint = "/auth/reset-password";
  static const String resendOtpEndPoint = "/auth/resend-otp";

  static const String getAllTagsEndPoint = "/tag/tags";
  static String updateTagEndPoint(String id) => "/tag/tags/$id";
  static const String uploadEndPoint = "/story/story";
  static const String getLatestFormEndPoint = "/story/story";
  static const String getWorkingDaysEndPoint = "/story/working-days";
  static const String getStoryStepsEndPoint = "/story/story-steps";
  static String getStorySingleEndPoint(String id) => "/story/story/$id";
  static String getMyStoryEndPoint(String page) => "/story/stories?page=$page";
  static String getStoryLibraryEndPoint = "/story/libraryData";
  static String bookMarkEndPoint = "/story/bookmark";
  static String deleteBookMarkEndPoint = "/story/bookmark";
  static String shareEndPoint = "/share_story/share/";
  static String userProfileEndPoint = "/user/profile";
  static String userUpdateProfileEndPoint = "/user/profile";
  static String deleteProfileEndPoint = "/user/profile";
  static String deleteStoryEndPoint(String id) => "/story/story/$id";
  static String updateStoryEndPoint(String id) => "/story/story/$id";
  static String feedbackEndPoint = "/feedback/feedbacks";
  static String privacyEndPoint = "/setting/privacy-policy";
  static String aboutEndPoint = "/setting/about-us";
  static String termsEndPoint = "/setting/terms-conditions";
  static String notificationsEndPoint = "/notification/";

  // ---- Subscription ----
  static const String subscriptionPlansEndPoint = "/subscription/plans";
  static const String mySubscriptionEndPoint = "/subscription/me";
  static const String subscriptionPurchaseEndPoint = "/subscription/purchase";
  static String subscriptionTransactionsEndPoint({int page = 1}) =>
      "/subscription/transactions?page=$page";
}
