import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klokkin_app/services/download_service.dart';
import 'package:toastification/toastification.dart';
import '../../core/constants/app_colors.dart';
import 'custom_text.dart';
import 'custom_network_image.dart';

class LatestCard extends StatefulWidget {
  final String title;
  final String caption;
  final String imagePath;
  final VoidCallback? onTap;

  const LatestCard({
    super.key,
    required this.title,
    required this.caption,
    required this.imagePath,
    this.onTap,
  });

  @override
  State<LatestCard> createState() => _LatestCardState();
}

class _LatestCardState extends State<LatestCard> {
  bool _isDownloading = false;

  Future<void> _downloadImage() async {
    if (_isDownloading) return; // Prevent multiple simultaneous downloads
    
    setState(() {
      _isDownloading = true;
    });

    try {
      final downloadService = DownloadService();
      bool success = await downloadService.downloadMedia(
        widget.imagePath,
        title: widget.title,
        subtitle: widget.caption,
        meta: 'Latest Image',
        hashtags: 'Latest',
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
          description: const Text('Could not save image to device'),
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
        width: 140.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          color: AppColors.textColorFFFFFF,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// =============================> Image with overlay ========================>
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomNetworkImage(
                        imageUrl: widget.imagePath,
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    Positioned(
                      top: 16,
                      left: 8,
                      right: 8,
                      child: Container(
                        height: 24.h,
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        decoration: BoxDecoration(
                          color: AppColors.textColorFFFFFF.withOpacity(0.1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CustomText(
                                textAlign: TextAlign.start,
                                text: widget.title,
                                color: AppColors.textColorFFFFFF,
                                fontsize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            GestureDetector(
                              onTap: _downloadImage,
                              child: _isDownloading
                                  ? Icon(
                                      Icons.downloading,
                                      color: AppColors.textColorFFFFFF,
                                      size: 16.w,
                                    )
                                  : SvgPicture.asset(
                                      "assets/icons/downloadSimple.svg",
                                      width: 16.w,
                                      height: 16.h,
                                      color: AppColors.textColorFFFFFF,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 6.h),

              // Bottom caption
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(6.w),
                color: AppColors.textColorFFFFFF,
                child: CustomText(
                  text: widget.caption,
                  fontsize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColor000000,
                ),
              ),
              SizedBox(height: 14.h),
            ],
          ),
        ),
      ),
    );
  }
}
