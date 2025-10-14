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
  final int index;
  final String title;
  final String duration;
  final String imagePath;
  final String videoPath;
  final VoidCallback? onTap;

  const WorkCard({
    super.key,
    required this.index,
    required this.title,
    required this.duration,
    required this.imagePath,
    required this.videoPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WorkCardController>();

    return GestureDetector(
      onTap: () async {
        await controller.setVideoPath(index, videoPath);
        if (onTap != null) onTap!();
      },
      child: Container(
        width: 140.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: GetBuilder<WorkCardController>(
            builder: (_) {
              final videoCtrl = controller.getController(index);
              final isInit = controller.isInitialized(index);
              final isPlaying = controller.isPlaying(index);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        if (isInit && videoCtrl != null)
                          AspectRatio(
                            aspectRatio: videoCtrl.value.aspectRatio,
                            child: VideoPlayer(videoCtrl),
                          )
                        else
                          Center(
                            child: CustomNetworkImage(
                              imageUrl: imagePath,
                              borderRadius: BorderRadius.zero,
                            ),
                          ),

                        // Title Overlay
                        Positioned(
                          top: 16,
                          left: 8,
                          right: 8,
                          child: Container(
                            height: 50.h,
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            color: AppColors.textColor000000.withOpacity(0.2),
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

                        // Play & Duration Overlay
                        Positioned(
                          bottom: 8.h,
                          left: 8.w,
                          right: 8.w,
                          child: Container(
                            height: 34.h,
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            color: AppColors.textColor000000.withOpacity(0.1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () => controller.togglePlayPause(index),
                                  child: Container(
                                    width: 32.w,
                                    height: 32.w,
                                    decoration: BoxDecoration(
                                      color: AppColors.textColorFFFFFF,
                                      borderRadius: BorderRadius.circular(50.r),
                                    ),
                                    child: Icon(
                                      isPlaying ? Icons.pause : Icons.play_arrow,
                                      color: Colors.orange,
                                      size: 20.sp,
                                    ),
                                  ),
                                ),
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
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
