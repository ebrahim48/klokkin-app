import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:klokkin_app/presentations/screens/auth/verification/widget/custom_pin_code_textfield.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../controller/auth_controller.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text.dart';


class VerifyScreen extends StatelessWidget {
  final String screenType;
  final String email;
  final String token;

  VerifyScreen({super.key,required this.screenType, required this.email,required this.token});

  AuthController authController = Get.put(AuthController());


  @override
  Widget build(BuildContext context) {

    return Scaffold(appBar: AppBar(
      title: CustomText(text: "Verification"),
    ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 50.h),
              CustomText(
                  text: "Enter verification code",
                  color: AppColors.textColorFFFFFF,
                  fontsize: 24.sp,
                  fontWeight: FontWeight.w400,
                  bottom: 31.h),

              /// <<< ============><>>>  field  << < ==============>>>

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomPinCodeTextField(textEditingController: otpTEController),
                  SizedBox(height: 31.h),
                  Row(
                    children: [
                      CustomText(
                        textAlign: TextAlign.center,
                          text: 'If you don’t receive a code? ',
                        color: AppColors.textColorFFFFFF,
                        fontWeight: FontWeight.w500,

                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Obx(() =>
                            GestureDetector(

                              onTap: authController.isCountingDown.value
                                  ? null
                                  : () {
                                authController.startCountdown();
                                authController.reSendOtp(email);
                              },
                              child: CustomText(
                                text: authController.isCountingDown.value
                                    ? 'Resend in ${authController.countdown.value}s'
                                    : 'Resend code',
                                color: authController.isCountingDown.value
                                    ? Colors.red
                                    : AppColors.primaryColorC79235,
                                fontsize: 12.sp,
                              ),
                            )),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 365.h),
              /// ============================================ Button ====================================>

              Obx(() =>
                  CustomButton(
                    loading: authController.verfyLoading.value,
                    title: "Verify",
                    onpress: () {
                      if (otpTEController.text.isEmpty) {
                        ToastMessageHelper.showToastMessage("Please enter OTP");
                        return;
                      }

                      authController.verfyEmail(
                        otpTEController.text,
                        email,
                        token,
                        screenType: screenType,
                        type: screenType == "signup" ? "Sign Up" : "Forgot",
                        context: context,
                      );
                    },
                  ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }



  final TextEditingController otpTEController = TextEditingController();



}
