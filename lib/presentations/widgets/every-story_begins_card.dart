import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:klokkin_app/controllers/home_controller.dart';
import 'package:video_player/video_player.dart';
import '../../core/constants/app_colors.dart';
import 'custom_text.dart';
import 'custom_network_image.dart';

class EveryStoryCard extends StatelessWidget {

  final String caption;
  final String imagePath;
  final VoidCallback? onTap;

  const EveryStoryCard({
    super.key,
    required this.caption,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 264.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          color: AppColors.textColorFFFFFF,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// =============================> Image with overlay ========================>

              Expanded(
                child: Stack(
                  children: [

                    Obx(() {
                      if (controller.isInitialized.value) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(6.r),
                          child: AspectRatio(
                            aspectRatio: controller.videoController.value.aspectRatio,
                            child: VideoPlayer(controller.videoController),
                          ),
                        );
                      } else {
                        return CustomNetworkImage(
                          imageUrl: imagePath,
                          borderRadius: BorderRadius.zero,
                        );
                      }
                    }),

                    /// Play/Pause overlay
                    Align(
                      alignment: Alignment.center,
                      child: Obx(() => IconButton(
                        icon: Icon(
                          controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                          size: 40.sp,
                          color: Colors.white,
                        ),
                        onPressed: controller.togglePlayPause,
                      )),
                    ),
                  ],
                ),
              ),



              // Expanded(
              //   child: Stack(
              //     children: [
              //       /// Background image
              //       Positioned.fill(
              //         child: CustomNetworkImage(
              //           imageUrl: imagePath,
              //           borderRadius: BorderRadius.zero,
              //         ),
              //       ),
              //
              //       /// Center overlay (Play/Pause + Duration)
              //       Align(
              //         alignment: Alignment.center,
              //         child: ClipRRect(
              //           borderRadius: BorderRadius.circular(6.r),
              //           child: Container(
              //             height: 40.h,
              //             padding: EdgeInsets.symmetric(horizontal: 12.w),
              //             child: Row(
              //               mainAxisSize: MainAxisSize.min,
              //               children: [
              //                 /// Play/Pause button
              //                 Obx(() => Container(
              //                   width: 40.w,
              //                   height: 40.w,
              //                   decoration: BoxDecoration(
              //                     color: AppColors.textColorFFFFFF,
              //                     borderRadius: BorderRadius.circular(50.r),
              //                   ),
              //                   child: IconButton(
              //                     icon: Icon(
              //                       controller.isPlaying.value
              //                           ? Icons.pause
              //                           : Icons.play_arrow,
              //                       color: Colors.orange,
              //                       size: 25.sp,
              //                     ),
              //                     onPressed: controller.togglePlayPause,
              //                   ),
              //                 )),
              //
              //                 SizedBox(width: 12.w),
              //
              //
              //               ],
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),


              /// Bottom caption
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8.w),
                color: AppColors.primaryColorC79235,
                child: CustomText(
                  textAlign: TextAlign.start,
                  text: caption,
                  fontsize: 12.sp,
                  maxline: 2,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor000000,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
