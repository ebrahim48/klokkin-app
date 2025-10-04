import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import '../../../../controllers/profile_controller.dart';
import '../../../widgets/custom_text.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  ProfileController profileController = Get.put(ProfileController());

  void initState() {
    super.initState();
    profileController.privacyPolicy();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: CustomText(
          text: 'Privacy Policy',
          fontsize:24.sp,
          color: AppColors.primaryColorC79235,
          fontWeight: FontWeight.w400,
        ),
        leading: IconButton(onPressed: () => context.pop() , icon: Icon(Icons.arrow_back,size: 22.r, color: AppColors.textColorFFFFFF,)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      textAlign: TextAlign.start,
                      text: profileController.terms.value,
                      fontsize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColorFFFFFF,
                      maxline: 10,
                    ),
                    SizedBox(height: 15.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
