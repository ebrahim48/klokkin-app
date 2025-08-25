import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/presentations/screens/auth/verification/widget/custom_pin_code_textfield.dart';
import '../../../../core/config/app_routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text.dart';


class VerifyScreen extends StatelessWidget {
  VerifyScreen({super.key});


  @override
  Widget build(BuildContext context) {
    Map routeData = GoRouterState.of(context).extra as Map;
    return Scaffold(
      appBar: CustomAppBar(title: "${routeData["title"]}"),
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

              /// <<< ============><>>> OTP field  << < ==============>>>

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
                        child: GestureDetector(
                          onTap: isCountingDown.value
                              ? null
                              : () {
                            startCountdown();
                          },
                          child: CustomText(
                            fontWeight: FontWeight.w600,
                            text: isCountingDown.value
                                ? '${'Resend in'} ${countdown.value}s'
                                : ' Resend',
                            color: isCountingDown.value
                                ? AppColors.secondary836531
                                : AppColors.primaryColorC79235,
                            fontsize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 365.h),
              /// ============================================ Button ====================================>

              CustomButton(title: "Verify", onpress: () {
                context.pushNamed(AppRoutes.resetPasswordScreen, extra: {
                  "title" : "New Password",

                });
                // Get.toNamed(AppRoutes.optScreen, arguments: {"screenType" : "Sign up"});
                // context.pushNamed(AppRoutes.resetPasswordScreen);
              }),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }



  final TextEditingController otpTEController = TextEditingController();

  final RxInt countdown = 60.obs;
  final RxBool isCountingDown = false.obs;

  void startCountdown() {
    isCountingDown.value = true;
    countdown.value = 60;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        timer.cancel();
        isCountingDown.value = false;
      }
    });
  }

}
