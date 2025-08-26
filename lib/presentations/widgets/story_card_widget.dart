import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/config/app_routes/app_routes.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';

import '../../core/constants/app_colors.dart';

class StoryCard extends StatelessWidget {
  final String image;
  final String title;
  final String desc;

  const StoryCard({
    super.key,
    required this.image,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 356.w,
      height: 242.h,
      decoration: BoxDecoration(
        color:  Color(0xFF323539),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// ================= Top Image (Cropped with radius) =================
          Container(
            margin: EdgeInsets.only(top: 12.h),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.asset(
                image,
                width: 160.w,
                height: 120.h,
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(height: 8.h),

          /// ================= Title =================
          CustomText(text:
            title,
            textAlign: TextAlign.center,
            color: AppColors.textColorFFFFFF,
            fontsize: 16.sp,
            fontWeight: FontWeight.w500,
          ),

          SizedBox(height: 8.h),

          /// ================= Description =================
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CustomText(text:
              desc,
              textAlign: TextAlign.start,
              color: AppColors.textColor919191,
              fontsize: 12.sp,
              fontWeight: FontWeight.w400,
              maxline: 2,
            ),
          ),
          SizedBox(height: 14.h),
          /// ================= START Button =================
          OutlinedButton(
            onPressed: () {
              context.pushNamed(AppRoutes.nextCreateStoryScreen, extra: {
                "title" : "Create a story",

              });

            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: AppColors.buttonColorE8A533,
                width: 2.w,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.r),
              ),
              padding:
              EdgeInsets.symmetric(horizontal: 45.w, vertical: 12.h),
            ),
            child: CustomText(text:
              "START",
              color: AppColors.textColorFFFFFF,
              fontsize: 14.sp,
              fontWeight: FontWeight.w500,


            ),
          ),
        ],
      ),
    );
  }
}