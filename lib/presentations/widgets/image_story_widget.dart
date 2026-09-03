import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:klokkin_app/services/download_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toastification/toastification.dart';
import '../../core/constants/app_colors.dart';
import '../../core/helpers/time_helper.dart'; // Import helper
import '../../global/custom_assets/assets.gen.dart';
import 'custom_network_image.dart';
import 'custom_text.dart';

class ImageStoryCard extends StatefulWidget {
  final String title;
  final String caption;
  final String imagePath;
  final DateTime? createdAt; // Changed from timestamp
  final String? duration; // Changed from readingTime
  final VoidCallback? onTap;

  const ImageStoryCard({
    super.key,
    required this.title,
    required this.caption,
    required this.imagePath,
    this.createdAt,
    this.duration,
    this.onTap,
  });

  @override
  State<ImageStoryCard> createState() => _ImageStoryCardState();
}

class _ImageStoryCardState extends State<ImageStoryCard> {
  bool _isDownloading = false;

  Future<void> _downloadImage() async {
    if (_isDownloading) return;

    setState(() {
      _isDownloading = true;
    });

    try {
      final downloadService = DownloadService();
      bool success = await downloadService.downloadMedia(
        widget.imagePath,
        title: widget.title,
        subtitle: widget.caption,
        meta: widget.duration ?? '',
        hashtags: 'Image',
      );

      if (success) {
        toastification.show(
          context: context,
          type: ToastificationType.success,
          title: const Text('Download Complete'),
          description: const Text('Image has been saved to your device'),
        );
      } else {
        toastification.show(
          context: context,
          type: ToastificationType.error,
          title: const Text('Download Failed'),
          description: Text(DownloadService().lastError.isNotEmpty
              ? DownloadService().lastError
              : 'Could not save the image. Please try again.'),
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
        width: 188.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          color: AppColors.backgColor20272E,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Image
              SizedBox(
                width: 188.w,
                height: 140.h,
                child: CustomNetworkImage(
                  imageUrl: widget.imagePath,
                  borderRadius: BorderRadius.circular(6.r),
                ),
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
                      maxline: 1,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    CustomText(
                      textAlign: TextAlign.start,
                      text: widget.caption,
                      fontsize: 12.sp,
                      fontWeight: FontWeight.w400,
                      maxline: 2,
                      color: AppColors.textColor919191,
                    ),
                    SizedBox(height: 4.h),

                    /// Time Info Row
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
                        GestureDetector(
                          onTap: _downloadImage,
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