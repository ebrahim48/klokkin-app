import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../controllers/home_controller.dart';
import '../../core/constants/app_colors.dart';
import 'custom_text.dart';
import 'custom_network_image.dart';

class EveryStoryCard extends StatefulWidget {
  final String caption;
  final String imagePath;
  final String storyId;
  final VoidCallback? onTap;

  const EveryStoryCard({
    super.key,
    required this.caption,
    required this.imagePath,
    required this.storyId,
    this.onTap,
  });

  @override
  State<EveryStoryCard> createState() => _EveryStoryCardState();
}

class _EveryStoryCardState extends State<EveryStoryCard> {
  final homeController = Get.find<HomeController>();

  bool _isVideoUrl(String url) {
    return url.contains('.m3u8') ||
        url.contains('.mp4') ||
        url.contains('/video/');
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
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Video/Image Section
              Expanded(
                child: Obx(() {
                  final isInitialized = homeController.isInitializedStates[widget.storyId] == true;
                  final controller = homeController.videoControllers[widget.storyId];
                  final isPlaying = homeController.playStates[widget.storyId] == true;

                  return Stack(
                    children: [
                      // Display Video or Image
                      Positioned.fill(
                        child: isInitialized && controller != null
                            ? AspectRatio(
                          aspectRatio: controller.value.aspectRatio,
                          child: VideoPlayer(controller),
                        )
                            : CustomNetworkImage(
                          imageUrl: _isVideoUrl(widget.imagePath)
                              ? "https://via.placeholder.com/235x130/20272E/FFFFFF?text=Video"
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
                                Colors.black.withOpacity(0.5),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Play/Pause Button - ALWAYS VISIBLE
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            final isInitialized = homeController.isInitializedStates[widget.storyId] == true;

                            // Initialize video if not already done
                            if (!isInitialized && _isVideoUrl(widget.imagePath)) {
                              homeController.setVideoPath(widget.storyId, widget.imagePath);
                              // Wait a bit for initialization before playing
                              Future.delayed(Duration(milliseconds: 500), () {
                                homeController.togglePlayPause(widget.storyId);
                              });
                            } else {
                              homeController.togglePlayPause(widget.storyId);
                            }
                          },
                          child: Container(
                            width: 50.w,
                            height: 50.w,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColorC79235,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              size: 30.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
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