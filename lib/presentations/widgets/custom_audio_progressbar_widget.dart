import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

import '../../controllers/audio_controller.dart';
import '../../controllers/home_controller.dart';
import '../../core/constants/app_colors.dart';
import 'custom_loader.dart';
import 'custom_network_image.dart';
import 'custom_text.dart';

class AudioProgressBar extends StatefulWidget {
  const AudioProgressBar({super.key});

  @override
  State<AudioProgressBar> createState() => _AudioProgressBarState();
}

class _AudioProgressBarState extends State<AudioProgressBar> {


  final controller = Get.put(AudioController());
  final HomeController homeController = Get.put(HomeController());
  String? storyId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final routeData = GoRouterState.of(context).extra as Map;
      storyId = routeData['storyId'];
      homeController.getStorySingle(id: routeData['storyId']);
    });
  }

  String _formatTime(double seconds) {
    final m = (seconds ~/ 60).toString();
    final s = (seconds % 60).toInt().toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {

      final story = homeController.storySingle.value;
      if (homeController.getStorySingleLoading.value) {
        return const Center(child: CustomLoader());
      }

      if (story == null) {
        return Center(
          child: CustomText(
            text: "Story Single Unavailable",
            textAlign: TextAlign.center,
            color: AppColors.textColorC2C2C2,
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Media (Video or Image)
          Stack(
            children: [
              Obx(() {
                if (controller.isVideo.value) {
                  if (controller.isInitialized.value) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: AspectRatio(
                        aspectRatio: controller.videoController.value.aspectRatio,
                        child: VideoPlayer(controller.videoController),
                      ),
                    );
                  } else {
                    return  const Center(child: CustomLoader());
                  }
                } else {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: CustomNetworkImage(
                      imageUrl: (story.mediaUrl != null && story.mediaUrl!.isNotEmpty)
                          ? story.mediaUrl!.first
                          : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                      borderRadius: BorderRadius.circular(8.r),
                      height: 200.h,
                      width: double.infinity,
                    ),
                  );
                }
              }),


              // if (controller.isVideo.value)
              //   Align(
              //     alignment: Alignment.center,
              //     child: Obx(() => IconButton(
              //       icon: Icon(
              //         controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
              //         size: 40.sp,
              //         color: Colors.white,
              //       ),
              //       onPressed: controller.togglePlayPause,
              //     )),
              //   ),
            ],
          ),

          SizedBox(height: 16.h),

          // Controls Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  if (story.mediaUrl != null && story.mediaUrl!.isNotEmpty) {
                    bool isVideo = story.mediaUrl!.first.endsWith(".mp4") ||
                        story.mediaUrl!.first.endsWith(".m3u8");
                    controller.setMediaPath(story.mediaUrl!.first, video: isVideo);
                  }
                  controller.togglePlayPause();
                },
                icon: Obx(() => Icon(
                  controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                  size: 25,
                  color: AppColors.textColorC2C2C2,
                )),
              ),
              SizedBox(width: 5.w),

              /// ======================================> Speed ==================================>
              Obx(() => CustomText(
                text: controller.formatSpeed(controller.playbackSpeed.value),
                color: AppColors.textColorFFFFFF,
                fontsize: 16.sp,
                fontWeight: FontWeight.w400,
              )),
              SizedBox(width: 10.w),

              // Slider
              Expanded(
                child: Obx(() {
                  double value = controller.isVideo.value && controller.isInitialized.value
                      ? controller.videoController.value.position.inSeconds.toDouble()
                      : controller.currentTime.value;

                  double max = controller.isVideo.value && controller.isInitialized.value
                      ? controller.videoController.value.duration.inSeconds.toDouble()
                      : controller.totalTime.value;

                  return SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 1.65.h,
                      activeTrackColor: AppColors.textColorFFFFFF,
                      inactiveTrackColor: AppColors.textColor6B6B6B,
                      overlayShape: SliderComponentShape.noOverlay,
                      thumbColor: AppColors.buttonColorE8A533,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
                    ),
                    child: Slider(
                      value: value.clamp(0, max),
                      min: 0,
                      max: max,
                      onChanged: controller.seek,
                    ),
                  );
                }),
              ),
              SizedBox(width: 15.w),

              /// ========================================>  Share ===================================>
              GestureDetector(
                onTap: () {
                  final currentStoryId = story.id ?? story.id ?? '';
                  if (currentStoryId.isNotEmpty) {
                    homeController.share(currentStoryId);
                    Share.share(
                      'Check this out: https://jakuan8080.syedbipul.me/api/v1/story/story/$currentStoryId',
                      subject: controller.isVideo.value ? 'Share Video' : 'Share Audio',
                    );
                  }
                },
                child: SvgPicture.asset(
                  "assets/icons/share.svg",
                  width: 24.w,
                  height: 24.h,
                  color: AppColors.textColorC2C2C2,
                ),
              ),


            ],
          ),

          // Bottom Times
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: _formatTime(controller.currentTime.value),
                color: AppColors.textColorFFFFFF,
                fontsize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
              CustomText(
                text: _formatTime(controller.totalTime.value),
                color: AppColors.textColorFFFFFF,
                fontsize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
          SizedBox(height: 32.h),

          // Caption & Description
          CustomText(
            textAlign: TextAlign.start,
            text: story.caption ?? 'N/A',
            color: AppColors.textColorFFFFFF,
            fontsize: 24.sp,
            fontWeight: FontWeight.w500,
            maxline: 2,
          ),
          SizedBox(height: 17.h),

          CustomText(
            textAlign: TextAlign.start,
            text: story.description ?? "N/A",
            color: AppColors.textColorFFFFFF,
            fontsize: 16.sp,
            fontWeight: FontWeight.w400,
            maxline: 10,
          ),
          SizedBox(height: 17.h),

          // Tags Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8.w,
                  children: (story.tags ?? [])
                      .map((tag) => GestureDetector(
                    onTap: () => print("$tag tapped"),
                    child: CustomText(
                      text: tag,
                      color: AppColors.textColor2165DF,
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ))
                      .toList(),
                ),
              ),

              // Download Icon (optional functionality)
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
        ],
      );
    });
  }
}
