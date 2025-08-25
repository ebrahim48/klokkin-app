import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/presentations/widgets/custom_app_bar.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import '../../../../../global/custom_assets/assets.gen.dart';
import '../../../../core/config/app_routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';


class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});


  @override
  Widget build(BuildContext context) {
    Map routeData = GoRouterState.of(context).extra as Map;
    return Scaffold(
      appBar: CustomAppBar(title: "${routeData["title"]}"),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60.h),

              CustomText(
                text: 'Enter New Password',
                color: AppColors.textColorFFFFFF,
                fontsize: 20.sp,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 14.h),
              CustomTextField(
                  hintextColor: AppColors.textColor8A8A8A,
                  controller: passWordCtrl,
                  prefixIcon: Assets.icons.lock.svg(),
                  hintText: "New password",
                  isPassword: true),

              SizedBox(height: 10.h),
              CustomText(
                text: 'Confirm Password',
                color: AppColors.textColorFFFFFF,
                fontsize: 20.sp,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 14.h),
              CustomTextField(
                hintextColor: AppColors.textColor8A8A8A,
                controller: confirmPassWordCtrl,
                prefixIcon: Assets.icons.lock.svg(),
                hintText: "Confirm password",
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    Future.delayed(Duration.zero, () => isMatched.value = false);
                    return 'Please enter your confirm password';
                  } else if (passWordCtrl.text == value) {
                    Future.delayed(Duration.zero, () => isMatched.value = true);
                    return null;
                  } else {
                    Future.delayed(Duration.zero, () => isMatched.value = false);
                    return 'Password Not Matching';
                  }
                },
                onChanged: (value) {
                  isMatched.value = passWordCtrl.text == value;
                },
              ),
              Obx(() => Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    text: isMatched.value ? 'Password Matched' : "",
                    color: Colors.green,
                    fontsize: 14.sp,
                  ))),

              SizedBox(height: 340.h),
              CustomButton(
                title: 'Sign up',
                onpress: () {
                  context.pushNamed(AppRoutes.signUpScreen);

                },),


              SizedBox(height: 50.h)
            ],
          ),
        ),
      ),
    );
  }


  RxBool isMatched = false.obs;
  RxBool isObscureConfirmPassword = true.obs;
  toggleIsObscureConfirmPassword() {
    isObscureConfirmPassword.value = !isObscureConfirmPassword.value;
  }

  ismMatchedColor() {
    isMatched.value = !isMatched.value;
  }

  final TextEditingController passWordCtrl = TextEditingController();
  final TextEditingController confirmPassWordCtrl = TextEditingController();



}
