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
  final String? currentTime; // New: current playing time
  final VoidCallback? onTap;
  final VoidCallback? onPlayPause;

  const AudioBookCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    this.isPlaying = false,
    this.currentTime,
    this.onTap,
    this.onPlayPause,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// ===============  Title  Subtitle ====================
            Expanded(
              child: Row(
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
                  Expanded(
                    child: Column(
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
                          text: currentTime ?? subtitle, // Show current time if playing
                          color: isPlaying
                              ? AppColors.primaryColorC79235
                              : AppColors.textColor8C8C8C,
                          fontsize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// ==== Right Side (Play / Pause Button) ====
            GestureDetector(
              onTap: onPlayPause,
              child: Icon(
                isPlaying ? Icons.pause_circle : Icons.play_circle,
                size: 28.sp,
                color: AppColors.primaryColorC79235,
              ),
            ),
          ],
        ),
      ),
    );
  }
}