import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  // Check if URL is a video
  bool _isVideoUrl(String url) {
    return url.contains('.m3u8') ||
        url.contains('.mp4') ||
        url.contains('/video/');
  }

  @override
  Widget build(BuildContext context) {
    // Use placeholder for video URLs
    final displayImage =
        _isVideoUrl(widget.imagePath) ? "" : widget.imagePath;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 140.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          color: AppColors.backgColor20272E,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Image Section
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: CustomNetworkImage(
                        imageUrl: displayImage,
                        borderRadius: BorderRadius.zero,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // Title Overlay
                    Positioned(
                      top: 8.h,
                      left: 8.w,
                      right: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: CustomText(
                          textAlign: TextAlign.start,
                          text: widget.title,
                          color: AppColors.textColorFFFFFF,
                          fontsize: 11.sp,
                          fontWeight: FontWeight.w500,
                          maxline: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Caption Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.backgColor20272E,
                  border: Border(
                    top: BorderSide(
                      color: AppColors.primaryColorC79235.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
                child: CustomText(
                  text: widget.caption,
                  fontsize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColorC2C2C2,
                  maxline: 2,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}