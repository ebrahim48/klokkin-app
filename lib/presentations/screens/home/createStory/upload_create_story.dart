import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import 'package:klokkin_app/presentations/widgets/custom_app_bar.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';

class UploadCreateStoryScreen extends StatefulWidget {
  UploadCreateStoryScreen({super.key});

  @override
  State<UploadCreateStoryScreen> createState() => _UploadCreateStoryScreenState();
}

class _UploadCreateStoryScreenState extends State<UploadCreateStoryScreen> {
  @override
  Widget build(BuildContext context) {
    Map routeData = GoRouterState.of(context).extra as Map;
    return Scaffold(
      appBar: CustomAppBar(title: "${routeData["title"]}"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50.h),

            // Title Text
            CustomText(
              textAlign: TextAlign.start,
              text: "Bring your story to life with upload files – upload up to 5, 20 MB each.",
              fontsize: 16.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textColorFFFFFF,
              maxline: 2,
            ),
            SizedBox(height: 12.h),

            // Centered Upload Icon Container
            Container(
              width: 390.w,
              height: 244.h,
              margin: EdgeInsets.only(top: 16.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AppColors.textColorFFFFFF,
                  width: 0.56.w,
                ),
              ),
              child: Stack(
                children: [
                  // Centered Upload Icon
                  Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'assets/icons/upload.svg',
                      width: 40.w,
                      height: 40.h,
                    ),
                  ),

                  CustomText(text: 'Drag and drop files to upload',),
                  Align(
                    alignment: Alignment.center,
                    child: Positioned(
                      bottom: 20.h,
                      child: Container(
                        width: 150.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.r),
                          border: Border.all(
                            color: AppColors.textColor000000,
                            width: 1.w, // Border width
                          ),
                        ),
                        child: Center(
                          child: CustomText(
                            text: "Select Files",
                            color: AppColors.textColor000000,
                            fontsize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Positioned(
                      bottom: 20.h,
                      child: Container(
                        width: 150.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.r),
                          border: Border.all(
                            color: AppColors.textColor000000,
                            width: 1.w, // Border width
                          ),
                        ),
                        child: Center(
                          child: CustomText(
                            text: "Upload",
                            color: AppColors.textColor000000,
                            fontsize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Positioned(
                      bottom: 20.h,
                      child: Container(
                        width: 150.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.r),
                          border: Border.all(
                            color: AppColors.textColor000000,
                            width: 1.w, // Border width
                          ),
                        ),
                        child: Center(
                          child: CustomText(
                            text: "Take photo or video",
                            color: AppColors.textColor000000,
                            fontsize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
