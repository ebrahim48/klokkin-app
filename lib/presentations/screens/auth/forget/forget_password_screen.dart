import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import '../../../../../global/custom_assets/assets.gen.dart';
import '../../../../core/config/app_routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../controller/auth_controller.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';


class ForgetPasswordScreen extends StatefulWidget {
  ForgetPasswordScreen({super.key,required this.email});

  final String email;
  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();


}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {


  @override
  void initState() {
    print("====================${widget.email}");
    setState(() {
      emailCtrl.text = widget.email;
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: "Forget password"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 70.h),

              CustomText(
                text: 'Enter Email Address',
                fontsize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textColorFFFFFF,

              ),
              SizedBox(height: 8.h),
              CustomTextField(
                  hintextColor: AppColors.textColor8A8A8A,
                  controller: emailCtrl,
                  hintText: "Email",
                  prefixIcon: Assets.icons.email.svg(),
                  isEmail: true),

              GestureDetector(
                onTap: () {
                  context.pushNamed(AppRoutes.logInScreen);
                },
                child: Row(
                  children: [
                    CustomText(
                      text: 'Back to',
                      fontsize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColorFFFFFF,
                    ),
                    SizedBox(width: 4.w,),
                    CustomText(
                      text: 'sign in',
                      fontsize: 16.sp,
                      fontWeight: FontWeight.w400,

                    ),
                  ],
                ),
              ),


              SizedBox(height: 50.h),

              /// ============================================ Button ====================================>

              Obx(()=>
               CustomButton(
                   loading: authController.forgotLoading.value,
                    title: "Send",
                    onpress: () {
                      if(_logKey.currentState?.validate()??true){
                        authController.handleForgot(
                            emailCtrl.text,
                            "forgot",
                            context: context);
                      }

                }),
              ),
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
              SizedBox(height: 50.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Assets.icons.facebook.svg(width: 54.w, height: 50.h),
                  SizedBox(width: 30.h),
                  Assets.icons.google.svg(width: 54.w, height: 50.h),
                ],
              ),



              SizedBox(height: 90.h),

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

  final TextEditingController emailCtrl = TextEditingController();

  AuthController authController = Get.find<AuthController>();

  final GlobalKey<FormState> _logKey = GlobalKey<FormState>();
}
