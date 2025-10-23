import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import 'package:share_plus/share_plus.dart';

import '../../controllers/audio_book_controller.dart';
import '../../controllers/audio_controller.dart';
import '../../controllers/home_controller.dart';
import '../../core/constants/app_colors.dart';

class CustomVideoDetailsProgressBar extends StatefulWidget {
  CustomVideoDetailsProgressBar({super.key});

  @override
  State<CustomVideoDetailsProgressBar> createState() => _CustomVideoDetailsProgressBarState();
}

class _CustomVideoDetailsProgressBarState extends State<CustomVideoDetailsProgressBar> {



  String _formatTime(double seconds) {
    final m = (seconds ~/ 60).toString();
    final s = (seconds % 60).toInt().toString().padLeft(2, '0');
    return "$m:$s";
  }


  final AudioBookController controllers = Get.put(AudioBookController());

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final routeData = GoRouterState.of(context).extra as Map;
      storyId = routeData['storyId'];
      homeController.getStorySingle(id: routeData['storyId']);
      controllers.getLibraryStoryData();
    });

  }
  bool _isDownloaded = false;
  final controller = Get.put(AudioController());
  final HomeController homeController = Get.put(HomeController());
  String? storyId;


  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AudioController());

    return Obx(() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ---- Top Row ----
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: controller.togglePlayPause,
                icon: Icon(
                  controller.isPlaying.value
                      ? Icons.pause
                      : Icons.play_arrow,
                  size: 25,
                  color: AppColors.textColorC2C2C2,
                ),
              ),
              SizedBox(width: 5.w),

              CustomText(
                text: controller.formatSpeed(controller.playbackSpeed.value),
                color: AppColors.textColorFFFFFF,
                fontsize: 16.sp,
                fontWeight: FontWeight.w400,
              ),


              SizedBox(width: 10.w),

              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 1.65.h,
                    activeTrackColor: AppColors.textColorFFFFFF,
                    inactiveTrackColor: AppColors.textColor6B6B6B,
                    overlayShape: SliderComponentShape.noOverlay,
                    thumbColor: AppColors.buttonColorE8A533,
                    thumbShape:  RoundSliderThumbShape(
                        enabledThumbRadius: 6.r),
                  ),
                  child: Slider(
                    value: controller.currentTime.value
                        .clamp(0, controller.totalTime.value),
                    min: 0,
                    max: controller.totalTime.value,
                    onChanged: controller.seek,
                  ),
                ),
              ),
              SizedBox(width: 15.w),
              /// ========================================>  Share ===================================>
              GestureDetector(
                onTap: () {
                  final currentStoryId = controllers.libraryStoryData.value.first.id ?? controllers.libraryStoryData.value.first.id ?? '';
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

          /// ---- Bottom Times ----
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(text:
              _formatTime(controller.currentTime.value),
                color: AppColors.textColorFFFFFF,
                fontsize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
              Padding(
                padding: EdgeInsets.only(left: 100.w),
                child: CustomText(
                  text:
                  _formatTime(controller.totalTime.value),
                  color: AppColors.textColorFFFFFF,
                  fontsize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: 28.h),
          CustomText(
            textAlign: TextAlign.start,
            text: controllers.libraryStoryData.first.caption ?? 'N/A',
            color: AppColors.textColorFFFFFF,
            fontsize: 24.sp,
            fontWeight: FontWeight.w500,
            maxline: 2,
          ),
          SizedBox(height: 17.h),
          CustomText(
            textAlign: TextAlign.start,
            text: controllers.libraryStoryData.first.description ?? 'N/A',
            color: AppColors.textColorFFFFFF,
            fontsize: 16.sp,
            fontWeight: FontWeight.w400,
            maxline: 10,
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
    });


  }
}
