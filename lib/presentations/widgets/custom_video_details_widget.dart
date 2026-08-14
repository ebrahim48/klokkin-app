import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import 'package:klokkin_app/services/api_constants.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import '../../controllers/audio_book_controller.dart';
import '../../controllers/home_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../../services/download_service.dart';

class CustomVideoDetailsProgressBar extends StatefulWidget {
  final VideoPlayerController? videoController;
  final String title;
  final String duration;
  final String storyId;
  final String description;
  final List<String> tags;

  const CustomVideoDetailsProgressBar({
    super.key,
    this.videoController,
    required this.title,
    required this.duration,
    required this.storyId,
    this.description = 'N/A',
    this.tags = const [],
  });

  @override
  State<CustomVideoDetailsProgressBar> createState() =>
      _CustomVideoDetailsProgressBarState();
}

class _CustomVideoDetailsProgressBarState
    extends State<CustomVideoDetailsProgressBar> {
  final AudioBookController controllers = Get.put(AudioBookController());
  final HomeController homeController = Get.put(HomeController());

  double _currentPosition = 0.0;
  double _totalDuration = 0.0;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    // Listen to video player updates
    widget.videoController?.addListener(_videoListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeController.getStorySingle(id: widget.storyId);
    });
  }

  void _videoListener() {
    if (widget.videoController != null && mounted) {
      setState(() {
        _currentPosition =
            widget.videoController!.value.position.inSeconds.toDouble();
        _totalDuration =
            widget.videoController!.value.duration.inSeconds.toDouble();
        _isPlaying = widget.videoController!.value.isPlaying;
      });
    }
  }

  @override
  void dispose() {
    widget.videoController?.removeListener(_videoListener);
    super.dispose();
  }

  String _formatTime(double seconds) {
    if (seconds.isNaN || seconds.isInfinite) return "0:00";
    final m = (seconds ~/ 60).toString();
    final s = (seconds % 60).toInt().toString().padLeft(2, '0');
    return "$m:$s";
  }

  Future<void> _downloadCurrentMedia() async {
    // Get media URL from the video controller's data source.
    final mediaUrl = widget.videoController?.dataSource;

    // Guard the empty case BEFORE showing "Downloading...". Previously a null
    // url silently skipped the whole block, so the button looked dead — the
    // exact "download button not functional" the reviewer reported (2.1(a)).
    if (mediaUrl == null || mediaUrl.isEmpty) {
      Get.snackbar(
        "Nothing to download",
        "This media is still loading or has no downloadable file.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      Get.snackbar(
        "Downloading...",
        "Please wait while we download your media",
        snackPosition: SnackPosition.BOTTOM,
      );

      bool success = await DownloadService().downloadMedia(
        mediaUrl,
        title: widget.title,
        subtitle: widget.description,
        meta: widget.duration,
        hashtags: widget.tags.join(', '),
      );

      if (success) {
        Get.snackbar(
          "Success!",
          "Media downloaded successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Download Failed",
          "Could not save media to device. Please allow Photos access and try again.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Download Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _togglePlayPause() {
    if (widget.videoController != null) {
      setState(() {
        if (_isPlaying) {
          widget.videoController!.pause();
        } else {
          widget.videoController!.play();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Controls Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: _togglePlayPause,
              icon: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                size: 25,
                color: AppColors.textColorC2C2C2,
              ),
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
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
                ),
                child: Slider(
                  value: _currentPosition.clamp(0, _totalDuration),
                  min: 0,
                  max: _totalDuration > 0 ? _totalDuration : 1,
                  onChanged: (value) {
                    widget.videoController?.seekTo(
                      Duration(seconds: value.toInt()),
                    );
                  },
                ),
              ),
            ),

            SizedBox(width: 15.w),

            /// Share Button
            GestureDetector(
              onTap: () {
                if (widget.storyId.isNotEmpty) {
                  homeController.share(widget.storyId);
                  Share.share(
                    'Check this out: ${ApiConstants.baseUrl}/story/story/${widget.storyId}',
                    subject: 'Share Video',
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

        /// Time Display
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: _formatTime(_currentPosition),
              color: AppColors.textColorFFFFFF,
              fontsize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
            Padding(
              padding: EdgeInsets.only(left: 100.w),
              child: CustomText(
                text: _formatTime(_totalDuration),
                color: AppColors.textColorFFFFFF,
                fontsize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),

        SizedBox(height: 28.h),

        /// Title
        CustomText(
          textAlign: TextAlign.start,
          text: widget.title,
          color: AppColors.textColorFFFFFF,
          fontsize: 24.sp,
          fontWeight: FontWeight.w500,
          maxline: 2,
        ),

        SizedBox(height: 17.h),

        /// Description
        CustomText(
          textAlign: TextAlign.start,
          text: widget.description,
          color: AppColors.textColorFFFFFF,
          fontsize: 16.sp,
          fontWeight: FontWeight.w400,
          maxline: 10,
        ),

        SizedBox(height: 17.h),

        /// Tags & Download
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Wrap(
                spacing: 8.w,
                children:
                    widget.tags.map((tag) {
                      return CustomText(
                        text: tag,
                        color: AppColors.textColor2165DF,
                        fontsize: 14.sp,
                        fontWeight: FontWeight.w400,
                      );
                    }).toList(),
              ),
            ),
            GestureDetector(
              onTap: _downloadCurrentMedia,
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
  }
}
