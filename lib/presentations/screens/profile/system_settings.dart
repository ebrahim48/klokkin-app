import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/config/app_routes/app_routes.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import 'package:klokkin_app/presentations/widgets/custom_button.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';

import '../../../controllers/home_controller.dart';

class SystemSettingScreen extends StatefulWidget {
  const SystemSettingScreen({super.key});

  @override
  State<SystemSettingScreen> createState() => _SystemSettingScreenState();
}

class _SystemSettingScreenState extends State<SystemSettingScreen> {

  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: 'System Settings',
          fontsize: 24.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryColorC79235,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account and security section
              GestureDetector(
                onTap: _showDeleteDialog, // Trigger the delete confirmation dialog
                child: Container(
                  width: 390.w,
                  height: 146.h,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: AppColors.textColorFFFFFF,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.textColor8C8C8C.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: Offset(0, 2), // Shadow position
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Account and security',
                        color: AppColors.primaryColorC79235,
                        fontsize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      Divider(
                        color: AppColors.primaryColorC79235.withOpacity(0.4),
                        height: 20.h,
                      ),
                      Row(
                        children: [
                          CustomText(
                            text: 'Delete Account',
                            color: AppColors.primaryColorC79235,
                            fontsize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          const Spacer(),
                          CustomText(
                            text: 'This cannot be undone',
                            color: AppColors.textColor8C8C8C,
                            fontsize: 12.sp,
                            fontWeight: FontWeight.w300,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16.sp,
                            color: AppColors.primaryColorC79235,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),


              SizedBox(height: 400.h,),

              CustomButton(title: 'Logout',
                onpress: () {
                  _showSignOutDialog();

              },)
            ],
          ),
        ),
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          title: Row(
            children: [
              CustomText(
                text: 'Are you sure to ',
                color: AppColors.textColorFFFFFF,
                fontsize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
              CustomText(
                text: ' sign out?',
                color: AppColors.primaryColorC79235,
                fontsize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Confirm Button
                TextButton(
                  onPressed: () {
                   context.pushNamed(AppRoutes.logInScreen);
                  },
                  child: CustomText(
                    text: 'Confirm',
                    color: AppColors.primaryColorC79235,
                    fontsize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 20.w),
                // Cancel Button
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: CustomText(
                    text: 'Cancel',
                    color: AppColors.textColor8C8C8C,
                    fontsize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
          backgroundColor: AppColors.textColor323539,
          contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          actionsPadding: EdgeInsets.only(bottom: 16.h),
        );
      },
    );
  }


  void _showDeleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          title: CustomText(
            text: 'Are you sure to delete your account?',
            color: AppColors.textColorFFFFFF,
            fontsize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Confirm Button
                TextButton(
                  onPressed: () {

                    homeController.deleteProfile(context);

                  },
                  child: CustomText(
                    text: 'Confirm',
                    color: AppColors.primaryColorC79235,
                    fontsize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 20.w), // Space between buttons
                // Cancel Button
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog without doing anything
                  },
                  child: CustomText(
                    text: 'Cancel',
                    color: AppColors.textColor8C8C8C,
                    fontsize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
          backgroundColor: AppColors.textColor323539,
          contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          actionsPadding: EdgeInsets.only(bottom: 16.h),
        );
      },
    );
  }


}
