import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:klokkin_app/services/download_service.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../core/constants/app_colors.dart';
import '../../global/custom_assets/assets.gen.dart';
import 'custom_network_image.dart';
import 'custom_text.dart';

class VideoStoryCard extends StatefulWidget {
  final String title;
  final String imagePath;
  final String timestamp;
  final VoidCallback? onTap;
  final String videoPath;

  const VideoStoryCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.timestamp,
    required this.videoPath,
    this.onTap,
  });

  @override
  State<VideoStoryCard> createState() => _VideoStoryCardState();
}

class _VideoStoryCardState extends State<VideoStoryCard> {
  bool _isDownloading = false;

  Future<void> _downloadVideo() async {
    if (_isDownloading) return; // Prevent multiple simultaneous downloads
    
    setState(() {
      _isDownloading = true;
    });

    try {
      final downloadService = DownloadService();
      bool success = await downloadService.downloadMedia(
        widget.videoPath,
        title: widget.title,
        subtitle: 'Duration: ${widget.timestamp}',
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
          description: const Text('Could not save video to device'),
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
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 268.w,
        height: 280.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: AppColors.backgColor20272E,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// =============================> Image + Play Icon ========================>
              Stack(
                children: [

                  Container(
                    width: 268.w,
                    height: 180.h,
                    child: CustomNetworkImage(
                      imageUrl: widget.imagePath,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),

                  /// Play Icon Centered
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

              // =====================> Title and Info =====================>
              Padding(
                padding: EdgeInsets.only(left: 2.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      textAlign: TextAlign.start,
                      text: widget.title,
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColorDCDCDC,
                    ),
                    SizedBox(height: 6.h),

                    Padding(
                      padding: EdgeInsets.all(3.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: widget.timestamp,
                            fontsize: 12.sp,
                            fontWeight: FontWeight.w300,
                            color: AppColors.textColor919191,
                          ),
                          SizedBox(width: 8.w),
                          const Spacer(),
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
                                    ),
                            ),
                          )
                        ],
                      ),
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
