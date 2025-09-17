import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import '../../../../../global/custom_assets/assets.gen.dart';
import '../../../../core/config/app_routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../controller/auth_controller.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';


class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  AuthController authController = Get.put(AuthController());
  final GlobalKey<FormState> _logKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Assets.images.logo.image(height: 175.h, width: 175.w)),
              SizedBox(height: 25.h),

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

              GestureDetector(
                onTap: (){
                  if(emailCtrl.text.isEmpty){
                    ToastMessageHelper.showToastMessage("Please enter your email",title: 'Attention');
                  }else{
                    context.pushNamed(AppRoutes.forgetPasswordScreen, extra: emailCtrl.text);
                  }
                },
                child: CustomText(
                  text: 'Forgot Password?',
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),

              SizedBox(height: 35.h),

              /// ============================================ Button ====================================>

              Obx(()=>
                  CustomButton(
                      loading: authController.logInLoading.value,
                      title: "Sign in", onpress: (){
                    if (_logKey.currentState?.validate()?? true) {
                      authController.handleLogIn(
                          emailCtrl.text, passWordCtrl.text.trim(), context: context);
                    }

                  }),),


              SizedBox(height: 22.h),
              /// ===================================> Divider =============================>
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      margin: EdgeInsets.only(left: 7.w),
                      decoration:  const BoxDecoration(
                        color: AppColors.textColorCFCFCF
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: CustomText(
                      text: 'Or',
                      color: AppColors.textColor8B8B8B,
                      fontsize: 20.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      margin: EdgeInsets.only(right: 7.w),
                      decoration: const BoxDecoration(
                          color: AppColors.textColorCFCFCF
                      ),
                    ),
                  ),
                ],
              ),


              /// =================================> Social Icon ===========================>
              SizedBox(height: 90.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Assets.icons.facebook.svg(width: 54.w, height: 50.h),
                  SizedBox(width: 30.h),
                  Assets.icons.google.svg(width: 54.w, height: 50.h),
                ],
              ),



              SizedBox(height: 50.h),

              Padding(
                padding: EdgeInsets.only(left: 25.w, right: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: AppColors.textColorFFFFFF,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        children: const [
                          TextSpan(text: 'Don’t have an account? '),
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
                            text: ' Sign up',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.pushNamed(AppRoutes.signUpScreen);
                              },
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.only(left: 25.w, right: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: AppColors.textColor8B8B8B,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        children: const [
                          TextSpan(text: 'By signing up, you agree to our '),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: AppColors.buttonColorE8A533,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          TextSpan(
                            text: ' Terms of ',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.pushNamed(AppRoutes.termsServicesScreen);
                              },
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
              SizedBox(height: 5.h),
              Padding(
                padding: EdgeInsets.only(left: 25.w, right: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: AppColors.buttonColorE8A533,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        children: const [
                          TextSpan(text: 'Service '),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: AppColors.textColor8B8B8B,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          TextSpan(
                            text: ' and ',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.pushNamed(AppRoutes.signUpScreen);
                              },
                          ),

                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: AppColors.buttonColorE8A533,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          TextSpan(
                            text: ' Privacy Policy ',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.pushNamed(AppRoutes.privacyPolicyScreen);
                              },
                          ),

                        ],
                      ),
                    ),

                  ],
                ),
              ),

              SizedBox(height: 50.h)
            ],
          ),
        ),
      ),
    );
  }



  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passWordCtrl = TextEditingController();




}
