import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:video_player/video_player.dart';
import '../../controllers/work_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../global/custom_assets/assets.gen.dart';
import 'custom_network_image.dart';
import 'custom_text.dart';

class VideoStoryCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final String timestamp;
  final String readingTime;
  final VoidCallback? onTap;
  final String videoPath;

  const VideoStoryCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.timestamp,
    required this.readingTime,
    required this.videoPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // ✅ Direct tap করলে navigate করবে
      child: Container(
        width: 268.w,
        height: 280.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: AppColors.backgColor20272E,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// =============================> Image + Play Icon ========================>
              Stack(
                children: [
                  // ✅ শুধু thumbnail image দেখান
                  Container(
                    width: 268.w,
                    height: 180.h,
                    child: CustomNetworkImage(
                      imageUrl: imagePath,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),

                  /// Play Icon Centered
                  Positioned.fill(
                    child: Center(
                      child: Assets.icons.play.svg(
                        width: 48.w,
                        height: 48.h,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.h),

              // =====================> Title and Info =====================>
              Padding(
                padding: EdgeInsets.only(left: 2.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      textAlign: TextAlign.start,
                      text: title,
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColorDCDCDC,
                    ),
                    SizedBox(height: 6.h),

                    Padding(
                      padding: EdgeInsets.all(3.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: timestamp,
                            fontsize: 12.sp,
                            fontWeight: FontWeight.w300,
                            color: AppColors.textColor919191,
                          ),
                          SizedBox(width: 8.w),
                          CustomText(
                            text: '• $readingTime',
                            fontsize: 12.sp,
                            fontWeight: FontWeight.w300,
                            color: AppColors.textColor919191,
                          ),
                          const Spacer(),
                          Assets.icons.downloadSimple.svg(
                            color: AppColors.primaryColorC79235,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 6.h),
            ],
          ),
        ),
      ),
    );
  }
}
