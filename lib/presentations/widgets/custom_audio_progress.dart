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
import '../../controllers/playback_controller.dart';
import '../../controllers/story_audio_controller.dart';
import '../../core/config/app_routes/app_routes.dart';
import '../../core/constants/app_colors.dart';
import '../../core/helpers/download_helper.dart';
import '../../core/helpers/toast_message_helper.dart';
import '../../global/custom_assets/assets.gen.dart';
import 'package:intl/intl.dart';
import '../../../services/download_service.dart';

class CustomAudioProgressBar extends StatefulWidget {
  const CustomAudioProgressBar({super.key});

  @override
  State<CustomAudioProgressBar> createState() => _CustomAudioProgressBarState();
}

class _CustomAudioProgressBarState extends State<CustomAudioProgressBar> {
  final AudioBookController controllers = Get.put(AudioBookController());
  final StoryAudioController audioController = Get.put(StoryAudioController());
  final controller = Get.put(AudioController());
  final HomeController homeController = Get.put(HomeController());

  String? storyId;
  bool _isDownloaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final routeData = GoRouterState.of(context).extra as Map;
      storyId = routeData['storyId'];
      homeController.getStorySingle(id: routeData['storyId']);
      controllers.getLibraryStoryData();

      controllers.libraryStoryData.listen((data) {
        if (data.isNotEmpty) {
          final firstStory = data.first;
          if (firstStory.mediaUrl != null && firstStory.mediaUrl!.isNotEmpty) {
            final mediaUrl = firstStory.mediaUrl!.first;
            final isAudio = firstStory.type?.toLowerCase() == 'audio';
            audioController.setMediaPath(mediaUrl, video: !isAudio);
          }
        }
      });
    });
  }

  Future<void> _downloadCurrentMediaForGallery() async {
    try {
      if (controllers.libraryStoryData.isNotEmpty) {
        final currentStory = controllers.libraryStoryData.first;
        final mediaUrl = currentStory.mediaUrl?.isNotEmpty == true
            ? currentStory.mediaUrl!.first
            : null;

        if (mediaUrl != null) {
          Get.snackbar(
            "Downloading...",
            "Please wait while we download your media",
            snackPosition: SnackPosition.BOTTOM,
          );

          bool success = await DownloadService().downloadMedia(
            mediaUrl,
            title: currentStory.caption ?? 'Media',
            subtitle: currentStory.description ?? 'Downloaded from Klokkin App',
            meta: currentStory.duration ?? 'Media',
            hashtags: currentStory.tags?.toString() ?? '',
          );

          if (success) {
            Get.snackbar(
              "Success!",
              "Media downloaded successfully to your gallery",
              backgroundColor: Colors.green,
              snackPosition: SnackPosition.BOTTOM,
            );
          } else {
            Get.snackbar(
              "Download Failed",
              "Could not save media to device",
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        }
      }
    } catch (e) {
      Get.snackbar(
        "Download Error",
        e.toString(),
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controllers.libraryStoryData.isNotEmpty) {
        final firstStory = controllers.libraryStoryData.first;
        if (firstStory.mediaUrl != null && firstStory.mediaUrl!.isNotEmpty) {
          final mediaUrl = firstStory.mediaUrl!.first;
          final isAudio = firstStory.type?.toLowerCase() == 'audio';
          if (audioController.currentTime.value == 0) {
            audioController.setMediaPath(mediaUrl, video: !isAudio);
          }
        }
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              /// Edit Button
              GestureDetector(
                onTap: () {
                  if (controllers.libraryStoryData.isNotEmpty) {
                    final story = controllers.libraryStoryData.first;
                    // Navigate to edit screen
                    context.pushNamed(
                      AppRoutes.storyEditScreen,
                      extra: {
                        'storyId': story.id ?? '',
                        'caption': story.caption ?? '',
                        'description': story.description ?? '',
                        'tags': story.tags ?? [],
                      },
                    );
                  }
                },
                child: SizedBox(
                  width: 44.w,
                  height: 44.h,
                  child: Assets.icons.editImage.svg()
                ),
              ),
              SizedBox(width: 12.w),

              /// Delete Button
              GestureDetector(
                onTap: () => _showDeleteConfirmation(context),
                child: SizedBox(
                  width: 44.w,
                  height: 44.h,
                  child: Assets.icons.deleteimage.svg(),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          /// ---- Top Row (Play/Pause + Slider) ----
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: audioController.togglePlayPause,
                icon: Icon(
                  audioController.isPlaying.value ? Icons.pause : Icons.play_arrow,
                  size: 25,
                  color: AppColors.textColorC2C2C2,
                ),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 1.65.h,
                    activeTrackColor: AppColors.borderColor4D3814,
                    inactiveTrackColor: AppColors.textColor6B6B6B,
                    overlayShape: SliderComponentShape.noOverlay,
                    thumbColor: AppColors.buttonColorE8A533,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
                  ),
                  child: Slider(
                    value: audioController.currentTime.value
                        .clamp(0, audioController.totalTime.value),
                    min: 0,
                    max: audioController.totalTime.value,
                    onChanged: audioController.seek,
                  ),
                ),
              ),
              CustomText(
                text: controllers.libraryStoryData.isNotEmpty &&
                    controllers.libraryStoryData.first.duration != null
                    ? '${controllers.libraryStoryData.first.duration}'
                    : '00:00',
                color: AppColors.textColor919191,
              ),
              SizedBox(width: 15.w),
              GestureDetector(
                onTap: () => _showSettingsBottomSheet(context),
                child: Assets.icons.settings.svg(
                  color: AppColors.textColorFFFFFF,
                ),
              )
            ],
          ),

          SizedBox(height: 32.h),


          /// ---- Info Row ----
          Container(
            width: 390.w,
            padding: EdgeInsets.only(left: 1.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      textAlign: TextAlign.start,
                      text: controllers.libraryStoryData.isNotEmpty &&
                          controllers.libraryStoryData.first.createdAt != null
                          ? 'Post: ${DateFormat("dd MMM yyyy").format(DateTime.parse('${controllers.libraryStoryData.first.createdAt}'))}'
                          : 'Post: --',
                      color: AppColors.textColorFFFFFF,
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    CustomText(
                      textAlign: TextAlign.start,
                      text: controllers.libraryStoryData.isNotEmpty
                          ? '${controllers.libraryStoryData.fold<int>(0, (sum, story) => sum + (story.view ?? 0))} views'
                          : 'N/A',
                      color: AppColors.textColor6B6B6B,
                      fontsize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),

                /// Right Side: Buttons
                Row(
                  children: [
                    /// Share Button
                    GestureDetector(
                      onTap: () {
                        final currentStoryId = controllers.libraryStoryData.isNotEmpty &&
                            controllers.libraryStoryData.first.id != null
                            ? controllers.libraryStoryData.first.id!
                            : '';
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
                    SizedBox(width: 8.w),

                    /// Download Button
                    GestureDetector(
                      onTap: () async {
                        if (controllers.libraryStoryData.isNotEmpty) {
                          final story = controllers.libraryStoryData.first;
                          final mediaUrl = story.mediaUrl?.first;

                          if (mediaUrl == null || mediaUrl.isEmpty) {
                            ToastMessageHelper.showToastMessage('No media available');
                            return;
                          }

                          final fileName = mediaUrl.split('/').last;
                          final filePath = await DownloadHelper.downloadFile(mediaUrl, fileName);

                          if (filePath != null) {
                            setState(() {
                              _isDownloaded = true;
                            });
                          }
                        }
                      },
                      child: Container(
                        width: 104.w,
                        height: 30.h,
                        decoration: BoxDecoration(
                          color: AppColors.textColor323539,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Row(
                          children: [
                            Assets.icons.downloadSimple.svg(
                              color: AppColors.textColorFFFFFF,
                              width: 16.w,
                              height: 16.h,
                            ),
                            SizedBox(width: 4.w),
                            CustomText(
                              text: "DOWNLOAD",
                              color: AppColors.textColorFFFFFF,
                              fontsize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 10.h),

          const Divider(color: AppColors.borderColor4D3814),

          /// Caption
          CustomText(
            textAlign: TextAlign.start,
            text: controllers.libraryStoryData.isNotEmpty
                ? controllers.libraryStoryData.first.caption ?? 'N/A'
                : 'N/A',
            color: AppColors.textColorFFFFFF,
            fontsize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(height: 16.h),

          /// Description
          CustomText(
            textAlign: TextAlign.start,
            text: controllers.libraryStoryData.isNotEmpty
                ? controllers.libraryStoryData.first.description ?? 'N/A'
                : 'N/A',
            color: AppColors.textColor8B8B8B,
            fontsize: 12.sp,
            fontWeight: FontWeight.w400,
            maxline: 10,
          ),
          SizedBox(height: 15.h),

          const Divider(color: AppColors.borderColor4D3814),

          /// Tags
          CustomText(
            textAlign: TextAlign.start,
            text: 'Tags',
            color: AppColors.textColorFFFFFF,
            fontsize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(height: 12.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomText(
                  textAlign: TextAlign.start,
                  text: controllers.libraryStoryData.isNotEmpty
                      ? (controllers.libraryStoryData.first.tags is List)
                      ? (controllers.libraryStoryData.first.tags as List).join(", ")
                      : (controllers.libraryStoryData.first.tags?.toString() ?? 'N/A')
                      : 'N/A',
                  color: AppColors.textColor2165DF,
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              GestureDetector(
                onTap: _downloadCurrentMediaForGallery,
                child: Assets.icons.downloadSimple.svg(
                  color: AppColors.primaryColorC79235,
                  width: 24.w,
                  height: 24.h,
                ),
              ),
            ],
          ),
          SizedBox(height: 100.h),
        ],
      );
    });
  }

  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D0D0D),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      builder: (context) {
        return Container(
          width: 430.w,
          height: 300.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Playback Speed
              GestureDetector(
                onTap: () => _showPlaybackSpeedSheet(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Assets.icons.playCircle.svg(width: 32.w, height: 32.h),
                        SizedBox(width: 12.w),
                        CustomText(
                          text: "Playback Speed",
                          color: AppColors.textColorFFFFFF,
                          fontWeight: FontWeight.w500,
                          fontsize: 20.sp,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CustomText(
                          text: "1X",
                          color: AppColors.textColor8B8B8B,
                          fontWeight: FontWeight.w500,
                          fontsize: 20.sp,
                        ),
                        SizedBox(width: 6.w),
                        Assets.icons.greater.svg(
                          width: 18.w,
                          height: 18.h,
                          color: AppColors.textColor8B8B8B,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 10.h),

              /// Caption
              Row(
                children: [
                  Assets.icons.caption.svg(width: 32.w, height: 32.h),
                  SizedBox(width: 12.w),
                  CustomText(
                    text: "Caption",
                    color: AppColors.textColorFFFFFF,
                    fontWeight: FontWeight.w500,
                    fontsize: 20.sp,
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              /// Lock Screen
              Row(
                children: [
                  Assets.icons.lockKey.svg(width: 32.w, height: 32.h),
                  SizedBox(width: 12.w),
                  CustomText(
                    text: "Lock Screen",
                    color: AppColors.textColorFFFFFF,
                    fontWeight: FontWeight.w500,
                    fontsize: 20.sp,
                  ),
                ],
              ),

              /// Stable Volume
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Assets.icons.volume.svg(width: 32.w, height: 32.h),
                      SizedBox(width: 12.w),
                      CustomText(
                        text: "Stable Volume",
                        color: AppColors.textColorFFFFFF,
                        fontWeight: FontWeight.w500,
                        fontsize: 20.sp,
                      ),
                    ],
                  ),
                  Switch(
                    value: true,
                    activeColor: Colors.orange,
                    onChanged: (val) {},
                  ),
                ],
              ),

              /// Help & Feedback
              Row(
                children: [
                  Assets.icons.help.svg(width: 32.w, height: 32.h),
                  SizedBox(width: 12.w),
                  CustomText(
                    text: "Help & feedback",
                    color: AppColors.textColorFFFFFF,
                    fontWeight: FontWeight.w500,
                    fontsize: 20.sp,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPlaybackSpeedSheet(BuildContext context) {
    final playbackController = Get.put(PlaybackController());

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D0D0D),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      builder: (context) {
        return Obx(() {
          return Container(
            width: 430.w,
            height: 161.h,
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (playbackController.speed.value > 0.25) {
                          playbackController.speed.value -= 0.25;
                        }
                      },
                      child: const CircleAvatar(
                        backgroundColor: AppColors.textColor323539,
                        child: Icon(Icons.remove, color: Colors.white),
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        value: playbackController.speed.value,
                        min: 0.25,
                        max: 2.0,
                        divisions: 7,
                        activeColor: Colors.white,
                        inactiveColor: Colors.grey,
                        onChanged: (value) {
                          playbackController.speed.value = value;
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (playbackController.speed.value < 2.0) {
                          playbackController.speed.value += 0.25;
                        }
                      },
                      child: const CircleAvatar(
                        backgroundColor: AppColors.textColor323539,
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _speedChip("0.25X", playbackController),
                    _speedChip("0.5X", playbackController),
                    _speedChip("1.0X", playbackController),
                    _speedChip("1.5X", playbackController),
                    _speedChip("2.0X", playbackController),
                  ],
                ),
                SizedBox(height: 10.h),
                CustomText(
                  text: playbackController.speed.value == 1.0 ? "Normal" : "",
                  color: Colors.white,
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _speedChip(String text, PlaybackController playbackController) {
    final value = double.parse(text.replaceAll("X", ""));
    return GestureDetector(
      onTap: () => playbackController.speed.value = value,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: playbackController.speed.value == value ? Colors.white24 : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: playbackController.speed.value == value ? Colors.white : Colors.grey,
          ),
        ),
        child: CustomText(
          text: text,
          color: playbackController.speed.value == value ? Colors.white : Colors.grey,
          fontsize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: AppColors.textColor323539,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Container(
            width: 286.w,
            height: 150.h,
            padding: EdgeInsets.all(20.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: "Are you sure you want to delete this story?",
                  color: AppColors.textColorFFFFFF,
                  fontsize: 16.sp,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                  maxline: 2,
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    /// Cancel Button
                    GestureDetector(
                      onTap: () {
                        if (Navigator.canPop(dialogContext)) {
                          Navigator.pop(dialogContext);
                        }
                      },
                      child: Container(
                        width: 100.w,
                        height: 38.h,
                        decoration: BoxDecoration(
                          color: AppColors.textColor6B6B6B,
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        child: Center(
                          child: CustomText(
                            text: "Cancel",
                            color: AppColors.textColorFFFFFF,
                            fontsize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    /// Delete Button
                    Obx(() => GestureDetector(
                      onTap: controllers.deleteStoryLoading.value
                          ? null
                          : () async {
                        if (controllers.libraryStoryData.isNotEmpty) {
                          final storyId = controllers.libraryStoryData.first.id;
                          if (storyId != null) {
                            // Close confirmation dialog first
                            if (Navigator.canPop(dialogContext)) {
                              Navigator.pop(dialogContext);
                            }

                            // Delete the story
                            await controllers.deleteStory(storyId);

                            // Show success dialog
                            if (mounted) {
                              _showDeleteSuccessDialog(context);
                            }
                          }
                        }
                      },
                      child: Container(
                        width: 100.w,
                        height: 38.h,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        child: Center(
                          child: controllers.deleteStoryLoading.value
                              ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : CustomText(
                            text: "Delete",
                            color: AppColors.textColorFFFFFF,
                            fontsize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Delete Success Dialog (Fixed Version)
  void _showDeleteSuccessDialog(BuildContext dialogContext) {
    showDialog(
      context: dialogContext,
      barrierColor: Colors.black.withOpacity(0.7),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.textColor323539,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Container(
            width: 286.w,
            height: 160.h,
            padding: EdgeInsets.all(20.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 59.w,
                  height: 59.h,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColorC79235,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 30.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10.h),
                CustomText(
                  text: "Delete successfully!",
                  color: AppColors.textColorFFFFFF,
                  fontsize: 10.sp,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      // After dialog closes, go back to previous screen
      if (mounted) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            context.pop();
          }
        });
      }
    });

    // Auto close dialog after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    });
  }



}