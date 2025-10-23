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
import '../../core/constants/app_colors.dart';
import '../../core/helpers/download_helper.dart';
import '../../core/helpers/toast_message_helper.dart';
import '../../global/custom_assets/assets.gen.dart';
import 'package:intl/intl.dart';

class CustomAudioProgressBar extends StatefulWidget {
   CustomAudioProgressBar({super.key});


  @override
  State<CustomAudioProgressBar> createState() => _CustomAudioProgressBarState();
}

class _CustomAudioProgressBarState extends State<CustomAudioProgressBar> {

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
    final controller = Get.put(StoryAudioController());
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

              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 1.65.h,
                    activeTrackColor: AppColors.borderColor4D3814,
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
              CustomText(
                  text: '${controllers.libraryStoryData.value.first.duration}',
                  color: AppColors.textColor919191),
              SizedBox(width: 15.w),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor:  const Color(0xFF0D0D0D),
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
                              onTap: () {
                                _showPlaybackSpeedSheet(context);
                              },
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
                                CustomText(text: "Caption",
                                  color: AppColors.textColorFFFFFF,
                                  fontWeight: FontWeight.w500,
                                  fontsize: 20.sp,),
                              ],
                            ),
                            SizedBox(height: 10.h),

                            /// Lock Screen
                            Row(
                              children: [
                                Assets.icons.lockKey.svg(width: 32.w, height: 32.h),
                                SizedBox(width: 12.w),
                                CustomText(text: "Lock Screen",
                                  color: AppColors.textColorFFFFFF,
                                  fontWeight: FontWeight.w500,
                                  fontsize: 20.sp,),
                              ],
                            ),


                            /// Stable Volume (Switch)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Assets.icons.volume.svg(width: 32.w, height: 32.h),
                                    SizedBox(width: 12.w),
                                    CustomText(text: "Stable Volume",
                                      color: AppColors.textColorFFFFFF,
                                      fontWeight: FontWeight.w500,
                                      fontsize: 20.sp),
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
                                CustomText(text: "Help & feedback",
                                  color: AppColors.textColorFFFFFF,
                                  fontWeight: FontWeight.w500,
                                  fontsize: 20.sp,),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Assets.icons.settings.svg(
                  color: AppColors.textColorFFFFFF,
                ),
              )


            ],
          ),

          SizedBox(height: 32.h),

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
                      text: 'Post: ${DateFormat("dd MMM yyyy").format(DateTime.parse('${controllers.libraryStoryData.value.first.createdAt}'))}',
                      color: AppColors.textColorFFFFFF,
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    CustomText(
                      textAlign: TextAlign.start,
                      text: '${controllers.libraryStoryData.value.first.view ?? 'N/A'}',
                      color: AppColors.textColor6B6B6B,
                      fontsize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),

                /// Right Side: Buttons
                Row(
                  children: [
                    /// ===== SHARE BUTTON =====

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

                    SizedBox(width: 8.w),

                    /// ========================================>  Download  ===================================>

                    // Inside your GestureDetector for the main DOWNLOAD button
                    GestureDetector(
                      onTap: () async {
                        final story = controllers.libraryStoryData.first;
                        final mediaUrl = story.mediaUrl?.first;

                        if (mediaUrl == null || mediaUrl.isEmpty) {
                          ToastMessageHelper.showToastMessage('success');
                          return;
                        }

                        // Extract file name from URL (e.g., "story123.mp3")
                        final fileName = mediaUrl.split('/').last;

                        // Start download
                        final filePath = await DownloadHelper.downloadFile(mediaUrl, fileName);

                        if (filePath != null) {
                          // Optional: store path to show "Downloaded" badge
                          setState(() {
                            _isDownloaded = true;
                          });

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


          const Divider(
            color: AppColors.borderColor4D3814,
          ),
          CustomText(
            textAlign: TextAlign.start,
            text:  controllers.libraryStoryData.first.caption ?? 'N/A',
            color: AppColors.textColorFFFFFF,
            fontsize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(height: 16.h),
          CustomText(
            textAlign: TextAlign.start,
            text: controllers.libraryStoryData.first.description ?? 'N/A',
            color: AppColors.textColor8B8B8B,
            fontsize: 12.sp,
            fontWeight: FontWeight.w400,
            maxline: 10,
          ),
          SizedBox(height: 15.h),
          const Divider(
            color: AppColors.borderColor4D3814,
          ),
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

              CustomText(
                text: (controllers.libraryStoryData.first.tags is List)
                    ? (controllers.libraryStoryData.first.tags as List).join(", ")
                    : (controllers.libraryStoryData.first.tags?.toString() ?? 'N/A'),
                color: AppColors.textColor2165DF,
                fontsize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              GestureDetector(
                onTap: () {

                },
                child: Assets.icons.downloadSimple.svg(
                    color: AppColors.primaryColorC79235,
                  width: 24.w,
                  height: 24.h
                ),
              ),
            ],
          ),
          SizedBox(height: 100.h),

        ],
      );
    });
  }

  void _showPlaybackSpeedSheet(BuildContext context) {
    final controller = Get.put(PlaybackController());

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
                /// Slider Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (controller.speed.value > 0.25) {
                          controller.speed.value -= 0.25;
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: AppColors.textColor323539,
                        child: Icon(Icons.remove, color: Colors.white),
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        value: controller.speed.value,
                        min: 0.25,
                        max: 2.0,
                        divisions: 7,
                        activeColor: Colors.white,
                        inactiveColor: Colors.grey,
                        onChanged: (value) {
                          controller.speed.value = value;
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (controller.speed.value < 2.0) {
                          controller.speed.value += 0.25;
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: AppColors.textColor323539,
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                /// Speed Options
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _speedChip("0.25X", controller),
                    _speedChip("0.5X", controller),
                    _speedChip("1.0X", controller),
                    _speedChip("1.5X", controller),
                    _speedChip("2.0X", controller),
                  ],
                ),

                SizedBox(height: 10.h),
                CustomText(
                  text: controller.speed.value == 1.0 ? "Normal" : "",
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

  Widget _speedChip(String text, PlaybackController controller) {
    final value = double.parse(text.replaceAll("X", ""));
    return GestureDetector(
      onTap: () => controller.speed.value = value,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: controller.speed.value == value ? Colors.white24 : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: controller.speed.value == value ? Colors.white : Colors.grey,
          ),
        ),
        child: CustomText(
          text: text,
          color: controller.speed.value == value ? Colors.white : Colors.grey,
          fontsize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
