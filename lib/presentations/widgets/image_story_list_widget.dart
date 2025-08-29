import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';

class ImageListCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String meta;
  final String hashtags;
  final String imagePath;
  final bool isPlaying;
  final VoidCallback? onTap;

  const ImageListCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.meta,
    required this.hashtags,
    required this.imagePath,
    this.isPlaying = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// ==== Left Side ====
          Row(
            children: [
              /// Image
              Container(
                width: 124.w,
                height: 90.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 12.w),

              /// Texts
              SizedBox(
                width: 210.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: title,
                      color: AppColors.textColorDCDCDC,
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w500,

                    ),
                    SizedBox(height: 4.h),
                    CustomText(
                      textAlign: TextAlign.start,
                      text: subtitle,
                      color: AppColors.textColor919191,
                      fontsize: 12.sp,
                      fontWeight: FontWeight.w400,
                      maxline: 2,

                    ),
                    SizedBox(height: 10.h),
                    CustomText(
                      text: meta,
                      color: AppColors.textColor8C8C8C,
                      fontsize: 11.sp,
                      fontWeight: FontWeight.w300,
                    ),
                    SizedBox(height: 4.h),
                    CustomText(
                      text: hashtags,
                      color: AppColors.textColor2165DF,
                      fontsize: 11.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}