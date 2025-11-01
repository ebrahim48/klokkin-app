import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import '../../core/app_constants/app_constants.dart';
import '../../core/config/app_routes/app_routes.dart';
import '../../core/helpers/prefs_helper.dart';
import '../../core/helpers/toast_message_helper.dart';
import '../../services/api_client.dart';
import '../../services/api_constants.dart';




class AuthController extends GetxController {

  bool isChecked = false;
  bool isCheckboxError = false;
  RxBool isObscure = true.obs;
  RxBool isObscureConfirmPassword = true.obs;
  var logger = Logger();

  toggleIsObscure() {
    isObscure.value = !isObscure.value;
  }

  toggleIsObscureConfirmPassword() {
    isObscureConfirmPassword.value = !isObscureConfirmPassword.value;
  }


  RxBool signUpLoading = false.obs;

  ///========================================== Sing up ==================================<>

  handleSignUp(
      {String? fname, email, phone, password, confirmpassword, required BuildContext context, required String screenType}) async {
    signUpLoading(true);
    var body = {
      "email": "$email",
      "fname": "$fname",
      "phone": "$phone",
      "password": "$password",
      "confirmpassword": "$confirmpassword",
    };

    var response = await ApiClient.postData(
      ApiConstants.signUpEndPoint, jsonEncode(body),);

    if (response.statusCode == 200 || response.statusCode == 201) {
      await PrefsHelper.setString(AppConstants.bearerToken,
          response.body["data"]["attributes"]["verificationToken"]);

      final token = response.body["data"]["attributes"]["verificationToken"];
      await PrefsHelper.setString(AppConstants.bearerToken, token);
      context.pushNamed(
        AppRoutes.verifyScreen,
        extra: {
          "screenType": "signup",
          "email": email,
          "token": token,
        },
      );
      ToastMessageHelper.showToastMessage(
          "User created successfully, please verify your email");
      signUpLoading(false);
    } else {
      // ToastMessageHelper.showToastMessage(
      //     "${response.body["message"]}", title: 'Fail');
      signUpLoading(false);
    }
  }


  ///========================================Verify Email===========================================<>
  RxBool verfyLoading = false.obs;

