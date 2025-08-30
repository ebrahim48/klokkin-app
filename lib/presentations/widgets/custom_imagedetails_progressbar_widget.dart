import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';

import '../../controllers/audio_controller.dart';
import '../../core/constants/app_colors.dart';

class CustomImageDetailsProgressBar extends StatelessWidget {
  CustomImageDetailsProgressBar({super.key});


  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AudioController());


      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 28.h),
          CustomText(
            textAlign: TextAlign.start,
            text: 'Bright Minds Gather to Shape the Future Together',
            color: AppColors.textColorFFFFFF,
            fontsize: 24.sp,
            fontWeight: FontWeight.w500,
            maxline: 2,
          ),
          SizedBox(height: 17.h),
          CustomText(
            textAlign: TextAlign.start,
            text: 'A small group gathers around a wooden table in a bright, modern workspace. Laughter mixes with focused conversation as ideas flow freely. Sunlight streams through the large windows, warming the atmosphere. It feels like more than just a meeting—it’s a moment where stories are shared, connections are built, and new chapters begin.',
            color: AppColors.textColorFFFFFF,
            fontsize: 16.sp,
            fontWeight: FontWeight.w400,
            maxline: 10,
          ),
          SizedBox(height: 17.h),
          CustomText(
            textAlign: TextAlign.start,
            text: 'Post',
            color: AppColors.textColorFFFFFF,
            fontsize: 14.sp,
            fontWeight: FontWeight.w400,
          ),

          CustomText(
            textAlign: TextAlign.start,
            text: 'December 14, 2024',
            color: AppColors.textColor919191,
            fontsize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(height: 17.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8.w,
                  children: controller.hashtags.map((tag) {
                    return GestureDetector(
                      onTap: () {
                        print("$tag tapped");
                      },
                      child: CustomText(text:
                      tag,
                        color: AppColors.textColor2165DF, fontsize: 14.sp, fontWeight: FontWeight.w400,
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Download Icon
              GestureDetector(
                onTap: () {

                },
                child: SvgPicture.asset(
                  "assets/icons/downloadSimple.svg",
                  width: 24.w,
                  height: 24.h,
                  color: AppColors.primaryColorC79235,
                ),
              ),
            ],
          ),
          SizedBox(height: 100.h),

        ],
      );
    }


}
