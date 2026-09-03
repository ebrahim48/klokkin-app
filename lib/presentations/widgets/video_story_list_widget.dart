import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:klokkin_app/services/download_service.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../core/constants/app_colors.dart';
import '../../core/helpers/time_helper.dart';
import '../../global/custom_assets/assets.gen.dart';
import 'custom_network_image.dart';
import '../../core/helpers/media_url_helper.dart';
import 'custom_text.dart';

class VideoStoryCard extends StatefulWidget {
  final String title;
  final String imagePath;
  final DateTime? createdAt;
  final String? duration;
  final VoidCallback? onTap;
  final String videoPath;

  const VideoStoryCard({
    super.key,
    required this.title,
    required this.imagePath,
    this.createdAt,
    this.duration,
    required this.videoPath,
    this.onTap,
  });

  @override
  State<VideoStoryCard> createState() => _VideoStoryCardState();
}

class _VideoStoryCardState extends State<VideoStoryCard> {
  bool _isDownloading = false;

  Future<void> _downloadVideo() async {
    if (_isDownloading) return;

    setState(() {
      _isDownloading = true;
    });

    try {
      final downloadService = DownloadService();
      bool success = await downloadService.downloadMedia(
        widget.videoPath,
        title: widget.title,
        subtitle: 'Duration: ${widget.duration ?? "N/A"}',
        meta: 'Video Story',
        hashtags: 'Video,Story',
      );

      if (success) {
        toastification.show(
          context: context,
          type: ToastificationType.success,
          title: const Text('Download Complete'),
          description: const Text('Video has been saved to your device'),
        );
      } else {
        toastification.show(
          context: context,
          type: ToastificationType.error,
          title: const Text('Download Failed'),
          description: Text(DownloadService().lastError.isNotEmpty
              ? DownloadService().lastError
              : 'Could not save the video. Please try again.'),
        );
      }
    } catch (e) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        title: const Text('Download Error'),
        description: Text('Error: $e'),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeAgo = TimeHelper.getTimeAgo(widget.createdAt);
    final readingTime = TimeHelper.getReadingTime(widget.duration);

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 268.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: AppColors.backgColor20272E,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Image + Play Icon
              Stack(
                children: [
                  SizedBox(
                    width: 268.w,
                    height: 180.h,
                    child: CustomNetworkImage(
                      imageUrl: widget.imagePath,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Assets.icons.play.svg(
                        width: 48.w,
                        height: 48.h,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.h),

              /// Content
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: widget.title,
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColorDCDCDC,
                      maxline: 2,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),

                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              CustomText(
                                text: timeAgo,
                                fontsize: 12.sp,
                                fontWeight: FontWeight.w300,
                                color: AppColors.textColor919191,
                              ),
                              if (readingTime.isNotEmpty) ...[
                                SizedBox(width: 6.w),
                                CustomText(
                                  text: '• $readingTime',
                                  fontsize: 12.sp,
                                  fontWeight: FontWeight.w300,
                                  color: AppColors.textColor919191,
                                ),
                              ],
                            ],
                          ),
                        ),
          // Every "video"/"audio" story in the catalogue is a YouTube link,
          // which is a web page rather than a downloadable file. Showing a
          // download button that can only ever fail is exactly the kind of
          // broken feature App Review flags under 2.1(a), so the button is
          // hidden for streamed stories and shown for real files.
          if (!MediaUrlHelper.isYoutubeLink(widget.videoPath))
                        GestureDetector(
                          onTap: _downloadVideo,
                          child: Container(
                            padding: EdgeInsets.all(4.r),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColorC79235.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: _isDownloading
                                ? SpinKitCircle(
                              size: 16.sp,
                              color: AppColors.primaryColorC79235,
                            )
                                : Assets.icons.downloadSimple.svg(
                              color: AppColors.primaryColorC79235,
                              width: 16.w,
                              height: 16.h,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 6.h),
            ],
          ),
        ),
      ),
    );
  }
}