import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/services/api_constants.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

import '../../controllers/audio_controller.dart';
import '../../controllers/home_controller.dart';
import '../../core/constants/app_colors.dart';
import 'custom_loader.dart';
import 'custom_network_image.dart';
import 'custom_text.dart';
import 'youtube_media_player.dart';

class AudioProgressBar extends StatefulWidget {
  const AudioProgressBar({super.key});

  @override
  State<AudioProgressBar> createState() => _AudioProgressBarState();
}

class _AudioProgressBarState extends State<AudioProgressBar> {
  final controller = Get.put(AudioController());
  final HomeController homeController = Get.put(HomeController());
  String? storyId;

  // Guard so media is prepared exactly once per distinct URL — without
  // this, calling setMediaPath from build() would re-create the player on
  // every rebuild while it was still initializing.
  String? _mediaPreparedFor;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final routeData = GoRouterState.of(context).extra as Map;
      storyId = routeData['storyId'];
      // Fetched once here (not in build) — see every_story_screen.dart.
      homeController.getStorySingle(id: routeData['storyId']);
    });
  }

  bool _looksLikeVideo(String url) {
    final u = url.toLowerCase();
    return u.endsWith('.mp4') ||
        u.endsWith('.m3u8') ||
        u.endsWith('.mov') ||
        u.endsWith('.webm') ||
        u.contains('/video/');
  }

  /// Prepare the player as soon as the story (and its media URL) is known,
  /// so the very first tap on play actually plays. Safe to call from build:
  /// it no-ops once the URL has been prepared.
  void _ensureMediaPrepared(String url) {
    if (_mediaPreparedFor == url) return;
    _mediaPreparedFor = url;
    final isVid = _looksLikeVideo(url);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.setMediaPath(url, video: isVid);
    });
  }

  String _formatTime(double seconds) {
    if (seconds.isNaN || seconds < 0) seconds = 0;
    final total = seconds.floor();
    final m = (total ~/ 60).toString();
    final s = (total % 60).toString().padLeft(2, '0');
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

      final mediaUrl =
          (story.mediaUrl != null && story.mediaUrl!.isNotEmpty)
              ? story.mediaUrl!.first
              : null;
      // YouTube-backed stories (official trailers / songs) play through
      // the embedded YouTube player, which brings its own reliable
      // play/pause + progress UI — so the custom controls below are
      // hidden for them.
      final bool isYt = isYoutubeUrl(mediaUrl);
      if (mediaUrl != null && !isYt) _ensureMediaPrepared(mediaUrl);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Media: YouTube (trailers/songs) OR file/image
          isYt
              ? YoutubeMediaPlayer(
                  url: mediaUrl!,
                  audioOnly:
                      (story.type ?? '').toLowerCase() == 'audio',
                  artworkUrl: story.thumbnail,
                )
              : Stack(
            children: [
              Obx(() {
                if (controller.isVideo.value) {
                  if (controller.isInitialized.value) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: AspectRatio(
                        aspectRatio:
                            controller.videoController.value.aspectRatio,
                        child: VideoPlayer(controller.videoController),
                      ),
                    );
                  } else {
                    return const Center(child: CustomLoader());
                  }
                } else {
                  // Audio (or not-yet-initialized): show the story's
                  // thumbnail as cover art — NOT mediaUrl, which for audio
                  // is an .mp3 and would render as a broken image.
                  final poster = (story.thumbnail != null &&
                          story.thumbnail!.isNotEmpty)
                      ? story.thumbnail!
                      : ((story.mediaUrl != null &&
                              story.mediaUrl!.isNotEmpty &&
                              !_looksLikeVideo(story.mediaUrl!.first) &&
                              !story.mediaUrl!.first
                                  .toLowerCase()
                                  .endsWith('.mp3'))
                          ? story.mediaUrl!.first
                          : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png");
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: CustomNetworkImage(
                      imageUrl: poster,
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

          if (!isYt) ...[
          SizedBox(height: 16.h),

          // Controls Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () async {
                  if (mediaUrl == null) return;
                  if (!controller.isInitialized.value) {
                    await controller.loadAndPlay(
                      mediaUrl,
                      video: _looksLikeVideo(mediaUrl),
                    );
                  } else {
                    await controller.togglePlayPause();
                  }
                },
                icon: Obx(() {
                  if (controller.isBuffering.value &&
                      !controller.isPlaying.value) {
                    return SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.textColorC2C2C2,
                      ),
                    );
                  }
                  return Icon(
                    controller.isPlaying.value
                        ? Icons.pause
                        : Icons.play_arrow,
                    size: 25,
                    color: AppColors.textColorC2C2C2,
                  );
                }),
              ),
              SizedBox(width: 5.w),

              /// ======================================> Speed ==================================>
              Obx(
                () => CustomText(
                  text: controller.formatSpeed(controller.playbackSpeed.value),
                  color: AppColors.textColorFFFFFF,
                  fontsize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(width: 10.w),

              // Slider
              Expanded(
                child: Obx(() {
                  // Single source of truth (driven by the player listener)
                  // so the slider, the ▶/⏸ icon and both timestamps always
                  // agree.
                  final double max =
                      controller.totalTime.value > 0
                          ? controller.totalTime.value
                          : 1.0;
                  final double value =
                      controller.currentTime.value.clamp(0.0, max);

                  return SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 1.65.h,
                      activeTrackColor: AppColors.textColorFFFFFF,
                      inactiveTrackColor: AppColors.textColor6B6B6B,
                      overlayShape: SliderComponentShape.noOverlay,
                      thumbColor: AppColors.buttonColorE8A533,
                      thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 6.r,
                      ),
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
                      'Check this out:\n ${ApiConstants.baseUrl}/story/story/$currentStoryId',
                      subject:
                          controller.isVideo.value
                              ? 'Share Video'
                              : 'Share Audio',
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
          ],
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
                  children:
                      (story.tags ?? [])
                          .map(
                            (tag) => GestureDetector(
                              onTap: () => print("$tag tapped"),
                              child: CustomText(
                                text: tag,
                                color: AppColors.textColor2165DF,
                                fontsize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),

              // Download Icon (optional functionality)
              GestureDetector(
                onTap: () {},
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
