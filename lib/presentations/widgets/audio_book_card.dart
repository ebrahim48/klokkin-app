import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';

import 'custom_network_image.dart';

class AudioBookCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final bool isPlaying;
  final VoidCallback? onTap;

  const AudioBookCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    this.isPlaying = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 390.w,
        height: 80.h,
        decoration: BoxDecoration(
          color: AppColors.textColor323539,
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// ===============  Title  Subtitle ====================
              Row(
                children: [
                  /// Circle Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40.r),
                    child: CustomNetworkImage(
                      imageUrl: imagePath,
                      borderRadius: BorderRadius.zero,
                      width: 64.w,
                      height: 64.h,
                    ),
                  ),
                  SizedBox(width: 12.w),

                  /// Title + Subtitle
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: title,
                        color: AppColors.textColorFFFFFF,
                        fontsize: 12.sp,
                        fontWeight: FontWeight.w600,
                        textOverflow: TextOverflow.ellipsis,
                        maxline: 2,
                      ),
                      SizedBox(height: 4.h),
                      CustomText(
                        text: subtitle,
                        color: AppColors.textColor8C8C8C,
                        fontsize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ],
              ),

              /// ==== Right Side (Play / Pause Button) ====
              Icon(
                isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                size: 28.sp,
                color: AppColors.primaryColorC79235,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