  verfyEmail(String otpCode, String email, String token,
      {String screenType = '', String type = '', required BuildContext context}) async {
    verfyLoading(true);
    var body = {
      "otp": otpCode,
      "email": email,
      "token": token
    };
    var response = await ApiClient.postData(
        ApiConstants.verifyEmailEndPoint, jsonEncode(body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      verfyLoading(false);
      final accessToken = response
          .body["data"]["attributes"]["result"]["accessToken"];
      await PrefsHelper.setString(AppConstants.bearerToken, accessToken);

      // if(screenType== 'forgot'){
      //   debugPrint("==========bearer token save done : ${response.body["data"]["attributes"]["result"]['accessToken']}");
      //   await PrefsHelper.setString(AppConstants.bearerToken, response.body["data"]["attributes"]["result"]['accessToken']);
      //
      // }else{
      //   debugPrint("==========bearer token save done : ${response.body["data"]["attributes"]["result"]['accessToken']}");
      //   await PrefsHelper.setString(AppConstants.bearerToken, response.body["data"]["attributes"]["result"]['accessToken']);
      // }


      if (type == 'Sign Up' && screenType == 'signup') {
        context.go(AppRoutes.logInScreen);
      } else if (type == 'Forgot' && screenType == 'forgot') {
        context.go(AppRoutes.resetPasswordScreen);
      }

      // if (type == 'Sign Up') {
      //   print('================================ screenType received yjuikhujikgyhujvghg: $screenType');
      //   if(screenType== 'signup'){
      //     context.go(AppRoutes.logInScreen);
      //   }
      // }else{
      //   context.go(AppRoutes.resetPasswordScreen);
      // }


      verfyLoading(false);
      ToastMessageHelper.showToastMessage("${response.body["message"]}");
    } else {
      verfyLoading(false);
      ToastMessageHelper.showToastMessage(
          "${response.body["message"]}", title: 'attention');
      print(
          '================================ screenType received yjuikhujikgyhujvghg: $screenType');
    }
  }


  ///============================================= Log in ===============================================<>
  RxBool logInLoading = false.obs;

  handleLogIn(String email, String password,
      {required BuildContext context}) async {
    logInLoading.value = true;

    var headers = {'Content-Type': 'application/json'};
    var body = {
      "email": email,
      "password": password,
    };

    var response = await ApiClient.postData(
      ApiConstants.loginUpEndPoint,
      jsonEncode(body),
      headers: headers,
    );

    logInLoading.value = false;

    print("========================${response.statusCode} \n ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = response.body['data']['attributes']["userWithoutPassword"];


      logger.d("token  .....");

      /// Access token save
      var token = response.body["data"]['attributes']["tokens"]["accessToken"];
      logger.d("token   .... ======>> $token");
      await PrefsHelper.setString(AppConstants.bearerToken, token,
      );
      await PrefsHelper.setString(AppConstants.role, data['role']);

      /// Save user details
      await PrefsHelper.setString(AppConstants.email, email);
      await PrefsHelper.setString(AppConstants.userId, data['_id']);

      var role = data['role'];
      print("========================================= role : $role");

      if (role == "user") {
        await PrefsHelper.setBool(AppConstants.isLogged, true);
        context.go(AppRoutes.bottomNavbarScreen);
        ToastMessageHelper.showToastMessage(
            "You are logged in", title: 'Success');
      } else {
        final message = response.body["message"];

        if (message == "Email not verified. Please verify your email.") {
          final verificationToken = response
              .body["data"]['attributes']["tokens"]["accessToken"];

          await PrefsHelper.setString(
              AppConstants.bearerToken, verificationToken);

          ToastMessageHelper.showToastMessage(
            "We've sent an OTP to your email. Please verify your email.",
          );
        } else if (message == "⛔ Wrong password! ⛔") {
          ToastMessageHelper.showToastMessage(message);
        } else {
          ToastMessageHelper.showToastMessage(
            message,
            title: 'attention',
          );
        }
      }
    }
  }


  ///===========================================> Forgot Password ====================================================<>
  RxBool forgotLoading = false.obs;

  handleForgot(String email, screenType,
      {required BuildContext context}) async {
    forgotLoading(true);
    var body = {"email": email};
    var response = await ApiClient.postData(
      ApiConstants.forgotPasswordEndPoint,
      jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final token = response.body["data"]["attributes"]["resetPasswordToken"] ??
          response.body["data"]["attributes"]["verificationToken"];
      if (token != null) {
        await PrefsHelper.setString(AppConstants.bearerToken, token);
      } else {
        debugPrint("❌ Token missing in forgot response.");
      }

      if (screenType == "forgot") {
        context.pushNamed(AppRoutes.verifyScreen, extra: {
          "screenType": "forgot",
          "email": email,
          "token": token,
        });
      }

      forgotLoading(false);
    } else {
      forgotLoading(false);
      ToastMessageHelper.showToastMessage(response.body["message"]);
    }
  }


  ///===============Set Password================<>

  RxBool setPasswordLoading = false.obs;

  setPassword(String password,
      String confirmpassword,
      {required BuildContext context}) async {
    setPasswordLoading(true);
    var body = {
      "password": password.toString().trim(),
      "confirmpassword": confirmpassword.toString().trim()
    };

    var response = await ApiClient.postData(
        ApiConstants.resetPasswordEndPoint, jsonEncode(body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      context.pushNamed(AppRoutes.logInScreen);
      ToastMessageHelper.showToastMessage(
          '${response.body["message"]}', title: 'success');
      print("======>>> successful");
      setPasswordLoading(false);
    } else if (response.statusCode == 1) {
      setPasswordLoading(false);
      ToastMessageHelper.showToastMessage("Server error! \n Please try later");
    } else {
      setPasswordLoading(false);
      ToastMessageHelper.showToastMessage(
          '${response.body["message"]}', title: 'attention');
    }
  }


  ///===============Resend================<>

  ///===============Resend================<>

  RxBool resendLoading = false.obs;


  reSendOtp(String email) async {
    resendLoading(true);

    String token = await PrefsHelper.getString(AppConstants.bearerToken);

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };

    var body = {
      "email": email,
    };

    var response = await ApiClient.postData(
      ApiConstants.resendOtpEndPoint,
      jsonEncode(body),
      headers: headers,
    );

    resendLoading(false);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final attributes = response.body["data"]["attributes"];

      final newToken =
          attributes["resetPasswordToken"] ?? attributes["verificationToken"];

      if (newToken != null) {
        await PrefsHelper.setString(AppConstants.bearerToken, newToken);
        debugPrint("✅ New token saved: $newToken");
      } else {
        debugPrint("❌ Token missing in resendOtp response.");
      }

      ToastMessageHelper.showToastMessage(
          "✅ OTP sent successfully to your email.");
    } else {
      ToastMessageHelper.showToastMessage(
        response.body["message"] ?? "❌ Failed to resend OTP",
        title: "Error",
      );
    }
  }


  final RxInt countdown = 60.obs;
  final RxBool isCountingDown = false.obs;


  void startCountdown() {
    isCountingDown.value = true;
    countdown.value = 60;
    update();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
        update();
      } else {
        timer.cancel();
        isCountingDown.value = false;
        update();
      }
    });
  }



///===============Change Password================<>

// RxBool changePasswordLoading = false.obs;
// changePassword(String currentPassword, password ,confirmPassword ) async {
//   changePasswordLoading(true);
//   var body = {
//     "currentPassword": "$currentPassword",
//     "password": "$password",
//     "confirmPassword" : "$confirmPassword"
//   };
//
//   var response =
//   await ApiClient.postData(ApiConstants.changePassword, jsonEncode(body));
//
//   if (response.statusCode == 200 || response.statusCode == 201) {
//     ToastMessageHelper.showToastMessage('Password Changed Successful');
//     print("======>>> successful");
//     changePasswordLoading(false);
//   } else if(response.statusCode == 1){
//     changePasswordLoading(false);
//     ToastMessageHelper.showToastMessage("Server error! \n Please try later");
//   } else {
//     ToastMessageHelper.showToastMessage(response.body['message']);
//     changePasswordLoading(false);
//   }
// }

  ///=============== Delete Account ================<>


// var deleteLoading = false.obs;
// userDelete(BuildContext context) async {
//
//   deleteLoading(true);
//   var response = await ApiClient.deleteData(
//       ApiConstants.deleteEndPoint);
//   if (response.statusCode == 200) {
//     ToastMessageHelper.showToastMessage('Account Delete Successfully');
//     context.pushNamed(AppRoutes.logInScreen);
//   } else {
//     deleteLoading(false);
//   }
//
// }



}