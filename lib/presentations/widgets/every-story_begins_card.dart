import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/config/app_routes/app_routes.dart';
import '../../core/constants/app_colors.dart';
import 'custom_text.dart';
import 'custom_network_image.dart';

class EveryStoryCard extends StatefulWidget {
  final String caption;
  final String imagePath;
  final String storyId;
  final String? videoUrl;
  final VoidCallback? onTap;

  const EveryStoryCard({
    super.key,
    required this.caption,
    required this.imagePath,
    required this.storyId,
    this.videoUrl,
    this.onTap,
  });

  @override
  State<EveryStoryCard> createState() => _EveryStoryCardState();
}

class _EveryStoryCardState extends State<EveryStoryCard> {
  bool _isVideoUrl(String url) {
    return url.contains('.m3u8') ||
        url.contains('.mp4') ||
        url.contains('/video/');
  }

  void _openVideoFullScreen() {
    if (widget.videoUrl != null && widget.videoUrl!.isNotEmpty) {
      // Navigate to full screen video player
      context.pushNamed(
        AppRoutes.videoPlayerScreen,
        extra: {
          "videoUrl": widget.videoUrl!,
          "title": widget.caption,
          "duration": "Story",
          "thumbnail": widget.imagePath,
        },
      );
    } else {
      // Fallback to story screen if no video URL
      context.pushNamed(
        AppRoutes.everyStoryScreen,
        extra: {
          "title": "Every story begins with a step",
          "storyId": widget.storyId,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 235.w,
        height: 179.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: AppColors.backgColor20272E,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Video/Image Section
              Expanded(
                child: Stack(
                  children: [
                    // Display Thumbnail
                    Positioned.fill(
                      child: CustomNetworkImage(
                        imageUrl: _isVideoUrl(widget.imagePath)
                            ? ""
                            : widget.imagePath,
                        borderRadius: BorderRadius.zero,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // Dark Overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.4),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Play Button - Center (Opens Full Screen)
                    Center(
                      child: GestureDetector(
                        onTap: _openVideoFullScreen,
                        child: Container(
                          width: 56.w,
                          height: 56.w,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColorC79235.withOpacity(0.95),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.play_arrow_rounded,
                            size: 32.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Caption Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: const BoxDecoration(
                  color: AppColors.primaryColorC79235,
                ),
                child: CustomText(
                  textAlign: TextAlign.start,
                  text: widget.caption,
                  fontsize: 12.sp,
                  maxline: 2,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor000000,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}