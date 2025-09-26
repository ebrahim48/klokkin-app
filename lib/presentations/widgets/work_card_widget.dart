import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../controllers/work_controller.dart';
import '../../core/constants/app_colors.dart';
import 'custom_network_image.dart';
import 'custom_text.dart';

class WorkCard extends StatelessWidget {
  final String title;
  final String duration;
  final String imagePath;
  final String videoPath;
  final VoidCallback? onTap;

  const WorkCard({
    super.key,
    required this.title,
    required this.duration,
    required this.imagePath,
    required this.videoPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WorkCardController());
    controller.setVideoPath(videoPath);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// =============================> Image/Video with overlay ========================>
              Expanded(
                child: Stack(
                  children: [
                    /// Show video if initialized, else fallback image
                    Obx(() {
                      if (controller.isInitialized.value) {
                        return Stack(
                          children: [

                            ClipRRect(
                              borderRadius: BorderRadius.circular(6.r),
                              child: AspectRatio(
                                aspectRatio:
                                controller.videoController.value.aspectRatio,
                                child: VideoPlayer(controller.videoController),
                              ),
                            ),
                          ],
                        );
                      } else {

                        return CustomNetworkImage(
                          imageUrl: imagePath,
                          borderRadius: BorderRadius.zero,
                        );
                      }
                    }),

                    /// Top overlay: Title + Download
                    Positioned(
                      top: 16,
                      left: 8,
                      right: 8,
                      child: Container(
                        height: 50.h,
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        decoration: BoxDecoration(
                          color: AppColors.textColor000000.withOpacity(0.2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CustomText(
                                textAlign: TextAlign.start,
                                text: title,
                                color: AppColors.textColorFFFFFF,
                                fontsize: 12.sp,
                                fontWeight: FontWeight.w900,
                                maxline: 2,
                              ),
                            ),
                            SvgPicture.asset(
                              "assets/icons/downloadSimple.svg",
                              width: 24.w,
                              height: 24.h,
                              color: AppColors.textColorFFFFFF,
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// Bottom overlay: Play button + Duration
                    Positioned(
                      bottom: 8.h,
                      left: 8.w,
                      right: 8.w,
                      child: ClipRRect(
                        child: Container(
                          height: 34.h,
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          color: AppColors.textColor000000.withOpacity(0.1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /// Play/Pause button
                              Obx(() => Container(
                                width: 32.w,
                                height: 32.w,
                                decoration: BoxDecoration(
                                  color: AppColors.textColorFFFFFF,
                                  borderRadius: BorderRadius.circular(50.r),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    controller.isPlaying.value
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.orange,
                                    size: 20.sp,
                                  ),
                                  onPressed: controller.togglePlayPause,
                                ),
                              )),

                              /// Duration text
                              CustomText(
                                text: duration,
                                color: AppColors.textColorFFFFFF,
                                fontsize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}
