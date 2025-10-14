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
  final String storyId;
  final VoidCallback? onTap;

  const EveryStoryCard({
    super.key,
    required this.caption,
    required this.imagePath,
    required this.storyId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 235.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          color: AppColors.textColorFFFFFF,
        ),



        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    // Video/Image display
                    Obx(() {
                      if (homeController.isInitializedStates[storyId] == true) {
                        final controller = homeController.videoControllers[storyId];
                        if (controller != null) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(6.r),
                            child: AspectRatio(
                              aspectRatio: controller.value.aspectRatio,
                              child: VideoPlayer(controller),
                            ),
                          );
                        }
                      }
                      return Center(
                        child: CustomNetworkImage(
                          imageUrl: imagePath,
                          borderRadius: BorderRadius.zero,
                        ),
                      );
                    }),

                    // Play/Pause button
                    Align(
                      alignment: Alignment.center,
                      child: Obx(() => IconButton(
                        icon: Icon(
                          homeController.playStates[storyId] == true
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 40.sp,
                          color: Colors.white,
                        ),
                        onPressed: () => homeController.togglePlayPause(storyId),
                      )),
                    ),
                  ],
                ),
              ),

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
