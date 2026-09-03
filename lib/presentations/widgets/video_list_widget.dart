import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import 'package:klokkin_app/core/helpers/time_helper.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import 'package:klokkin_app/services/download_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toastification/toastification.dart';
import '../../global/custom_assets/assets.gen.dart';
import 'custom_network_image.dart';
import '../../core/helpers/media_url_helper.dart';

class VideoListCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final DateTime? createdAt;
  final String? duration;
  final String hashtags;
  final String imagePath;
  final String videoPath;
  final VoidCallback? onTap;

  const VideoListCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.createdAt,
    this.duration,
    required this.hashtags,
    required this.imagePath,
    required this.videoPath,
    this.onTap,
  });

  @override
  State<VideoListCard> createState() => _VideoListCardState();
}

class _VideoListCardState extends State<VideoListCard> {
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
        subtitle: widget.subtitle,
        meta: widget.duration ?? '',
        hashtags: widget.hashtags,
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
      child: Column(
        children: [
          Row(
            children: [
              /// Video Thumbnail with Play Icon
              Stack(
                children: [
                  Container(
                    width: 124.w,
                    height: 90.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: CustomNetworkImage(
                      imageUrl: widget.imagePath,
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Assets.icons.play.svg(
                        width: 40.w,
                        height: 40.h,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(width: 12.w),

              /// Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: widget.title,
                      color: AppColors.textColorDCDCDC,
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w500,
                      maxline: 1,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    CustomText(
                      textAlign: TextAlign.start,
                      text: widget.subtitle,
                      color: AppColors.textColor919191,
                      fontsize: 12.sp,
                      fontWeight: FontWeight.w400,
                      maxline: 2,
                    ),
                    SizedBox(height: 10.h),

                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              CustomText(
                                text: timeAgo,
                                color: AppColors.textColor8C8C8C,
                                fontsize: 11.sp,
                                fontWeight: FontWeight.w300,
                              ),
                              if (readingTime.isNotEmpty) ...[
                                SizedBox(width: 4.w),
                                CustomText(
                                  text: '• $readingTime',
                                  fontsize: 11.sp,
                                  fontWeight: FontWeight.w300,
                                  color: AppColors.textColor8C8C8C,
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
                    SizedBox(height: 4.h),
                    CustomText(
                      text: widget.hashtags,
                      color: AppColors.textColor2165DF,
                      fontsize: 11.sp,
                      fontWeight: FontWeight.w400,
                      maxline: 1,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          Divider(
            color: AppColors.secondary836531,
            height: 0.4.h,
            thickness: 0.6,
          ),
        ],
      ),
    );
  }
}