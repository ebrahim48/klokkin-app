import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../../global/custom_assets/assets.gen.dart';
import '../../../../core/config/app_routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/custom_text_field.dart';


class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Assets.images.logo.image(height: 175.h, width: 175.w)),
              SizedBox(height: 16.h),
              CustomText(
                 textAlign: TextAlign.start,
                  text: "Create your account",
                  color: AppColors.textColorFFFFFF,
                  fontWeight: FontWeight.w500,
                  fontsize: 20.sp,
                  bottom: 8.h),
              CustomText(
                  textAlign: TextAlign.start,
                  text: "Join now to relive and share your memories",
                  color: AppColors.textColorFFFFFF,
                  fontWeight: FontWeight.w400,
                  fontsize: 12.sp,
                  bottom: 20.h),

              /// <<< ============><>>> sign up text flied  << < ==============>>>
              CustomTextField(
                  hintextColor: AppColors.textColor8A8A8A,
                  controller: nameCtrl,
                  hintText: "Full name",
                  prefixIcon: Assets.icons.nameProfile.svg()),


              CustomTextField(
                  hintextColor: AppColors.textColor8A8A8A,
                  controller: phoneCtrl,
                  hintText: "Phone Number",
                  prefixIcon: Assets.icons.phone.svg()),




              CustomTextField(
                  hintextColor: AppColors.textColor8A8A8A,
                  controller: emailCtrl,
                  hintText: "Email",
                  prefixIcon: Assets.icons.email.svg(),
                  isEmail: true),



              CustomTextField(
                  hintextColor: AppColors.textColor8A8A8A,
                  controller: passWordCtrl,
                  prefixIcon: Assets.icons.lock.svg(),
                  hintText: "Password",
                  isPassword: true),
              CustomTextField(
                hintextColor: AppColors.textColor8A8A8A,
                controller: confirmPassWordCtrl,
                prefixIcon: Assets.icons.lock.svg(),
                hintText: "Confirm Password",
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


              SizedBox(height: 20.h),

              /// ====================================> Check Box ========================>

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                        () => Transform.translate(
                      offset: const Offset(0, -18),
                      child: Checkbox(
                        activeColor: AppColors.primaryColorC79235,
                        checkColor: AppColors.textColorFFFFFF,
                        side: BorderSide(color: AppColors.primaryColorC79235,width: 2.w),
                        value: isChecked.value,
                        onChanged: (value) {
                          isChecked.value = value!;
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: AppColors.textColorFFFFFF,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400
                        ),
                        children: [
                          const TextSpan(text: 'Are You Agree to Our '),
                          TextSpan(
                            text: 'Terms of service',
                            style:  TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12.sp,
                              color: AppColors.primaryColorC79235,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Open Terms of Service
                              },
                          ),
                          TextSpan(
                            text: '?',
                            style:  TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textColorFFFFFF,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32.h),

              /// ============================================ Button ====================================>

              CustomButton(title: "Sign up", onpress: () {
                context.pushNamed(AppRoutes.logInScreen);
                // Get.toNamed(AppRoutes.optScreen, arguments: {"screenType" : "Sign up"});
              }),

              SizedBox(height: 16.h),

              Padding(
                padding: EdgeInsets.only(left: 25.w, right: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: AppColors.textColorFFFFFF,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        children: const [
                          TextSpan(text: 'Already have an Account? '),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: AppColors.primaryColorC79235,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign in',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.pushNamed(AppRoutes.logInScreen);
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 70.h)
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

  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController passWordCtrl = TextEditingController();
  final TextEditingController confirmPassWordCtrl = TextEditingController();
  RxBool isChecked = false.obs;



}
